import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "qrc:/SendFunc.js" as SendFunc
Item {
    readonly property var loadPowerState: ["停止状态", "上加热管+红外发热管1100+700W", "炉风+发热片200+18W", "下发热管+热风发热管1000+700W", "大风180W", "蒸烤发热盘1000W+800W", "照明灯+两炉灯+左右水泵11+2+2W", "蒸发热盘+左右水泵1000W+800W"]

    Component.onCompleted: {
        SendFunc.loadPowerSet(1)
    }
    Component.onDestruction: {
        SendFunc.loadPowerSet(0)
    }
    Item{
        width:parent.width
        height:80
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:themesTextColor
            font.pixelSize: 40
            font.bold : true
            text: qsTr("负载功率检测")
        }
    }
    Rectangle{
        width:parent.width-100
        height:200
        anchors.centerIn: parent
        color:themesPopupWindowColor
        Text{
            width: 200
            height: parent.height
            anchors.left: parent.left
            text:"步骤 "+QmlDevState.state.LoadPowerState
            color:"#fff"
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text{
            width: 500
            height: parent.height
            anchors.right: parent.right
            text:loadPowerState[QmlDevState.state.LoadPowerState]
            color:"#fff"
            font.pixelSize: 40
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Button{
        width:100
        height:50
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        background:Rectangle{
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"退出"
            color:"#fff"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            backPrePage()
        }
    }

}
