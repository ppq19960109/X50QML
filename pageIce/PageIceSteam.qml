import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Rectangle {
    color:themesWindowBackgroundColor
    property int cookPos:0
    property alias name: topBar.name
    property alias leftBtnText: topBar.leftBtnText
    property alias rightBtnText: topBar.rightBtnText
    property alias modePathViewEnabled:modePathView.enabled
    property var modePathViewIndex
    property var tempPathViewIndex
    property var timePathViewIndex
    signal showListData(var listData)

    property var root
    property var para

    readonly property var leftWorkBigImg: ["", "qrc:/x50/steam/icon_经典蒸.png", "qrc:/x50/steam/icon_高温蒸.png", "qrc:/x50/steam/icon_热风烧烤.png", "qrc:/x50/steam/icon_上下加热.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_蒸汽烤.png", "qrc:/x50/steam/icon_空气炸.png", "qrc:/x50/steam/icon_保暖烘干.png","qrc:/x50/steam/icon_便捷蒸.png","qrc:/x50/steam/icon_便捷蒸.png","qrc:/x50/steam/icon_便捷蒸.png"]
    readonly property var leftWorkSmallImg: ["", "qrc:/x50/steam/icon_经典蒸缩小.png", "qrc:/x50/steam/icon_高温蒸缩小.png", "qrc:/x50/steam/icon_热风烧烤缩小.png", "qrc:/x50/steam/icon_上下加热缩小.png", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_蒸汽烤缩小.png", "qrc:/x50/steam/icon_空气炸缩小.png", "qrc:/x50/steam/icon_保暖烘干缩小.png","qrc:/x50/steam/icon_经典蒸缩小.png","qrc:/x50/steam/icon_经典蒸缩小.png","qrc:/x50/steam/icon_经典蒸缩小.png"]

    function steamStart()
    {
        console.log("PageSteamBakeBase",modePathView.currentIndex,modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var list = []
        var steps={}
        steps.device=root.device

        steps.mode=leftWorkModeNumber[modePathView.model.get(modePathView.currentIndex).modelData]

        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.time=parseInt(timePathView.model[timePathView.currentIndex])
        list.push(steps)

        para =CookFunc.getDefHistory()
        para.cookPos=root.device
        para.dishName=CookFunc.getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)
        console.log("para:",JSON.stringify(para),systemSettings.leftCookDialog,systemSettings.rightCookDialog,root.device)

        startCooking(para,list)
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
        console.log("PageIceSteam onCompleted",cookPos)
        var i;

        var timeArray = new Array
        for(i=1; i<= 120; ++i) {
            timeArray.push(i+"分钟")
        }
        for(i=125; i<= 720; i+=5) {
            timeArray.push(i+"分钟")
        }
        timePathView.model=timeArray

        if(cookPos==leftDevice)
        {
            for (i=0; i< rightModeIndex; ++i)
                modeListModel.append(leftModel[i])
        }
        else
        {
            for (i=rightModeIndex; i< leftModel.length; ++i)
                modeListModel.append(leftModel[i])
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:""
        //        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{
            dismissTanchang();
        }

        onLeftClick:{
            steamStart()
        }
        onRightClick:{

            var param = {}
            param.pos=cookPos
            param.mode=leftWorkModeNumber[modePathView.model.get(modePathView.currentIndex).modelData]
            param.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
            param.time=parseInt(timePathView.model[timePathView.currentIndex])
            showListData(param);
            dismissTanchang();
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        PageDivider{
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3+30
        }
        PageDivider{
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2+30
        }

        ListModel {
            id:modeListModel
        }

        Row {
            id:rowPathView
            width: parent.width-60
            height:parent.height-60
            anchors.centerIn: parent
            spacing: 0

            IceDataPathView {
                id:modePathView
                width: 292
                height:parent.height
                model:modeListModel
                delegateIndex:1
                currentIndex:0
                Image {
                    visible: modePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/mode-change-background.png"
                }
                onValueChanged: {
                    console.log(index,valueName)
                    console.log("model onValueChanged:",model.get(index).modelData)
                    var minTemp=model.get(index).minTemp
                    var maxTemp=model.get(index).maxTemp
                    var tempArray=[]
                    for(var i=minTemp; i<= maxTemp; ++i) {
                        tempArray.push(i+"℃")
                    }
                    tempPathView.model=tempArray
                    tempPathView.currentIndex=model.get(index).temp-model.get(index).minTemp;
                    timePathView.currentIndex=model.get(index).time-1;

                }
                Component.onCompleted:{
                    console.log("modePathView",modePathView.currentIndex,modePathViewIndex)
                    if(modePathViewIndex===undefined)
                    {

                    }
                    else
                    {
                        modePathView.currentIndex=modePathViewIndex
                    }
                    var minTemp=model.get(modePathView.currentIndex).minTemp
                    var maxTemp=model.get(modePathView.currentIndex).maxTemp
                    var tempArray=[]
                    for(var i=minTemp; i<= maxTemp; ++i) {
                        tempArray.push(i+"℃")
                    }
                    tempPathView.model=tempArray

                    if(tempPathViewIndex===undefined)
                    {
                        tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp-modePathView.model.get(modePathView.currentIndex).minTemp;
                    }
                    else
                    {
                        tempPathView.currentIndex=tempPathViewIndex
                    }

                    if(timePathViewIndex===undefined)
                    {
                        timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time-1;
                    }
                    else
                    {
                        timePathView.currentIndex=timePathViewIndex
                    }
                }
            }
            IceDataPathView {
                id:tempPathView
                width: 226
                height:parent.height
                delegateIndex:0
                Image {
                    visible: tempPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Component.onCompleted:{
                    console.log("tempPathView",tempPathView.currentIndex,tempPathViewIndex)

                }
            }
            IceDataPathView {
                id:timePathView
                width: 226
                height:parent.height
                delegateIndex:0
                Image {
                    visible: timePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                Component.onCompleted:{
                    console.log("timePathView",timePathView.currentIndex,timePathViewIndex)
                }
            }
        }
    }

}
