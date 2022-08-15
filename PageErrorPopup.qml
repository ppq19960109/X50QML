import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Item {
    property alias closeVisible: closeBtn.visible
    property alias hintTopText: hintTop.text
    property alias hintBottomText: hintBottom.text
    property alias hintHeight: hint.height

    Component.onCompleted: {
        SendFunc.setBuzControl(buzControlEnum.OPEN)
    }
    Component.onDestruction: {
        SendFunc.setBuzControl(buzControlEnum.STOP)
    }

    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 292
        color: themesPopupWindowColor
        radius: 16

        Button {
            id:closeBtn
            visible: true
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
            anchors.right:parent.right
            Image {
                id:closeImg
                anchors.centerIn: parent
                source: themesImagesPath+"icon-window-close.png"
            }
            background: Item {}
            onClicked: {
                loader_error.source = ""
            }
        }

        Text{
            id:hintTop
            visible: hintTop.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.Wrap
        }

        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width-80
            color:"white"
            font.pixelSize: 34
            anchors.top: parent.top
            anchors.topMargin: 150
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WrapAnywhere
        }
    }
}
