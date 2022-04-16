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
        if(QmlDevState.state.RStoveStatus!==1)
            showLoaderFaultCenter("右灶未开启\n开启后才可定时关火",275)
    }


    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"定时关火  <font size='-1'>(右灶开启后才可定时关火)</font>"
        leftBtnText:qsTr("")
        rightBtnText:qsTr("启动")
        onClose:{
            backPrePage()
        }

        onLeftClick:{

        }
        onRightClick:{
            if(QmlDevState.state.RStoveStatus===1)
            {
                if(hourPathView.currentIndex==0 && minutePathView.currentIndex==0)
                    return
                console.log("PageCloseHeat",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])

                var Data={}
                Data.RStoveTimingOpera = timingOperationEnum.START
                Data.RStoveTimingSet = hourPathView.currentIndex*60+minutePathView.currentIndex
                SendFunc.setToServer(Data)

//                QmlDevState.setState("RStoveTimingLeft",hourPathView.currentIndex*60+minutePathView.currentIndex)
//                QmlDevState.setState("RStoveTimingState",timingStateEnum.RUN)
                backPrePage()
            }
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

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

        Row {
            id:rowPathView
            width: parent.width-80
            height:parent.height-100
            anchors.top:parent.top
            anchors.bottom: parent.bottom
            anchors.centerIn: parent
            spacing: 10

            DataPathView {
                id:hourPathView
                width: parent.width/3
                height:parent.height

                currentIndex:0
                Image {
                    visible: hourPathView.moving
                    asynchronous:true
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===1)
                        currentIndex=Math.floor(QmlDevState.state.RStoveTimingLeft/60)
                }
            }
            DataPathView {
                id:minutePathView
                width: parent.width/3
                height:parent.height
                Image {
                    visible: minutePathView.moving
                    asynchronous:true
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===1)
                        currentIndex=QmlDevState.state.RStoveTimingLeft%60
                }
            }
            Text{
                //                width:120
                color:"white"
                font.pixelSize: 40
                anchors.verticalCenter: parent.verticalCenter
                text:qsTr("后定时关火")
            }
        }
    }
}
