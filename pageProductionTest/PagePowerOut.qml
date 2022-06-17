import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/SendFunc.js" as SendFunc
Item {

    Component.onCompleted: {
        SendFunc.loadPowerSet(3)
    }
    Component.onDestruction: {
        SendFunc.loadPowerSet(0)
    }
    Item{
        id:topBar
        width:parent.width
        height:80
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:themesTextColor
            font.pixelSize: 40
            font.bold : true
            text: qsTr("电源板输出检测")
        }
        Button{
            width:100
            height:50
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
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

    Rectangle{
        width:parent.width-100
        height:200
        anchors.centerIn: parent
        color:themesPopupWindowColor
        Text{
            anchors.centerIn: parent
            text:"步骤 "+QmlDevState.state.LoadPowerState
            color:"#fff"
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
