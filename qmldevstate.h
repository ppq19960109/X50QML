#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QtQml>
#include "LocalClient.h"
#include "qrcodeen.h"
#define MAX_HISTORY (40)
#define MAX_COLLECT (80)



class QmlDevState : public QObject
{
    Q_OBJECT
    //    QML_ANONYMOUS
    //    QML_ATTACHED(QmlDevState)

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
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

    struct recipes_t
    {
        int id;
        int seqid;
        char dishName[64];
        char imgUrl[64];
        char details[512];
        char cookSteps[64];
        int timestamp;
        int collect;
        int cookTime;
        int cookType;
    };

    void setName(const QString &name);
    QString getName() const;

    Q_INVOKABLE  void setState(const QString &name,const QVariant& value);
    QVariantMap getState() const;
    //    static QmlDevState *qmlAttachedProperties(QObject *);
    QVariantList recipe[6];
    QVariantList history;
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QVariantList getHistory();
    Q_INVOKABLE int insertHistory(QVariantMap single);
    Q_INVOKABLE int deleteHistory(const int id);
    Q_INVOKABLE int setCollect(const int index,const bool collect);
    void setHistory(const QVariantMap &history);
    int coverHistory(const QJsonObject& single,QVariantMap& info);
    int lastHistoryId(const int collect);
    int compareHistoryCollect(const QVariantMap& single);
    int getHistoryCount();
    int getHistoryIndex(const int id);


    LocalClient client;
    Q_INVOKABLE int sendToServer(const QString &data);
    Q_INVOKABLE int sendJsonToServer(const QString &type,const QJsonObject &json);
private:

    QString myName;
    QVariantMap stateMap;
    QVariantMap stateTypeMap;
signals:
    void nameChanged(const QString& name);
    void stateChanged(const QString& key,const QVariant& value);
    void historyChanged(const QVariantMap& historyList);

private slots:
    void readData(const QJsonValue& data);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)
#endif // QMLDEVSTATE_H
