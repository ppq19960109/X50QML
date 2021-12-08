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

#define TYPE "Type"
#define TYPE_SET "SET"
#define TYPE_GET "GET"
#define TYPE_GETALL "GETALL"
#define TYPE_EVENT "EVENT"

#define DATA "Data"

class LocalClient : public QObject
{
    Q_OBJECT
public:
    explicit LocalClient(QObject *parent = nullptr);
    ~LocalClient();
    int timeoutCount;
    static int seqid;
    void connectToServer();
    int sendMessage(QByteArray& data);
    int readMessage();
    int uds_recv(const char *byte,const int len);
    int uds_json_parse(const char *value,const int value_len);
    void get_all();
    QLocalSocket *m_socket;
    QTimer *timer;
    void close();

signals:
    void sendData(const QJsonValue& data);
    void sendConnected(const int connected);
private slots:
    void socketConnectedHandler();
    void socketDisConnectedHandler();
    void socketErrorHandler(QLocalSocket::LocalSocketError error);
    void stateChangedHandler(QLocalSocket::LocalSocketState socketState);
    void readyReadHandler();
};

#endif // LOCALCLIENT_H
