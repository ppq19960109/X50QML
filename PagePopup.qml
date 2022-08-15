import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/SendFunc.js" as SendFunc
Item {
    signal cancel()
    signal confirm()
    signal mcompleted()
    signal mdestruction()

    property alias closeVisible: closeBtn.visible
    property alias hintTopText: hintTop.text
    property alias hintCenterText: hintCenter.text
    property alias confirmText: confirmBtnText.text
    property alias hintHeight: hint.height
    property var confirmFunc:null

    MouseArea{
        anchors.fill: parent
    }
    //anchors.fill: parent

    Component.onCompleted: {
        if(sysPower > 0)
            sleepWakeup()
//        else
//            SendFunc.setSysPower(1)
        mcompleted()
    }
    Component.onDestruction: {
        mdestruction()
        confirmFunc=null
    }

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 292
        color: themesPopupWindowColor
        radius: 16

        Button {
            id:closeBtn
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
                cancel()
            }
        }

        Text{
            id:hintTop
            width:parent.width-80
            visible: hintTop.text!=""
            color:"white"
            font.pixelSize: 34
            anchors.top: parent.top
            anchors.topMargin: 65
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight :1.2
            wrapMode:Text.WrapAnywhere
        }
        Text{
            id:hintCenter
            visible: hintCenter.text!=""
            width:parent.width-80
            color:"white"
            font.pixelSize: 40
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.WrapAnywhere
        }

        Button {
            id:confirmBtn
            visible: confirmBtnText.text!=""
            width:176+10
            height:64+10
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id:confirmBtnText
                anchors.centerIn: parent
                color:"#000"
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                  text:""
            }
            background: Rectangle {
                width:176
                height:64
                anchors.centerIn: parent
                color:themesTextColor2
                radius: 32
            }
            onClicked: {
                if(confirmFunc!=null)
                    confirmFunc()
                else
                    confirm()
            }
        }
    }

}
