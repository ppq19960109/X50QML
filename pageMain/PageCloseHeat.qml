import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var root
    Component.onCompleted: {
        var i
        var hourArray = new Array
        for(i=0; i< 3; ++i) {
            hourArray.push(i+"小时")
        }
        hourPathView.model=hourArray
        var minuteArray = new Array
        for( i=0; i< 60; ++i) {
            minuteArray.push(i+"分钟")
        }
        minutePathView.model=minuteArray
        //        if(QmlDevState.state.RStoveTimingState===timingStateEnum.RUN)
        //        {
        //            QmlDevState.setState("RStoveTimingState",2)
        //            var Data={}
        //            Data.RStoveTimingOpera =timingOperationEnum.CANCEL
        //            SendFunc.setToServer(Data)
        //        }

    }
    Connections { // 将目标对象信号与槽函数进行连接
        id:connections
        enabled:false
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageCloseHeat onStateChanged",key)
            if("SteamStart"==key)
            {
                steamStart()
            }
            else if("RStoveStatus"==key)
            {
                if(value)
                    permitStart()
                else
                    SendFunc.permitSteamStartStatus(0)
            }
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
    }
    function permitStart()
    {
        if(hourPathView.currentIndex==0 && minutePathView.currentIndex==0)
        {
            if(permitStartStatus!=0)
            {
                SendFunc.permitSteamStartStatus(0)
            }
        }
        else
        {
            if(permitStartStatus==0)
            {
                SendFunc.permitSteamStartStatus(1)
            }
        }
    }
    function steamStart()
    {
        if(QmlDevState.state.RStoveStatus===1)
        {
            if(hourPathView.currentIndex==0 && minutePathView.currentIndex==0)
                return
            console.log("PageCloseHeat",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])

            var Data={}
            Data.RStoveTimingOpera = timingOperationEnum.START
            Data.RStoveTimingSet = hourPathView.currentIndex*60+minutePathView.currentIndex
            SendFunc.setToServer(Data)

            //                            QmlDevState.setState("RStoveTimingLeft",hourPathView.currentIndex*60+minutePathView.currentIndex)
            //                            QmlDevState.setState("RStoveTimingState",timingStateEnum.RUN)
            backPrePage()
        }
        else
        {
            showLoaderPopup("右灶未开启\n开启后才可定时关火",275)
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"定时关火  <font size='30px'>(右灶开启后才可定时关火)</font>"
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
            width: parent.width-140
            height:parent.height-80
            anchors.top:parent.top
            anchors.bottom: parent.bottom
            anchors.centerIn: parent
            spacing: 0

            DataPathView {
                id:hourPathView
                width: 226
                height:parent.height
                currentIndex:0
                Image {
                    visible: hourPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                onValueChanged: {
                    console.log(index,valueName)
                    permitStart()
                }
                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===timingStateEnum.RUN)
                        currentIndex=Math.floor(QmlDevState.state.RStoveTimingLeft/60)
                }
            }
            DataPathView {
                id:minutePathView
                width: 226
                height:parent.height
                //                currentIndex:1
                Image {
                    visible: minutePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                onValueChanged: {
                    console.log(index,valueName)
                    permitStart()
                }
                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===timingStateEnum.RUN)
                        currentIndex=QmlDevState.state.RStoveTimingLeft%60
                }
            }
            Text{
                width:200
                color:themesTextColor2
                font.pixelSize: 35
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr("后定时关火")
            }
        }
    }
}
