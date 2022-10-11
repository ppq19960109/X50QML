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

    /* 读取数据 */
    QByteArray data =  reply->readAll();
    qDebug()<< "replyLocationFinished:" << QString(data);
    emit replyLocationData(data);
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

void MNetwork::postRequest(QString url,QString body,QString pk,QString mac,QString sign)
{
    QNetworkRequest request;

    QSslConfiguration conf = request.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::AnyProtocol);
    request.setSslConfiguration(conf);
    qDebug()<< "url:" << url << "body:"<< body << "pk:"<< pk << "mac:"<< mac<< "sign:"<< sign;
    request.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/json"));
    request.setRawHeader("pk",pk.toUtf8());
    request.setRawHeader("mac",mac.toUtf8());
    request.setRawHeader("sign",sign.toUtf8());
    request.setUrl(QUrl(url));
    QNetworkReply* reply = networkAccessManager->post(request,body.toUtf8());
    connect(reply, SIGNAL(finished()),this, SLOT(replyPostFinished()));
}

void MNetwork::replyPostFinished()
{
    /* 获取信号发送者 */
    QNetworkReply *reply = (QNetworkReply *)sender();

    /* 读取数据 */
    QByteArray data =  reply->readAll();
    qDebug()<< "replyPostFinished:" << QString(data);
    emit replyPostData(data);
    /* 防止内存泄漏 */
    reply->deleteLater();
}
