import QtQuick 2.7
import QtQuick.Controls 2.2

Flickable {
    id: flick
    property alias text:details.text
    property int scrollBarLeftMargin:20
//    anchors.fill: parent

    contentWidth: details.width
    contentHeight: details.height
    clip: true
    Text {
        id: details
        width: flick.width
        //                    height: flick.height
        font.pixelSize: 32
        lineHeight: 1.2
        color:"#fff"
        //                                        clip :true
        wrapMode: Text.WordWrap
        //                    elide: Text.ElideRight
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
