#ifndef QMLWIFI_H
#define QMLWIFI_H

#include <QObject>
#include <QDebug>

class QmlWifi : public QObject
{
    Q_OBJECT

    Q_ENUMS(WIFI_Encype)
    Q_ENUMS(WiFiEvent)
public:
    explicit QmlWifi(QObject *parent = nullptr);
    ~QmlWifi();

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


    Q_INVOKABLE QVariantList getWiFiScanResult();

    /**
     * @brief 连接WiFi
     */
    Q_INVOKABLE int connectWiFi(QString ssid, QString password,const int encrypt);

    QVariantList parseScanResult(QByteArray data);
    int calSignalLevel(int rssi);

signals:
    void wifiStateEvent(int event);
    void wifiScanR(QString result);
};

#endif // QMLWIFI_H
