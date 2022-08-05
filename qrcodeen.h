#ifndef QRCODEEN_H
#define QRCODEEN_H
#include <QObject>
#include <QDebug>
#include <QImage>
#include <QPainter>

#ifdef USE_RK3308
#include "qrencode.h"
#endif
class QrcodeEn
{
public:
    QrcodeEn();

    static QImage encodeImage(const QString qrTxt, int bulk,const QString saveName);
};

#endif // QRCODEEN_H
