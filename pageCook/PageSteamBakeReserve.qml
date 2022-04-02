import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {
    property var root
    function steamStart()
    {
        console.log("PageSteamBakeReserve",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])
        startCooking(root,JSON.parse(root.cookSteps),hourPathView.currentIndex*60+minutePathView.currentIndex)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSteamBakeReserve onStateChanged",key)
            if("SteamStart"==key)
            {
                steamStart()
            }
        }
    }
    Component.onCompleted: {
        var i
        var hourArray = new Array
        for(i=0; i< 12; ++i) {
            hourArray.push(i+"小时")
        }
        hourPathView.model=hourArray
        var minuteArray = new Array
        for( i=0; i< 60; ++i) {
            minuteArray.push(i+"分钟")
        }
        minutePathView.model=minuteArray

        console.log("state",state,typeof state)
        root=JSON.parse(state)

    }
    //'<font size="5">测试</font>

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:"预约  <font size='-1'>("+root.dishName+")</font>"
        leftBtnText:qsTr("")
        rightBtnText:qsTr("启动")
        onClose:{
                backPrePage()
        }

        onLeftClick:{

        }
        onRightClick:{
                steamStart()
        }
    }

    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        PageDivider{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3+50
        }
        PageDivider{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2+50
        }
        Image {
            asynchronous:true
            anchors.centerIn: parent
            source: "qrc:/x50/steam/黑色块.png"
        }
        ListModel {
            id:modeListModel
        }
        Row {
            id:rowPathView
            width: parent.width-80
            height:parent.height-100
            anchors.centerIn: parent
            spacing: 10

            DataPathView {
                id:hourPathView
                width: parent.width/3
                height:parent.height

                currentIndex:0
                onValueChanged: {

                }
            }
            DataPathView {
                id:minutePathView
                width: parent.width/3
                height:parent.height

                Component.onCompleted:{

                }
            }
            Text{
                width:120
                color:"white"
                font.pixelSize: 40
                anchors.verticalCenter: parent.verticalCenter
                text:qsTr("后启动")
            }
        }
    }
}
