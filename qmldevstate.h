#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QtQml>
#include<QtAlgorithms>
#include<algorithm>
using namespace std;
#define MAX_HISTORY (40)
#define MAX_COLLECT (4)

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

    Q_INVOKABLE int sendUartData();
    QVariantList recipe[6];
    QVariantList history;
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QVariantList getHistory();
    Q_INVOKABLE int setSingleHistory(QVariantMap single);
    Q_INVOKABLE int addSingleHistory(QVariantMap single);
    Q_INVOKABLE int lastHistory(bool collect);
    Q_INVOKABLE int getHistoryCount();
    Q_INVOKABLE void clearHistory();
    Q_INVOKABLE int removeHistory(int index);
    Q_INVOKABLE int setCollect(int index,bool collect);
private:

    QString myName;
    QVariantMap stateMap;
signals:
    void nameChanged(const QString name);
    void stateChanged(const QString& name,const QVariant value);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)
#endif // QMLDEVSTATE_H
