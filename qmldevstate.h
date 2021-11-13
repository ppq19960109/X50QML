#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QtQml>

struct QDevAttr
{
    QString name;
    unsigned char uartByteLen;
    //    unsigned int value;
};

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


    void setName(const QString &name);
    QString getName() const;

    Q_INVOKABLE  void setState(const QString& name,const QVariant value);
    QVariantMap getState() const;
    //    static QmlDevState *qmlAttachedProperties(QObject *);
    Q_INVOKABLE static int uartStatusCb(const char* value,const int value_len);
    QByteArray uartData;
    Q_INVOKABLE int setUartData(const QString& name,QVariantList value);
    Q_INVOKABLE int sendUartData();
    QVariantList recipe[6];
    QVariantList history;
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QVariantList getHistory();
private:

    QString myName;
    QVariantMap stateMap;
    static QMap<int,QDevAttr> attrMap;
signals:
    void nameChanged(const QString name);
    void stateChanged(const QString& name,const QVariant value);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)
#endif // QMLDEVSTATE_H
