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
signals:
    void replyLocationData(QString value);
    void replyWeatherData(QString value);
private slots:
    void replyLocationFinished();
    void replyWeatherFinished();
};

#endif // MNETWORK_H
