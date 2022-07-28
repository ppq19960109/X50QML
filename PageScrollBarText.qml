import QtQuick 2.7
import QtQuick.Controls 2.2

Flickable {
    id: flick
    property alias text:details.text
    property int scrollBarLeftMargin:20

    contentWidth: details.width
    contentHeight: details.height
    clip: true
    boundsBehavior:Flickable.StopAtBounds
    Text {
        id: details
        width: flick.width
        //                    height: flick.height
        font.pixelSize: 30
//        lineHeight: 1.1
        color:"#fff"
        wrapMode: Text.WrapAnywhere
    }

    ScrollBar.vertical: ScrollBar {
        parent: flick.parent
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        anchors.left: flick.right
        anchors.leftMargin: scrollBarLeftMargin

        background:Rectangle{
            implicitWidth: 4
            color:"#000"
            radius: implicitWidth / 2
        }
        contentItem: Rectangle {
            implicitWidth: 4
            radius: implicitWidth / 2
            color: themesTextColor
        }
    }
}
