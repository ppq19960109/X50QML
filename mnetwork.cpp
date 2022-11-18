#include "mnetwork.h"

MNetwork::MNetwork(QObject *parent): QObject(parent)
{
    networkAccessManager=new QNetworkAccessManager(this);
    //    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(requestFinished(QNetworkReply*)));
    //    weatherRequest("hangzhou");
}

MNetwork::~MNetwork()
{
    delete networkAccessManager;
}

void MNetwork::locationRequest() {
    QNetworkRequest request;

    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::AnyProtocol);
    request.setSslConfiguration(conf);

    request.setUrl(QUrl("http://mcook.marssenger.com/application/weather/day"));
    QNetworkReply* reply = networkAccessManager->get(request);
    connect(reply, SIGNAL(finished()),this, SLOT(replyLocationFinished()));
}

void MNetwork::replyLocationFinished()
{
    /* 获取信号发送者 */
    QNetworkReply *reply = (QNetworkReply *)sender();
    qDebug()<< "replyLocationFinished error:" << reply->error() << "url:" << reply->url();
    /* 读取数据 */
    if(reply->error()==QNetworkReply::NoError)
    {
        QByteArray data =  reply->readAll();
        qDebug()<< "replyLocationFinished:" << QString(data);
        emit replyLocationData(data);
    }
    /* 防止内存泄漏 */
    reply->deleteLater();
}

void MNetwork::timeRequest() {
    QNetworkRequest request;

    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::AnyProtocol);
    request.setSslConfiguration(conf);

    request.setUrl(QUrl("http://mcook.marssenger.com/application/time/day"));
    QNetworkReply* reply = networkAccessManager->get(request);
    connect(reply, SIGNAL(finished()),this, SLOT(replyTimeFinished()));
}

void MNetwork::replyTimeFinished()
{
    /* 获取信号发送者 */
    QNetworkReply *reply = (QNetworkReply *)sender();
    qDebug()<< "error:" << reply->error() << "url:" << reply->url();
    /* 读取数据 */
    if(reply->error()==QNetworkReply::NoError)
    {
        QByteArray data =  reply->readAll();
        qDebug()<< "replyTimeFinished replyTimeFinished:" << QString(data);
        emit replyTimeData(data);
    }
    /* 防止内存泄漏 */
    reply->deleteLater();
}

void MNetwork::weatherRequest(QString city) {
    QNetworkRequest request;

    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::AnyProtocol);
    request.setSslConfiguration(conf);

    request.setUrl(QUrl("https://wttr.in/"+city+"?format=j2"));
    QNetworkReply* reply = networkAccessManager->get(request);
    connect(reply, SIGNAL(finished()),this, SLOT(replyWeatherFinished()));
}

void MNetwork::replyWeatherFinished()
{
    /* 获取信号发送者 */
    QNetworkReply *reply = (QNetworkReply *)sender();

    /* 读取数据 */
    QByteArray data =  reply->readAll();
    //    qDebug()<< "replyFinished:" << QString(data);
    emit replyWeatherData(data);
    /* 防止内存泄漏 */
    reply->deleteLater();
}

QString MNetwork::getIpFromName(QString name)
{
    QString ipaddr;
    //通过QNetworkInterface类来获取本机的IP地址和网络接口信息
    QList<QNetworkInterface> list = QNetworkInterface::allInterfaces();
    //获取所有网络接口的列表
    foreach(QNetworkInterface interface,list)
    {
        QString interfaceName=interface.name();
        //遍历每一个网络接口
        qDebug() << "Device: "<<interfaceName;
        if(name!=interfaceName)
            continue;
        //设备名
        qDebug() << "HardwareAddress:"<<interface.hardwareAddress();
        //硬件地址
        QList<QNetworkAddressEntry> entryList = interface.addressEntries();
        //获取IP地址条目列表，每个条目中包含一个IP地址，一个子网掩码和一个广播地址
        foreach(QNetworkAddressEntry entry,entryList)
        {
            QHostAddress ip=entry.ip();
            if(ip.protocol()!=QAbstractSocket::IPv4Protocol)
                continue;
            ipaddr=ip.toString();
            //遍历每一个IP地址条目
            qDebug()<<"IP Address: "<<ipaddr;

            //子网掩码
            qDebug()<<"Netmask: "<<entry.netmask().toString();

            //广播地址
            qDebug()<<"Broadcast: "<<entry.broadcast().toString() << endl;
            break;
        }
        break;
    }
    return ipaddr;
}
