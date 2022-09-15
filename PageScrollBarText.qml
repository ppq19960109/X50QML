import QtQuick 2.12
import QtQuick.Controls 2.5

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
        lineHeight: 1.3
        color:"#fff"
        wrapMode: Text.WrapAnywhere
    }

    ScrollBar.vertical: ScrollBar {
        parent: flick.parent
        anchors.top: flick.top
        anchors.topMargin: 10
        anchors.bottom: flick.bottom
        anchors.bottomMargin: 10
        anchors.left: flick.right
        anchors.leftMargin: scrollBarLeftMargin
        policy:ScrollBar.AsNeeded
        visible: flick.height < details.height

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
