#ifndef QMLWIFI_H
#define QMLWIFI_H

#include <QObject>
#include <QDebug>
#include "rkwifi.h"

class QmlWifi : public QObject
{
    Q_OBJECT

    Q_ENUMS(WIFI_Encype)
    Q_ENUMS(WiFiEvent)
public:
    explicit QmlWifi(QObject *parent = nullptr);
    ~QmlWifi();
    static QmlWifi* qmlWifi;

    enum WiFiEvent {
        WiFiEventNone = 0,
        WiFiEventConnecting = 1,
        WiFiEventConnectFail = 2,
        WiFiEventWrongPassword = 3,
        WiFiEventConnected = 4,
        WiFiEventDisconnected = 5,
    };

    enum WIFI_Encype{
        NONE = 0,
        WPA,
        WEP
    };
    /**
     * @brief 打开WiFi
     */
    Q_INVOKABLE int enableWiFi(int enable);

    Q_INVOKABLE int scanWiFi();

    Q_INVOKABLE int getWifiState();
    /**
     * @brief QHttpAPI::get 发送get请求
     * @param param 请求body参数
     */
    Q_INVOKABLE QVariantList getWiFiScanResult();

    /**
     * @brief 连接WiFi
     */
    Q_INVOKABLE int connectWiFi(QString ssid, QString password,const int encrypt);

    QVariantList parseScanResult(QByteArray data);
    int calSignalLevel(int rssi);
    static int wifiStatusCb(int event);
signals:
    void wifiEvent(int event);
};

#endif // QMLWIFI_H
