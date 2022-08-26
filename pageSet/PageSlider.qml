import QtQuick 2.12
import QtQuick.Controls 2.5

Slider {
    property string displayText
    id: control

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.availableWidth
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: themesTextColor2
        //            opacity: 0.35

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: themesTextColor
            radius: 2
        }
    }

    handle: Item {
        id:handle
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitWidth: 30
        implicitHeight: 90
        //                    border.color: "#fff"
        //            Rectangle {
        //                anchors.centerIn: parent
        //                implicitWidth: 30
        //                implicitHeight: 30
        //                radius: 13
        //                color: control.pressed ? "red" : "blue"
        //                border.color: "#bdbebf"
        //            }
        Image {
            asynchronous:true
            anchors.centerIn: parent
            source: themesPicturesPath+"icon_slide.png"
        }
        Text{
            id:cur
            color:"#fff"
            visible: text!=null
            text:displayText
            font.pixelSize:24
            anchors.top: parent.top
            anchors.topMargin: -5
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
