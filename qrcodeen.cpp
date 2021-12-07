#include "qrcodeen.h"

QrcodeEn::QrcodeEn()
{
    qDebug() << "QrcodeEn";
}


QImage QrcodeEn::encodeImage(const QString& qrTxt, int bulk,const QString& saveName)
{
    qDebug() << "QrcodeEn encodeImage";
    QImage ret;
#ifdef USE_RK3308
    QRcode* qr = QRcode_encodeString(qrTxt.toUtf8(), 12, QR_ECLEVEL_Q, QR_MODE_8, 1);
    if ( qr != nullptr )
    {
        int allBulk = (qr->width) * bulk;
        ret = QImage(allBulk, allBulk, QImage::Format_MonoLSB);
        QPainter painter(&ret);
        QColor fg("black");
        QColor bg("white");
        painter.setBrush(bg);
        painter.setPen(Qt::NoPen);
        painter.drawRect(0, 0, allBulk, allBulk);

        painter.setBrush(fg);
        for( int y=0; y<qr->width; y++ )
        {
            for( int x=0; x<qr->width; x++ )
            {
                if ( qr->data[y*qr->width+x] & 1 )
                {
                    QRectF r(x*bulk, y*bulk, bulk, bulk);
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
