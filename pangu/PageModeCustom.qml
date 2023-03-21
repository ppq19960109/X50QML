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
        steps.cookTime=parseInt(timePathView.model[timePathView.currentIndex])*60+parseInt(secondsPathView.model[secondsPathView.currentIndex])
        steps.motorSpeed=parseInt(speedPathView.model[speedPathView.currentIndex])
        if(steps.motorSpeed>=0)
            steps.motorDir=0
        else
        {
            steps.motorDir=1
            steps.motorSpeed=Math.abs(steps.motorSpeed)
        }
        if(steps.temp>0)
        {
            steps.mode=3
            steps.hoodSpeed=1
        }
        else
        {
            steps.mode=1
            steps.hoodSpeed=0
        }

        steps.waterTime=0
        steps.fire=5
        steps.fan=1
        steps.repeat=0
        steps.repeatStep=0
        steps.runPause=0
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
        array.push("0℃")
        for(i=35; i<= 200;i+=5) {
            array.push(i+"℃")
        }
        tempPathView.model=array
        tempPathView.currentIndex=6
        array = new Array
        for( i=0; i<= 480; ++i) {
            array.push(i+"分钟")
        }
        timePathView.model=array
        timePathView.currentIndex=10
        array = new Array
        for( i=-20; i<= 20; ++i) {
            array.push(i+"档")
        }
        speedPathView.model=array
        speedPathView.currentIndex=21
        array = new Array
        for( i=0; i< 60; i+=1) {
            array.push(i+"秒")
        }
        secondsPathView.model=array
        secondsPathView.currentIndex=0

        SendFunc.permitSteamStartStatus(1)
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"+自定义"
        //        leftBtnText:qsTr("启动")
        //        rightBtnText:qsTr("预约")
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
                    text:qsTr("分钟")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:secondsPathView
                width: 180
                height:parent.height
                Image {
                    visible: secondsPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("秒")
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
                    text:qsTr("转速")
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