#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTextCodec>
#include <QFontDatabase>
#include <QDebug>
#include <QStandardPaths>

#include "QmlWifi.h"
#include "qmldevstate.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<QmlWifi>("QmlWifi", 1, 0, "QmlWifi");

    // app qml settings
    app.setOrganizationName("MarsOven"); //1
    app.setOrganizationDomain("MarsOven.com"); //2
    app.setApplicationName("x5"); //3

    //    int fontId = QFontDatabase::addApplicationFont("/oem/res/fonts/SourceHanSansCN-Regular.ttf");
    int fontId = QFontDatabase::addApplicationFont("simfang.ttf");
    QStringList fontFamilies = QFontDatabase::applicationFontFamilies(fontId);
    qDebug()<<"fontfamilies: "<<fontFamilies;

    qDebug()<<"FontsLocation"<<QStandardPaths::standardLocations(QStandardPaths::FontsLocation);
    QFont font;
    font.setFamily("FangSong");//设置全局字体
    app.setFont(font);
    //中文支持

    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));

//    QFontDatabase fdb;
//    QStringList fontList = fdb.families();
//    for(int i = 0; i < fontList.size(); i++){
//        qDebug() << "font name" << i << ": " << fontList.at(i);
//    }


    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("QmlDevState", new QmlDevState(&app));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
