#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTextCodec>
#include <QFontDatabase>
#include <QDebug>
#include <QStandardPaths>

#include "qmldevstate.h"
#include "localclient.h"
#include "backlight.h"
#include <QtQuickControls2>
//#include <QMetaObject>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    qputenv("QT_VIRTUALKEYBOARD_STYLE", "light");

    QLocale::setDefault(QLocale::English);//QLocale::English
    QLocale locale;
    qDebug()<< "locale:"<<locale.language();
    //    qDebug() << "availableStyles: " << QQuickStyle::availableStyles();
    //        QQuickStyle::setStyle("Imagine");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    Backlight* backlight =new Backlight(&app);
    backlight->backlightEnable();

    QmlDevState* qmlDevState =new QmlDevState(&app);

    //    qmlRegisterType<QmlWifi>("QmlWifi", 1, 0, "QmlWifi");

    // app qml settings
    app.setOrganizationName("Marssenger"); //1
    app.setOrganizationDomain("Marssenger.com"); //2
    app.setApplicationName("X50BCZ"); //3

    int fontId = QFontDatabase::addApplicationFont("SourceHanSansCN-Regular.ttf");
    //    int fontId = QFontDatabase::addApplicationFont("simfang.ttf");
    QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
    qDebug()<<"fontfamilies: "<<fontFamilies;

    qDebug()<<"FontsLocation"<<QStandardPaths::standardLocations(QStandardPaths::FontsLocation);

    QFont font;
    font.setFamily("SimHei");//设置全局字体 "Source Han Sans CN" SimHei
    app.setFont(font);
    //中文支持

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

        QFontDatabase fdb;
        QStringList fontList = fdb.families();
        for(int i = 0; i < fontList.size(); i++){
            qDebug() << "font name" << i << ": " << fontList.at(i);
        }


    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("QmlDevState", qmlDevState);
    engine.rootContext()->setContextProperty("Backlight", backlight);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    //    QQmlComponent component(&engine, url);
    //    QObject *object = component.create();
    //    QMetaObject::invokeMethod(object, "myQmlFunction");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
