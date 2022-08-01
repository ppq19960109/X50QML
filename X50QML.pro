QT += quick quickcontrols2 network

CONFIG += c++11 qtquickcompiler

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        backlight.cpp \
        localclient.cpp \
        main.cpp \
        qmldevstate.cpp \
        qrcodeen.cpp

RESOURCES += qml.qrc \
    light/light_style.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

contains(QT_ARCH, arm){
    message("arm")
    DEFINES += USE_RK3308
    #DEFINES += SYSPOWER_RK3308
    #LIBS += -lqrencode
    #LIBS += -lDeviceIo -lasound
    INCLUDEPATH += libqrencode/include
    LIBS += libqrencode/lib/libqrencode.a
}else{
    message("x86_64")
}

#win32{
#message("win32")
#}
#unix{
#message("unix")
#}

HEADERS += \
    backlight.h \
    localclient.h \
    qmldevstate.h \
    qrcodeen.h

