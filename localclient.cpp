#include "localclient.h"

LocalClient::LocalClient(QObject *parent) : QObject(parent)
{
    timeoutCount=0;
    m_socket = new QLocalSocket(this);

    connect(m_socket, SIGNAL(connected()), this,SLOT(socketConnectedHandler()));
    connect(m_socket, SIGNAL(disconnected()), SLOT(socketDisConnectedHandler()));
    connect(m_socket, SIGNAL(error(QLocalSocket::LocalSocketError)), SLOT(socketErrorHandler(QLocalSocket::LocalSocketError)));
//    connect(m_socket, SIGNAL(stateChanged(QLocalSocket::LocalSocketState)), SLOT(stateChangedHandler(QLocalSocket::LocalSocketState)));

    connect(m_socket, SIGNAL(readyRead()), this,SLOT(readyReadHandler()));

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &LocalClient::connectToServer);
    qDebug() << "UNIX_DOMAIN:" << UNIX_DOMAIN;
    qDebug() << "readBufferSize:" << m_socket->readBufferSize();
    m_socket->setReadBufferSize(10240*5);
    qDebug() << "readBufferSize:" << m_socket->readBufferSize();
}

LocalClient::~LocalClient()
{
    timer->stop();
    delete timer;
    delete m_socket;
}

void LocalClient::startConnectTimer()
{
#ifdef USE_RK3308
    if(!timer->isActive())
        timer->start(1500);
#endif
}
int LocalClient::seqid=0;

void LocalClient::connectToServer()
{
    qDebug("connectToServer start");
    m_socket->connectToServer(UNIX_DOMAIN);
    ++timeoutCount;
    if(timeoutCount==5)
    {
#ifdef USE_RK3308
        emit sendConnected(0);
#endif
    }
    //    qDebug("connectToServer end");

    //    if (m_socket->waitForConnected(-1))
    //    {
    //        qDebug("Connected!");
    //    }
    //    qDebug("connectToServer fail!");
}

unsigned char CheckSum(unsigned char *buf, int len) //和校验算法
{
    unsigned char ret = 0;
    for (int i = 0; i < len; ++i)
    {
        ret += *(buf++);
    }
    return ret;
}

int LocalClient::sendMessage(const QString& data)
{
    if(QLocalSocket::ConnectedState!=m_socket->state())
    {
        qDebug() << "sendMessage error: UnconnectedState";
        return -1;
    }
    QByteArray msg=data.toUtf8();
    unsigned short msg_len=msg.size();
    QByteArray buf;
    buf.append(FRAME_HEADER);
    buf.append(FRAME_HEADER);
    buf.append((char)0);
    buf.append(seqid/256);
    buf.append(seqid%256);
    buf.append(msg_len/256);
    buf.append(msg_len%256);
    buf.append(msg);
    unsigned char verify= CheckSum((unsigned char *)(&buf.constData()[2]),msg_len+5);
    buf.append((char)verify);
    buf.append(FRAME_TAIL);
    buf.append(FRAME_TAIL);
    qDebug() << "sendMessage :" << buf << "size:" <<buf.size() << "msg size:" <<msg_len<< "seqid:"<<seqid;
    int write_len= m_socket->write(buf);
    ++seqid;
    //    m_socket->flush();
    //    m_socket->waitForBytesWritten(2000);
    return write_len;
}

void LocalClient::close()
{
    m_socket->close();
}

void LocalClient::socketConnectedHandler()
{
    qDebug() << "socketConnectedHandler";
    timer->stop();
    timeoutCount=0;
    emit sendConnected(1);
}

void LocalClient::socketDisConnectedHandler()
{
    qDebug() << "socketDisConnectedHandler";
    close();
    emit sendConnected(0);
    if(!timer->isActive())
    {
        timer->start();
    }
}

void LocalClient::socketErrorHandler(QLocalSocket::LocalSocketError error)
{
    qDebug() << "socketErrorHandler: " << error;
}

void LocalClient::stateChangedHandler(QLocalSocket::LocalSocketState socketState)
{
    qDebug() << "stateChangedHandler: " << socketState;
    if(QLocalSocket::UnconnectedState==socketState)
    {

    }
    else if(QLocalSocket::ConnectedState==socketState)
    {
        qDebug() << "ConnectedState.......";
    }
}

void LocalClient::readyReadHandler()
{
//    qDebug() << "readyReadHandler";

    //    if(m_socket->bytesAvailable()<=0)
    //    {
    //        if(m_socket->waitForReadyRead(-1)==false)
    //        {
    //            qDebug() << "waitForReadyRead error";
    //            return -1;
    //        }
    //    }

    qDebug() << "recv_data bytesAvailable" << m_socket->bytesAvailable();
    QByteArray recv_data=m_socket->readAll();
    int recv_data_size=recv_data.size();
    if(recv_data_size<=0)
    {
        qDebug() << "recv_data error";
        return;
    }
    qDebug() << "recv_data:" <<recv_data << ",recv_data size:" << recv_data_size;

    emit sendData(recv_data);
}

