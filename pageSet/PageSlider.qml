import QtQuick 2.0
import QtQuick.Controls 2.2
Item {

    height: control.height
    property alias stepSize: control.stepSize
    property alias from: control.from
    property alias to: control.to
    property alias value: control.value
    property string displayText
    signal valueSlider(var value)
    Component.onCompleted: {
        console.log("PageSlider",width,height)

    }
    Slider {
        id: control
        anchors.fill: parent
        background: Rectangle {
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            implicitWidth: control.availableWidth
            implicitHeight: 4
            width: control.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: control.visualPosition * parent.width
                height: parent.height
                color: "blue"
                radius: 2
            }
        }

        handle: Rectangle {
            x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
            y: control.topPadding + control.availableHeight / 2 - height / 2
            color:"transparent"
            implicitWidth: 30
            implicitHeight: 90
            //                    border.color: "#fff"
            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 30
                implicitHeight: 30
                radius: 13
                color: control.pressed ? "red" : "blue"
                border.color: "#bdbebf"
            }
            Text{
                id:cur
                color:"#fff"
                visible: text!=null
                text:displayText
                font.pixelSize:30
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        onValueChanged: {
            console.log("Slider:",value)
            valueSlider(value)
        }
    }
}
