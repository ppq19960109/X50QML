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

#define JSONTYPE "Type"
#define TYPE_SET "SET"
#define TYPE_GET "GET"
#define TYPE_GETALL "GETALL"
#define TYPE_EVENT "EVENT"
#define DATA "Data"

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

    Q_INVOKABLE  void setState(const QString& name,const QVariant& value);
    QVariantMap getState() const;

    QVariantList recipe[6];
    Q_INVOKABLE QVariantList getRecipe(const int index);
    Q_INVOKABLE QString getRecipeName(const int recipeId);

    QVariantList tempRecipes[4];
    Q_INVOKABLE QVariantList getTempRecipes(const int index);
    Q_INVOKABLE void startLocalConnect();

    LocalClient client;
    Q_INVOKABLE int sendToServer(QString data);

    Q_INVOKABLE int executeShell(const QString cmd);
    Q_INVOKABLE int executeQProcess(const QString cmd,const QStringList list);
    void selfStart();
    QString marsUrl;
private:

    int localConnected;
    QVariantMap stateMap;

    QVector<QPair<QString,int>> stateType;

    void readRecipeDetails();
    void parsingData(const QJsonObject& object);
    int uds_json_parse(const char *value,const int value_len);
signals:
    void localConnectedChanged(const int value);
    void stateChanged(const QString key,const QVariant value);
    void rebootChanged(const int value);
private slots:
    void readData(const QByteArray object);
};

#endif // QMLDEVSTATE_H
