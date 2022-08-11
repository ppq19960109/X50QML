#ifndef QMLDEVSTATE_H
#define QMLDEVSTATE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <QMap>
#include <QPair>
#include <QVector>
#include <QtQml>
//#include <QProcess>
#include "localclient.h"
#include "qrcodeen.h"
#include <cstdlib>
//#include <stdlib.h>

#define JSONTYPE "Type"
#define TYPE_SET "SET"
#define TYPE_GET "GET"
#define TYPE_GETALL "GETALL"
#define TYPE_EVENT "EVENT"
#define JSONDATA "Data"

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
        LINK_VALUE_TYPE_ARRAY,
    };
    //    QProcess process;
    void setLocalConnected(const int connected);
    int getLocalConnected() const;

    void setState(const QString& name,const QVariant& value);
    QVariantMap getState();
    //    static QmlDevState *qmlAttachedProperties(QObject *);
    QVariantList recipe[6];
    Q_INVOKABLE QVariantList getRecipe(const int index);

    QVariantList history;
    Q_INVOKABLE QVariantList getHistory();
    Q_INVOKABLE int deleteHistory(const int id);
    Q_INVOKABLE void sortHistory();
    Q_INVOKABLE int setCollect(const int index,const int collect);
    Q_INVOKABLE void startLocalConnect();
    void setHistory(QString& action,QVariantMap& history);
    int coverHistory(QJsonObject& single,QVariantMap& info);
    int getHistoryIndex(const int id);

    LocalClient client;
    Q_INVOKABLE int sendToServer(QString data);
    int sendJsonToServer(const QString type,QJsonObject& json);

    Q_INVOKABLE QVariantList getRecipeDetails(const int recipeid);
    Q_INVOKABLE void executeShell(const QString cmd);
    void selfStart();
private:

    int localConnected;
    QVariantMap stateMap;

    QVector<QPair<QString,int>> stateType;

    QMap<int,QVariantList> recipeMap;
    void readRecipeDetails();
    void parsingData(QJsonObject& object);
    int uds_json_parse(const char *value,const int value_len);
signals:
    void localConnectedChanged(const int value);
    void stateChanged(QString key,QVariant value);
    void historyChanged(QString action,QVariantMap history);
    void rebootChanged(const int value);
private slots:
    void readData(QByteArray object);
};
//QML_DECLARE_TYPEINFO(QmlDevState, QML_HAS_ATTACHED_PROPERTIES)

//stateTypeMap.insert("Reset",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("Alarm",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("SteamStart",LINK_VALUE_TYPE_NULL);

//stateTypeMap.insert("ProductionTest",LINK_VALUE_TYPE_NULL);
//stateTypeMap.insert("PwrSWVersion",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("ComSWVersion",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("SysPower",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("ErrorCode",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("ErrorCodeShow",LINK_VALUE_TYPE_NUM);

//stateTypeMap.insert("ProductCategory",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("ProductModel",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("ProductKey",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("DeviceName",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("ProductSecret",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("DeviceSecret",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("QrCode",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("UpdateLog",LINK_VALUE_TYPE_STRING);

//stateTypeMap.insert("WifiState",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("WifiEnable",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("WifiScanR",LINK_VALUE_TYPE_STRING);
//stateTypeMap.insert("WifiCurConnected",LINK_VALUE_TYPE_STRUCT);

//stateTypeMap.insert("CookRecipe",LINK_VALUE_TYPE_STRUCT);
//stateTypeMap.insert("CookHistory",LINK_VALUE_TYPE_STRUCT);
//stateTypeMap.insert("InsertHistory",LINK_VALUE_TYPE_STRUCT);
//stateTypeMap.insert("DeleteHistory",LINK_VALUE_TYPE_STRUCT);
//stateTypeMap.insert("UpdateHistory",LINK_VALUE_TYPE_STRUCT);

//stateTypeMap.insert("OTAState",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("OTAProgress",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("OTANewVersion",LINK_VALUE_TYPE_STRING);

//stateTypeMap.insert("AfterSalesQrCode",LINK_VALUE_TYPE_STRING);

//stateTypeMap.insert("LStOvMode",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvState",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvOperation",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvSetTimer",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvSetTimerLeft",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvSetTemp",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvRealTemp",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvOrderTimer",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("LStOvDoorState",LINK_VALUE_TYPE_NUM);

//stateTypeMap.insert("RStOvState",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvOperation",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvSetTimer",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvSetTimerLeft",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvSetTemp",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvRealTemp",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvOrderTimer",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvOrderTimerLeft",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStOvDoorState",LINK_VALUE_TYPE_NUM);

//stateTypeMap.insert("MultiMode",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("MultiStageState",LINK_VALUE_TYPE_STRUCT);
//stateTypeMap.insert("CookbookName",LINK_VALUE_TYPE_STRING);

//stateTypeMap.insert("LStoveStatus",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStoveStatus",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStoveTimingState",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStoveTimingOpera",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStoveTimingSet",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("RStoveTimingLeft",LINK_VALUE_TYPE_NUM);

//stateTypeMap.insert("HoodStoveLink",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("HoodLightLink",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("HoodOffTimer",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("HoodOffLeftTime",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("SteamOffTime",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("SteamOffLeftTime",LINK_VALUE_TYPE_NUM);
//stateTypeMap.insert("HoodSpeed",LINK_VALUE_TYPE_NUM);
#endif // QMLDEVSTATE_H
