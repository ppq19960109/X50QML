import QtQuick 2.7
import QtQuick.Controls 2.2

Switch {
    property alias source:indicatorImg.source
    indicator: Item {
        implicitWidth: indicatorImg.width
        implicitHeight: indicatorImg.height
        anchors.centerIn: parent
        Image{
            id:indicatorImg
            asynchronous:true
            smooth:false
            source: themesPicturesPath+(checked ?"icon_wifi_open.png":"icon_wifi_close.png")
        }
    }
}
