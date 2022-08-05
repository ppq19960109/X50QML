#include "qrcodeen.h"

QrcodeEn::QrcodeEn()
{
    qDebug() << "QrcodeEn";
}


QImage QrcodeEn::encodeImage(const QString qrTxt, int bulk,const QString saveName)
{
    qDebug() << "QrcodeEn encodeImage";
    QImage ret;
#ifdef USE_RK3308
    QRcode* qr = QRcode_encodeString(qrTxt.toUtf8(), 0, QR_ECLEVEL_M, QR_MODE_8, 1);
    if ( qr != nullptr )
    {
        int allBulk = (qr->width) * bulk;
        ret = QImage(allBulk+20, allBulk+20, QImage::Format_MonoLSB);
        QPainter painter(&ret);
        QColor fg("black");
        QColor bg("white");
        painter.setBrush(bg);
        painter.setPen(Qt::NoPen);
        painter.drawRect(0, 0, allBulk+20, allBulk+20);

        painter.setBrush(fg);
        int x,y;
        for( y=0; y<qr->width; ++y )
        {
            for( x=0; x<qr->width; ++x )
            {
                if ( qr->data[y*qr->width+x] & 1 )
                {
                    QRectF r(x*bulk+10, y*bulk+10, bulk, bulk);
                    painter.drawRects(&r, 1);
                }
            }
        }
        QRcode_free(qr);
        if(saveName!="")
            ret.save(saveName);
    }
#endif
    return ret;
}
