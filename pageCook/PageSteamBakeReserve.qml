import QtQuick 2.7
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
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSteamBakeReserve onStateChanged",key)
            if("SteamStart"==key)
            {
                steamStart()
            }
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
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
        anchors.bottom:parent.bottom
        name:"预约  <font size='30px'>("+root.dishName+")</font>"
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
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        PageDivider{
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3+50
        }
        PageDivider{
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2+50
        }

        ListModel {
            id:modeListModel
        }
        Row {
            id:rowPathView
            width: parent.width-140
            height:parent.height-80
            anchors.centerIn: parent
            spacing: 20

            DataPathView {
                id:hourPathView
                width: 226
                height:parent.height

                currentIndex:0
                Image {
                    visible: hourPathView.moving
                    asynchronous:true
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                onValueChanged: {

                }
            }
            DataPathView {
                id:minutePathView
                width: 226
                height:parent.height
                Image {
                    visible: minutePathView.moving
                    asynchronous:true
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Component.onCompleted:{
                    currentIndex=1
                }
            }
            Text{
                width:180
                color:themesTextColor2
                font.pixelSize: 35
                anchors.verticalCenter: parent.verticalCenter
                text:qsTr("后启动")
            }
        }
    }
}
