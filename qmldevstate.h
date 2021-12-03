#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QtQml>
#include "LocalClient.h"
#define MAX_HISTORY (40)
#define MAX_COLLECT (80)



class QmlDevState : public QObject
{
    Q_OBJECT
    //    QML_ANONYMOUS
    //    QML_ATTACHED(QmlDevState)

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QVariantMap state READ getState NOTIFY stateChanged)
public:
    //    using QObject::QObject;
    explicit QmlDevState(QObject *parent = nullptr);
    static QmlDevState* qmlDevState;
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

    Q_INVOKABLE  void setState( QString name, QVariant value);
    QVariantMap getState() const;
    //    static QmlDevState *qmlAttachedProperties(QObject *);
    QVariantList recipe[6];
    QVariantList history;
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QVariantList getHistory();
    Q_INVOKABLE int setSingleHistory(QVariantMap single);
    Q_INVOKABLE int addSingleHistory(QVariantMap single);
    Q_INVOKABLE int lastHistory(bool collect);
    Q_INVOKABLE int getHistoryCount();

    Q_INVOKABLE int removeHistory(int index);
    Q_INVOKABLE int setCollect(int index,bool collect);

    LocalClient client;
    Q_INVOKABLE int sendToServer(QString data);
    Q_INVOKABLE int sendJsonToServer(QString type,QJsonObject json);
private:

    QString myName;
    QVariantMap stateMap;
    QVariantMap stateTypeMap;
signals:
    void nameChanged(const QString name);
    void stateChanged(const QString& key,const QVariant value);

private slots:
    void readData(QJsonValue& data);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)
#endif // QMLDEVSTATE_H
