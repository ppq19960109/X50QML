#ifndef BACKLIGHT_H
#define BACKLIGHT_H
#include <QDebug>
#include <QObject>
#include <QDir>
//#include <QtQml>
#include <QList>
class Backlight : public QObject
{
    Q_OBJECT
public:
    Backlight(QObject *parent = nullptr);

    Q_INVOKABLE static int backlightEnable();
    Q_INVOKABLE static int backlightDisable();
    Q_INVOKABLE static int backlightSet(unsigned char value);
    Q_INVOKABLE static int backlightGet();
//    Q_INVOKABLE QVariantList getAllFileName(QString path);
};

#endif // BACKLIGHT_H
