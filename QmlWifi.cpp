#include "QmlWifi.h"

#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

QmlWifi* QmlWifi::qmlWifi=nullptr;

QmlWifi::QmlWifi(QObject *parent) : QObject(parent)
{
    qmlWifi=this;
#ifdef USE_RK3308
    wifiRegsiterCallback(wifiStatusCb);
#endif
}

QmlWifi::~QmlWifi()
{

}

int QmlWifi::wifiStatusCb(int event)
{
    emit qmlWifi->wifiEvent(event);
    return 0;
}

int QmlWifi::enableWiFi(int enable)
{
    int res=-1;
#ifdef USE_RK3308
    res= wifiEnable(enable);
#endif
    return res;
}

int QmlWifi::scanWiFi()
{
    int res=-1;
#ifdef USE_RK3308
    res= wifiScan();
#endif
    return res;
}

int QmlWifi::getWifiState()
{
    int res=0;
#ifdef USE_RK3308
    res= getWifiRunningState();
#endif
    return res;
}

QVariantList QmlWifi::getWiFiScanResult()
{
    QVariantList list;
#ifdef USE_RK3308
    char* res=getWifiScanR();
    if(res!=nullptr)
    {
        //    QString str = QString(res);
        //        qDebug() << "getWiFiScanResult:" << res <<endl;
        list=parseScanResult(QByteArray(res));
    }
#else
    QVariantMap info;

    info.insert("ssid", "hello");
    info.insert("level", 2);
    info.insert("connected", false);
    info.insert("flags", 2);
    list.append(info);
#endif
    return  list;
}

int QmlWifi::connectWiFi(QString ssid, QString password, const int encrypt)
{
    int res=-1;
    qDebug() << "ssid:" << ssid << "password:" << password<< "encrypt:" << encrypt;
#ifdef USE_RK3308
    res=  wifiConnect(ssid.toLocal8Bit().data(),password.toLocal8Bit().data(),(RK_WIFI_CONNECTION_Encryp_e)encrypt);
#endif
    return res;
}

/**
 * @brief calculateSignalLevel　WiFi信号强度转换算法
 * @param rssi　信号强度值dbm（-100~0）
 * @param numLevels 信号强度分级
 * @return　当前信号强度等级
 */
int QmlWifi::calSignalLevel(int rssi)
{
    if (rssi <= -100)
    {
        return 0;
    }
    else if (rssi < -75)
    {
        return 1;
    }
    else if (rssi < -55)
    {
        return 2;
    }
    else
    {
        return 3;
    }
}
/**
 * @brief 解析WiFi扫描数据
 */
QVariantList QmlWifi::parseScanResult(QByteArray data)
{
    QVariantList list;
#ifdef USE_RK3308
    QString qstrJson = data;
    QJsonParseError jsonError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(data, &jsonError);
    //    jsonDoc.toJson();
    if (!jsonDoc.isNull() && jsonError.error == QJsonParseError::NoError)
    {
        RK_WIFI_INFO_Connection_s wifiInfo;
        int wifiState = getWifiConnectionInfo(&wifiInfo);
        QString connected_bssid;
        if(wifiState>=0)
            connected_bssid = QString::fromUtf8(wifiInfo.bssid);

        QJsonArray jsonArray = jsonDoc.array();
        for(int i=0; i < jsonArray.size(); ++i)
        {
            QVariantMap info;
            QJsonValue jsonValue = jsonArray.at(i);
            if(jsonValue.isObject())
            {
                QJsonObject jsonObj = jsonValue.toObject();
                if(!jsonObj.value("ssid").toString().isEmpty())
                {
                    info.insert("ssid", jsonObj.value("ssid").toString());
                    QString bssid = jsonObj.value("bssid").toString();
                    int rssi = jsonObj.value("rssi").toInt();
                    info.insert("level", calSignalLevel(rssi));
                    /*判断加密模式*/
                    QString encryMode = jsonObj.value("flags").toString();
                    if(encryMode.contains("WPA",Qt::CaseSensitive))
                    {
                        info.insert("flags", WPA);
                    }
                    else if(encryMode.contains("WEP",Qt::CaseSensitive))
                    {
                        info.insert("flags", WEP);
                    }
                    else
                    {
                        info.insert("flags", NONE);
                    }
                    /*判断当前WiFi的bssid和连接状态*/
                    if(wifiState>=0 && bssid == connected_bssid)
                    {
                        info.insert("connected", true);
                        list.insert(0,info);
                    }
                    else
                    {
                        info.insert("connected", false);
                        list.append(info);
                    }
                    //  qDebug() << "WiFi ssid:" << wifiInfoData.ssid << "bssid" << wifiInfoData.bssid << "signalLevel:" << wifiInfoData.level << "Is WPA:" << wifiInfoData.flags << "Connected:" << wifiInfoData.connected;

                }
            }
        }
    }
    else
    {
        qDebug() << "Get WiFi List Json Format Error!";
    }
#endif
    return list;
}
