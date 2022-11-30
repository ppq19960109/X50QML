import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import ".."
import "../pageCook"
Item {
    property int current_weight:0
    property var weight:QmlDevState.state.Weight
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"称重"
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
        onLeftClick:{
        }
        onRightClick:{
        }
    }
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        Image {
            asynchronous:true
            smooth:false
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 50
            source: themesImagesPanguPath+"weigh-background.png"
            Rectangle{
                width: 160
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 216
                color: themesTextColor
                radius: 5
                Text{
                    anchors.centerIn: parent
                    font.pixelSize: 40
                    color:"#fff"
                    text: (weight-current_weight)+"g"
                }
            }
        }
        Text{
            anchors.top:parent.top
            anchors.topMargin: 90
            anchors.left: parent.left
            anchors.leftMargin:320
            font.pixelSize: 30
            color:"#fff"
            text: "清零后，请将需称重\n的食材放入料理机中"
        }
        Button {
            width:176
            height: 64
            anchors.top:parent.top
            anchors.topMargin: 217
            anchors.left: parent.left
            anchors.leftMargin:360
            background: Rectangle{
                color:themesTextColor2
                radius: 32
            }
            Text{
                text:"清零"
                color:"#000"
                font.pixelSize: 32
                font.bold: true
                anchors.centerIn: parent
            }
            onClicked: {
                current_weight=weight
            }
        }
    }
}
