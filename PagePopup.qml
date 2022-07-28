import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/SendFunc.js" as SendFunc
Item {
    //    property int priority:0
    property alias closeVisible: closeBtn.visible
    property alias hintTopText: hintTop.text
    property alias hintCenterText: hintCenter.text
    property alias confirmText: confirmBtnText.text
    property alias hintHeight: hint.height
    property var confirmFunc:null
    signal cancel()
    signal confirm()
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent

    Component.onCompleted: {
        if(sysPower > 0)
            sleepWakeup()
        else
            SendFunc.setSysPower(1)
    }
    Component.onDestruction: {
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
                asynchronous:true
                smooth:false
                cache:false
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
