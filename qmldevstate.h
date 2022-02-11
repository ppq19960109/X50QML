#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QtQml>
#include "localclient.h"
#include "qrcodeen.h"
#define MAX_HISTORY (40)
#define MAX_COLLECT (40)



class QmlDevState : public QObject
{
    Q_OBJECT
    //    QML_ANONYMOUS
    //    QML_ATTACHED(QmlDevState)

    Q_PROPERTY(int localConnected READ getLocalConnected WRITE setLocalConnected NOTIFY localConnectedChanged)
    Q_PROPERTY(QVariantMap state READ getState NOTIFY stateChanged)
    Q_PROPERTY(QVariantList historyList READ getHistory NOTIFY historyChanged)
public:
    //    using QObject::QObject;
    explicit QmlDevState(QObject *parent = nullptr);
    //    static QmlDevState* qmlDevState;

    enum LINK_VALUE_TYPE
    {
        LINK_VALUE_TYPE_NUM = 0x00,
        LINK_VALUE_TYPE_STRING,
        LINK_VALUE_TYPE_STRUCT,
        LINK_VALUE_TYPE_NULL,
    };


    void setLocalConnected(const int connected);
    int getLocalConnected() const;

    Q_INVOKABLE  void setState(const QString &name,const QVariant& value);
    QVariantMap getState() const;
    //    static QmlDevState *qmlAttachedProperties(QObject *);
    QVariantList recipe[6];
    QVariantList history;
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QVariantList getHistory();
    Q_INVOKABLE int insertHistory(QVariantMap single);
    Q_INVOKABLE int deleteHistory(const int id);
    Q_INVOKABLE void sortHistory();
    Q_INVOKABLE int setCollect(const int index,const int collect);
    Q_INVOKABLE void systemReset();
    void setHistory(const QString& action,const QVariantMap &history);
    int coverHistory(const QJsonObject& single,QVariantMap& info);
    int lastHistoryId(const int collect);
    int compareHistoryCollect(const QVariantMap& single);
    int getHistoryCount();
    int getHistoryIndex(const int id);


    LocalClient client;
    Q_INVOKABLE int sendToServer(const QString &data);
    Q_INVOKABLE int sendJsonToServer(const QString &type,const QJsonObject &json);
private:

    int localConnected;
    QVariantMap stateMap;
    QVariantMap stateTypeMap;
signals:
    void localConnectedChanged(const int value);
    void stateChanged(const QString& key,const QVariant& value);
    void historyChanged(const QString& action,const QVariantMap& history);

private slots:
    void readData(const QJsonValue& data);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)
#endif // QMLDEVSTATE_H
