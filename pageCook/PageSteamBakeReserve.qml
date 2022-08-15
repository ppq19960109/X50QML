import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property var root
    function steamStart()
    {
//        console.log("PageSteamBakeReserve",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])
        root.orderTime=hourPathView.currentIndex*60+minutePathView.currentIndex
        if(root.cookSteps=="")
        {
            startCooking(root,null)
            return
        }
        var cookSteps=JSON.parse(root.cookSteps)
        if(root.cookPos===cookWorkPosEnum.LEFT)
        {
            if(systemSettings.cookDialog[2]>0)
            {
                if(CookFunc.isSteam(cookSteps))
                    loaderSteamShow(360,"请将食物放入左腔\n将水箱加满水","开始预约",root,2)
                else
                    loaderSteamShow(292,"请将食物放入左腔","开始预约",root,2)
                return
            }
        }
        else
        {
            if(systemSettings.cookDialog[3]>0)
            {
                loaderSteamShow(360,"请将食物放入右腔\n将水箱加满水","开始预约",root,3)
                return
            }
        }
        startCooking(root,cookSteps)
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
            key=null
            value=null
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

//        console.log("state",state,typeof state)
        SendFunc.permitSteamStartStatus(1)
    }
    //'<font size="5">测试</font>

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"预约  "+(root.dishName==""?"":"<font size='30px'>("+root.dishName+")</font>")
        leftBtnText:qsTr("")
//                rightBtnText:qsTr("启动")
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
            anchors.topMargin:rowPathView.height/3+40
        }
        PageDivider{
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2+40
        }

        Row {
            id:rowPathView
            width: parent.width-148
            height:parent.height-71
            anchors.centerIn: parent
            spacing: 0

            DataPathView {
                id:hourPathView
                width: 236
                height:parent.height

                currentIndex:0
                Image {
                    visible: hourPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
            }
            DataPathView {
                id:minutePathView
                width: 236
                height:parent.height
                Image {
                    visible: minutePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
            }
            Text{
                width:180
                color:themesTextColor2
                font.pixelSize: 35
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr("后启动")
            }
        }
    }
}
