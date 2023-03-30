import QtQuick 2.12
import QtQuick.Controls 2.5

Slider {
    id: control
    property alias title: titleText.text
    property alias unit: unitText.text
    stepSize: 1
    to: 100
    value: 10
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.width
        implicitHeight:10
        width: control.availableWidth
        height: implicitHeight
        radius: height/2
        color: "#bdbebf"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#21be2b"
            radius: height/2
        }
    }
    onValueChanged: {
        console.log("slider:",value)

    }
    Text{
        anchors.horizontalCenter: parent.horizontalCenter
        color:themesTextColor
        font.pixelSize: 30
        text: parent.value
    }
    Text{
        id:titleText
        color:themesTextColor2
        font.pixelSize: 25
        text: "进水量"
    }
    Text{
        id:unitText
        anchors.right: parent.right
        anchors.rightMargin: 50
        color:themesTextColor
        font.pixelSize: 30
        text: "ML"
    }
}
