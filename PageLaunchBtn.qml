import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    signal startUp()
    signal reserve()
    width:140
    height: 50*2+54

    Button {
        width:parent.width
        height: 50
        anchors.top: parent.top
        background: Rectangle{
            color:themesTextColor2
            radius: 25
        }
        Text{
            text:qsTr("启动")
            color:"#000"
            font.pixelSize: 34
            anchors.centerIn: parent
        }
        onClicked: {
            startUp()
        }
    }
    Button {
        width:parent.width
        height: 50
        anchors.bottom: parent.bottom
        background: Rectangle{
            color:themesTextColor2
            radius: 25
        }
        Text{
            text:qsTr("预约")
            color:"#000"
            font.pixelSize: 34
            anchors.centerIn: parent
        }
        onClicked: {
            reserve()
        }
    }
}
