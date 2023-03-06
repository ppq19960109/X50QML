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

        var cookTime=parseInt(timePathView.model[timePathView.currentIndex])*60+parseInt(secondsPathView.model[secondsPathView.currentIndex])
        var modeArray=QmlDevState.getTestMode()
        var list=modeArray[modePathView.currentIndex].cookSteps
        console.log("steamStart:",list.length,cookTime)
//        switch(modePathView.currentIndex)
//        {
//        case 0:
//            list[list.length-1].repeat=Math.floor(cookTime/10)
//            if(list[list.length-1].repeat>0)
//                --list[list.length-1].repeat
//            break
//        case 1:
//            list[list.length-1].repeat=Math.floor(cookTime/40)
//            if(list[list.length-1].repeat>0)
//                --list[list.length-1].repeat
//            break
//        case 2:
//            list[list.length-1].cookTime=cookTime
//            break
//        default:
//            break
//        }
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
        modePathView.model=["低温测试模式","低速耐久模式","高速耐久模式","火力模式","加热寿命模式"]
        var array
        array = new Array
        for( i=0; i<= 480; ++i) {
            array.push(i+"分钟")
        }
        timePathView.model=array
        timePathView.currentIndex=6
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
        leftBtnText:qsTr("启动")
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
            width: 220*3
            height:330
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            spacing: 0
            DataPathView {
                id:modePathView
                width: 220
                height:parent.height
                currentIndex:0
                Image {
                    visible: modePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("模式")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:timePathView
                width: 220
                height:parent.height
                Image {
                    visible: timePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
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
                width: 220
                height:parent.height
                Image {
                    visible: secondsPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
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
        }
    }
}
