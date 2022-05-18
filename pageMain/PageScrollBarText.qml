import QtQuick 2.7
import QtQuick.Controls 2.2

Flickable {
    id: flick
    property string text:details.text
    width: parent.width
    height: parent.height

    contentWidth: details.width
    contentHeight: details.height
    clip: true
    Text {
        id: details
        width: flick.width
        //                    height: flick.height
        font.pixelSize: 30
        lineHeight: 1.3
        color:"#fff"
        //                                        clip :true
        wrapMode: Text.WordWrap
        //                    elide: Text.ElideRight
    }

    ScrollBar.vertical: ScrollBar {
        parent: flick.parent
        anchors.top: flick.top
        anchors.left: flick.right
        anchors.leftMargin: 40
        anchors.bottom: flick.bottom
        background:Rectangle{
            implicitWidth: 4
            color:"#000"
            radius: width / 2
        }
        contentItem: Rectangle {
            implicitWidth: 4
            implicitHeight: 100
            radius: width / 2
            color: themesTextColor
        }
    }
}