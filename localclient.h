#ifndef LOCALCLIENT_H
#define LOCALCLIENT_H

#include <QObject>
#include <QLocalSocket>
#include <QDebug>
#include <QThread>
#include <QTimer>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#define UNIX_DOMAIN "/tmp/unix_server.domain"
#define FRAME_HEADER (0xAA)
#define FRAME_TAIL (0xBB)

class LocalClient : public QObject
{
    Q_OBJECT
public:
    explicit LocalClient(QObject *parent = nullptr);
    ~LocalClient();
    int timeoutCount;
    static int seqid;
    void startConnectTimer();
    void connectToServer();
    int sendMessage(const QString& data);

    QLocalSocket *m_socket;
    QTimer *timer;
    void close();

signals:
    void sendData(QByteArray data);
    void sendConnected(const int connected);
private slots:
    void socketConnectedHandler();
    void socketDisConnectedHandler();
    void socketErrorHandler(QLocalSocket::LocalSocketError error);
    void stateChangedHandler(QLocalSocket::LocalSocketState socketState);
    void readyReadHandler();
};

#endif // LOCALCLIENT_H
