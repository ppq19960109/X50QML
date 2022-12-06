import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import ".."
import "../pageCook"
Item {
    function steamStart(reserve)
    {
        //        console.log("PageSteamBakeReserve",tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var list = []
        var steps={}

        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.time=parseInt(timePathView.model[timePathView.currentIndex])*60
        steps.motorSpeed=parseInt(speedPathView.model[speedPathView.currentIndex])
        steps.waterTime=parseInt(waterPathView.model[waterPathView.currentIndex])
        steps.mode=17
        steps.fire=5
        steps.motorDir=0
        steps.fan=1
        steps.hoodSpeed=1
        steps.repeat=0
        list.push(steps)

        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=list
        if(reserve)
        {
            load_page("pagePanguReserve",{"root":para})
            return
        }
        startPanguCooking(para,list)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
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
        var array = new Array
        for(i=5; i<= 150;i+=5) {
            array.push(i+"℃")
        }
        tempPathView.model=array
        tempPathView.currentIndex=11
        array = new Array
        for( i=1; i<= 480; ++i) {
            array.push(i+"分钟")
        }
        timePathView.model=array
        timePathView.currentIndex=19
        array = new Array
        for( i=0; i<= 20; ++i) {
            array.push(i+"档")
        }
        speedPathView.model=array
        speedPathView.currentIndex=5
        array = new Array
        for( i=0; i<= 2500; i+=10) {
            array.push(i+"ml")
        }
        waterPathView.model=array
        waterPathView.currentIndex=100

        SendFunc.permitSteamStartStatus(1)
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"+自定义"
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{
            backPrePage()
        }
        onLeftClick:{
            steamStart(false)
        }
        onRightClick:{
            steamStart(true)
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        PageDivider{
            anchors.verticalCenter:rowPathView.verticalCenter
            anchors.verticalCenterOffset:50
        }
        PageDivider{
            anchors.verticalCenter:rowPathView.verticalCenter
            anchors.verticalCenterOffset:-50
        }

        Row {
            id:rowPathView
            width: 180*4
            height:330
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            spacing: 0

            DataPathView {
                id:tempPathView
                width: 180
                height:parent.height
                currentIndex:0
                Image {
                    visible: tempPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("温度")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:timePathView
                width: 180
                height:parent.height
                Image {
                    visible: timePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("时间")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:speedPathView
                width: 180
                height:parent.height
                Image {
                    visible: speedPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("转速(正)")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:waterPathView
                width: 180
                height:parent.height
                Image {
                    visible: waterPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("进水量")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
        }
    }
}