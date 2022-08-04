#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QPair>
#include <QVector>
#include <QtQml>
#include <QProcess>
#include "localclient.h"
#include "qrcodeen.h"
#include <cstdlib>

class QmlDevState : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int localConnected READ getLocalConnected WRITE setLocalConnected NOTIFY localConnectedChanged)
    Q_PROPERTY(QVariantMap state READ getState NOTIFY stateChanged)
public:
    explicit QmlDevState(QObject *parent = nullptr);

    enum LINK_VALUE_TYPE
    {
        LINK_VALUE_TYPE_NUM = 0x00,
        LINK_VALUE_TYPE_STRING,
        LINK_VALUE_TYPE_STRUCT,
        LINK_VALUE_TYPE_NULL,
        LINK_VALUE_TYPE_ARRAY,
    };
//    QProcess process;
    void setLocalConnected(const int connected);
    int getLocalConnected() const;

    Q_INVOKABLE  void setState(const QString &name,const QVariant& value);
    QVariantMap getState() const;

    QVariantList recipe[6];
    Q_INVOKABLE QVariantList getRecipe(const int index);

    Q_INVOKABLE void startLocalConnect();

    int coverHistory(const QJsonObject& single,QVariantMap& info);

    LocalClient client;
    Q_INVOKABLE int sendToServer(const QString &data);

    Q_INVOKABLE QVariantList getRecipeDetails(const int recipeid);
    Q_INVOKABLE void executeShell(const QString &cmd);
private:

    int localConnected;
    QVariantMap stateMap;

    QVector<QPair<QString,int>> stateType;

    QMap<int,QVariantList> recipeMap;
    void readRecipeDetails();
signals:
    void localConnectedChanged(const int value);
    void stateChanged(const QString& key,const QVariant& value);

private slots:
    void readData(const QJsonValue data);
};

#endif // QMLDEVSTATE_H
