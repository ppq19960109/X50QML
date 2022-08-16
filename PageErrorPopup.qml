import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/SendFunc.js" as SendFunc
Item {
    property alias closeVisible: closeBtn.visible
    property alias hintTopText: hintTop.text
    property alias hintBottomText: hintBottom.text
    property alias hintHeight: hint.height

    Component.onCompleted: {
        if(errorBuzzer==false)
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
        implicitWidth: 820
        implicitHeight: 350
        color: themesPopupWindowColor
        radius: 10

        PageCloseButton {
            id:closeBtn
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                loader_error.source = ""
            }
        }
        Image {
            anchors.top:parent.top
            anchors.topMargin: 34
            anchors.horizontalCenter: parent.horizontalCenter
            asynchronous:true
            smooth:false
            source: themesPicturesPath+"icon_error.png"
        }
        Text{
            id:hintTop
            visible: hintTop.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 115
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WrapAnywhere
        }

        Text{
            id:hintBottom
            visible: hintBottom.text!=""
            width:parent.width
            color:"white"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 175
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WrapAnywhere
        }
        Button {
            width:140+10
            height:50+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                text:"好的"
            }
            background: Rectangle {
                width:140
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            onClicked: {
                loader_error.source = ""
            }
        }
    }
}
