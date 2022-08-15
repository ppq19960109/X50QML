import QtQuick 2.12
import QtQuick.Controls 2.5
Item {
    width: parent.width
    height: control.height
    property alias stepSize: control.stepSize
    property alias from: control.from
    property alias to: control.to
    property alias value: control.value
    property string displayText
    signal valueSlider(var value)

    Slider {
        id: control
        anchors.fill: parent
        background: Rectangle {
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
//            implicitWidth: control.availableWidth
//            implicitHeight: 4
            width: control.availableWidth
            height: 4
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
                smooth:false
                asynchronous:true
                anchors.centerIn: parent
                source: "qrc:/x50/set/huadonganniu.png"
            }
            Text{
                id:cur
                color:"#fff"
                visible: text!=null
                text:displayText
                font.pixelSize:35
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -25
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        onValueChanged: {
//            console.log("Slider:",value)
            valueSlider(value)
        }
    }
}
