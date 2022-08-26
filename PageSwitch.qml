import QtQuick 2.12
import QtQuick.Controls 2.5

Switch {
    property alias source:indicatorImg.source
    indicator: Item {
        implicitWidth: indicatorImg.width
        implicitHeight: indicatorImg.height
        anchors.centerIn: parent
        Image{
            id:indicatorImg
            source: themesPicturesPath+(checked ?"icon_wifi_open.png":"icon_wifi_close.png")
        }
    }
}
