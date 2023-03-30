import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import ".."
import "../pageCook"
Rectangle {
    color:themesWindowBackgroundColor
    property int modeIndex:-1
    property int tempIndex:-1
    property int timeIndex:-1
    property int fireIndex:-1
    property int waterIndex:-1
    property int repeatIndex:-1
    property int motorDirIndex:-1
    property int motorSpeedIndex:-1
    property int repeatStepIndex:-1
    property alias name: topBar.name
    property alias leftBtnText: topBar.leftBtnText
    property alias rightBtnText: topBar.rightBtnText
    signal showListData(var listData)
    function steamStart(reserve)
    {
        //        console.log("PageSteamBakeReserve",tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var steps={}

        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.cookTime=parseInt(secondsPathView.model[secondsPathView.currentIndex])
        steps.motorSpeed=parseInt(speedPathView.model[speedPathView.currentIndex])
        if(steps.motorSpeed>=0)
            steps.motorDir=0
        else
        {
            steps.motorDir=1
            steps.motorSpeed=Math.abs(steps.motorSpeed)
        }
        steps.mode=modePathView.currentIndex+1

        if(steps.temp>0)
        {
            steps.hoodSpeed=1
        }
        else
        {
            steps.hoodSpeed=0
        }

        steps.waterTime=parseInt(waterPathView.model[waterPathView.currentIndex])
        steps.fire=parseInt(firePathView.model[firePathView.currentIndex])
        steps.fan=1
        steps.repeat=parseInt(repeatPathView.model[repeatPathView.currentIndex])
        steps.repeatStep=parseInt(repeatStepPathView.model[repeatStepPathView.currentIndex])
        steps.runPause=0
        showListData(steps)
        dismissTanchang()
    }

    Component.onCompleted: {
        var i
        modePathView.model=["无效","大厨","智能1","智能2","智能3"]
        if(modeIndex>=0)
            modePathView.currentIndex=modeIndex

        var array = new Array
        array.push("0℃")
        for(i=35; i<= 200;i+=1) {
            array.push(i+"℃")
        }
        tempPathView.model=array
        tempPathView.currentIndex=6
        if(tempIndex>=0)
        {
            if(tempIndex==0)
                tempPathView.currentIndex=0
            else
                tempPathView.currentIndex=(tempIndex-35)+1
        }

        array = new Array
        for( i=0; i<= 10; ++i) {
            array.push(i+"档")
        }
        firePathView.model=array
        firePathView.currentIndex=4
        if(fireIndex>=0)
        {
            firePathView.currentIndex=fireIndex
        }

        array = new Array
        for( i=-20; i<= 20; ++i) {
            array.push(i+"档")
        }
        speedPathView.model=array
        speedPathView.currentIndex=20
        if(motorDirIndex>=0)
        {
            if(motorDirIndex==0)
                speedPathView.currentIndex=motorSpeedIndex+20
            else
                speedPathView.currentIndex=20-motorSpeedIndex
        }

        array = new Array
        for( i=0; i< 1800; i+=10) {
            array.push(i+"秒")
        }
        secondsPathView.model=array
        secondsPathView.currentIndex=0
        if(timeIndex>=0)
        {
            secondsPathView.currentIndex=timeIndex/10
        }

        array = new Array
        for( i=0; i<= 1500; i+=50) {
            array.push(i+"ml")
        }
        waterPathView.model=array
        waterPathView.currentIndex=0
        if(waterIndex>=0)
        {
            waterPathView.currentIndex=waterIndex/50
        }

        array = new Array
        for( i=0; i<= 30; i+=1) {
            array.push(i+"次")
        }
        repeatPathView.model=array
        repeatPathView.currentIndex=0
        if(repeatIndex>=0)
        {
            repeatPathView.currentIndex=repeatIndex
        }

        array = new Array
        for( i=0; i<= 5; i+=1) {
            array.push(i)
        }
        repeatStepPathView.model=array
        repeatStepPathView.currentIndex=0
        if(repeatStepIndex>=0)
        {
            repeatStepPathView.currentIndex=repeatStepIndex
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"自定义"
        leftBtnText:qsTr("确认")
        //        rightBtnText:qsTr("预约")
        onClose:{
            dismissTanchang()
        }
        onLeftClick:{

        }
        onRightClick:{
            steamStart(false)
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
            width: 100*8
            height:330
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            spacing: 0
            DataPathView {
                id:modePathView
                width: 100
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
                id:tempPathView
                width: 100
                height:parent.height
                currentIndex:0
                Image {
                    visible: tempPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
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
                id:firePathView
                width: 100
                height:parent.height
                currentIndex:0
                Image {
                    visible: firePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("火力")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -40
                }
            }
            DataPathView {
                id:secondsPathView
                width: 100
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
            DataPathView {
                id:speedPathView
                width: 100
                height:parent.height
                Image {
                    visible: speedPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
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
            DataPathView {
                id:waterPathView
                width: 100
                height:parent.height
                Image {
                    visible: waterPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
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
            DataPathView {
                id:repeatPathView
                width: 100
                height:parent.height
                Image {
                    visible: repeatPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("重复\n次数")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -50
                }
            }
            DataPathView {
                id:repeatStepPathView
                width: 100
                height:parent.height
                Image {
                    visible: repeatStepPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Text{
                    text:qsTr("重复\n步长")
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: -50
                }
            }
        }
    }
}
