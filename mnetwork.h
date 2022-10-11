#ifndef MNETWORK_H
#define MNETWORK_H

#include <QObject>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QDebug>
class MNetwork : public QObject
{
    Q_OBJECT
public:
    MNetwork(QObject *parent = nullptr);
    ~MNetwork();

    QNetworkAccessManager *networkAccessManager;
    Q_INVOKABLE void weatherRequest(QString city);
    Q_INVOKABLE void locationRequest();
    Q_INVOKABLE void postRequest(QString url,QString body,QString pk,QString mac,QString sign);
signals:
    void replyLocationData(QString value);
    void replyWeatherData(QString value);
    void replyPostData(QString value);
private slots:
    void replyLocationFinished();
    void replyWeatherFinished();
    void replyPostFinished();
};

#endif // MNETWORK_H
