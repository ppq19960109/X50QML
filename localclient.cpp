#include "localclient.h"
#define TYPE "Type"
#define TYPE_SET "SET"
#define TYPE_GET "GET"
#define TYPE_GETALL "GETALL"
#define TYPE_EVENT "EVENT"

LocalClient::LocalClient(QObject *parent) : QObject(parent)
{
    timeoutCount=0;
    m_socket = new QLocalSocket();
    qDebug() << "readBufferSize:" <<m_socket->readBufferSize();
    qDebug() << "UNIX_DOMAIN:" << UNIX_DOMAIN;
    connect(m_socket, SIGNAL(connected()), this,SLOT(socketConnectedHandler()));
    connect(m_socket, SIGNAL(disconnected()), SLOT(socketDisConnectedHandler()));
    connect(m_socket, SIGNAL(error(QLocalSocket::LocalSocketError)), SLOT(socketErrorHandler(QLocalSocket::LocalSocketError)));
    connect(m_socket, SIGNAL(stateChanged(QLocalSocket::LocalSocketState)), SLOT(stateChangedHandler(QLocalSocket::LocalSocketState)));

    connect(m_socket, SIGNAL(readyRead()), this,SLOT(readyReadHandler()));

    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &LocalClient::connectToServer);
}

LocalClient::~LocalClient()
{
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
{    qDebug("connectToServer start");
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

void LocalClient::get_all()
{
    QJsonObject root;
    root.insert(TYPE,TYPE_GETALL);
    root.insert(DATA,QJsonValue::Null);
    QByteArray data=QJsonDocument(root).toJson(QJsonDocument::Compact);
    //    qDebug() << "get_all: "<< QString(data);
    sendMessage(data);
}

unsigned char CheckSum(unsigned char *buf, int len) //和校验算法
{
    int i;
    unsigned char ret = 0;
    for (i = 0; i < len; i++)
    {
        ret += *(buf++);
    }
    return ret;
}

int LocalClient::sendMessage(QByteArray& data)
{
    if(QLocalSocket::ConnectedState!=m_socket->state())
    {
        qDebug() << "sendMessage error: UnconnectedState";
        return -1;
    }
    QByteArray buf;
    buf.append(FRAME_HEADER);
    buf.append(FRAME_HEADER);
    buf.append((char)0);
    buf.append(seqid/256);
    buf.append(seqid%256);
    buf.append(data.size()/256);
    buf.append(data.size()%256);
    buf.append(data);
    unsigned char verify= CheckSum((unsigned char *)(&buf.data()[2]),data.size()+5);
    buf.append((char)verify);
    buf.append(FRAME_TAIL);
    buf.append(FRAME_TAIL);
    qDebug() << "sendMessage :" << buf << "size:" <<buf.size() << "seqid:"<<seqid<<"verify:"<< verify << "verify char:"<<(unsigned char)((char)verify);
    int write_len= m_socket->write(buf.data(),buf.size());
    ++seqid;
    //    m_socket->flush();
    //    m_socket->waitForBytesWritten(2000);
    return write_len;
}

int LocalClient::uds_json_parse(const char *value,const int value_len)
{
    QJsonParseError error;
    QJsonDocument doucment = QJsonDocument::fromJson(QByteArray(value,value_len),&error);
    if(error.error!=QJsonParseError::NoError)
    {
        qDebug() << "QJsonDocument fromJson:"<< error.error<< ","<<error.errorString();
        return -1;
    }
    if (!doucment.isObject())
    {
        qDebug() << "JSON Parse Error:";
        return -1;
    }
    QJsonObject object = doucment.object();
    QJsonValue Type = object.value(TYPE);
    if (!Type.isString())
    {
        qDebug("Type is NULL\n");
        return -1;
    }

    QJsonValue Data =object.value( DATA);
    if (!Data .isObject())
    {
        qDebug("Data is NULL\n");
        return -1;
    }

    if (TYPE_EVENT== Type.toString())
    {
        //        qDebug() << "Data" << Data << endl;
        emit sendData(Data);
    }
    else
    {
        QJsonObject resp ;
        if (TYPE_GET== Type.toString())
        {

        }
        else if (TYPE_SET== Type.toString())
        {

        }
        else
        {

        }
    }

    return 0;
}

int LocalClient::uds_recv(const char *byte,const int len)
{
    if (byte == NULL)
        return -1;
    unsigned char*data=(unsigned char*)byte;
    int ret = 0;
    int msg_len, encry, seqid;
    unsigned char verify;
    for (int i = 0; i < len; ++i)
    {
        if (data[i] == FRAME_HEADER && data[i + 1] == FRAME_HEADER)
        {
            encry = data[i + 2];
            seqid = (data[i + 3] << 8) + data[i + 4];
            msg_len = (data[i + 5] << 8) + data[i + 6];
            if (data[i + 6 + msg_len + 2] != FRAME_TAIL || data[i + 6 + msg_len + 3] != FRAME_TAIL)
            {
                continue;
            }
            verify = data[6 + msg_len +1];
            printf("uds_recv encry:%d seqid:%d msg_len:%d", encry, seqid, msg_len);

            if (CheckSum((unsigned char *)&data[i + 2], msg_len + 5) != verify)
            {
                printf("CheckSum error..................");
                // continue;
            }
            if (msg_len > 0)
            {
                ret = uds_json_parse(&byte[i + 6 +1], msg_len);
                if (ret == 0)
                {
                    i += 6 + msg_len + 3;
                }
            }
        }
    }
    return 0;
}

int LocalClient::readMessage()
{
    //    if(m_socket->bytesAvailable()<=0)
    //    {
    //        if(m_socket->waitForReadyRead(-1)==false)
    //        {
    //            qDebug() << "waitForReadyRead error";
    //            return -1;
    //        }
    //    }
    QByteArray recv_data=m_socket->readAll();
    if(recv_data.size()==0)
    {
        qDebug() << "recv_data error";
        return -1;
    }
    //    qDebug() << "recv_data:" <<recv_data << endl;
    uds_recv(recv_data.data(),recv_data.size());

    return 0;
}

void LocalClient::close()
{
    m_socket->close();
}

void LocalClient::socketConnectedHandler()
{
    qDebug() << "socketConnectedHandler";
    timeoutCount=0;
    emit sendConnected(1);
    get_all();
}

void LocalClient::socketDisConnectedHandler()
{
    qDebug() << "socketDisConnectedHandler";
    close();
    emit sendConnected(0);
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
        close();
        if(!timer->isActive())
        {
            timer->start();
        }
    }
    else if(QLocalSocket::ConnectedState==socketState)
    {
        qDebug() << "ConnectedState.......";

        timer->stop();
    }
}

void LocalClient::readyReadHandler()
{
    qDebug() << "readyReadHandler";
    readMessage();
}

