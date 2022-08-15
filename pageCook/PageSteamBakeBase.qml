import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Rectangle {
    color:themesWindowBackgroundColor
    property int multiMode:0
    property alias name: topBar.name
    property alias leftBtnText: topBar.leftBtnText
    property alias rightBtnText: topBar.rightBtnText
    property var modePathViewIndex:undefined
    property var tempPathViewIndex:undefined
    property var timePathViewIndex:undefined
    signal showListData(var listData)

    readonly property var leftWorkBigImg: ["", "qrc:/x50/steam/icon_经典蒸.png", "qrc:/x50/steam/icon_高温蒸.png", "qrc:/x50/steam/icon_热风烧烤.png", "qrc:/x50/steam/icon_上下加热.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_蒸汽烤.png", "qrc:/x50/steam/icon_空气炸.png", "qrc:/x50/steam/icon_保暖烘干.png","qrc:/x50/steam/icon_便捷蒸.png"]
    readonly property var leftWorkSmallImg: ["", "qrc:/x50/steam/icon_经典蒸缩小.png", "qrc:/x50/steam/icon_高温蒸缩小.png", "qrc:/x50/steam/icon_热风烧烤缩小.png", "qrc:/x50/steam/icon_上下加热缩小.png", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_蒸汽烤缩小.png", "qrc:/x50/steam/icon_空气炸缩小.png", "qrc:/x50/steam/icon_保暖烘干缩小.png","qrc:/x50/steam/icon_经典蒸缩小.png"]

    property int device:0
    property int reserve:0

    function steamStart()
    {
        //        console.log("PageSteamBakeBase",modePathView.currentIndex,modePathView.model.[modePathView.currentIndex].modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var list = []
        var steps={}

        steps.mode=workModeNumberEnum[modePathView.model[modePathView.currentIndex].modelData]
        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.time=parseInt(timePathView.model[timePathView.currentIndex])
        list.push(steps)
        var para
        para =CookFunc.getDefHistory()
        para.cookPos=device
        para.dishName=CookFunc.getDishName(list)
        para.cookSteps=JSON.stringify(list)
        //        console.log("para:",JSON.stringify(para),systemSettings.leftCookDialog,systemSettings.rightCookDialog)

        if(para.cookPos===cookWorkPosEnum.LEFT)
        {
            if(systemSettings.cookDialog[0]>0)
            {
                if(CookFunc.isSteam(list))
                    loaderSteamShow(360,"请将食物放入左腔\n将水箱加满水","开始烹饪",para,0)
                else
                    loaderSteamShow(292,"请将食物放入左腔","开始烹饪",para,0)
                return
            }
        }
        else
        {
            if(systemSettings.cookDialog[1]>0)
            {
                loaderSteamShow(360,"请将食物放入右腔\n将水箱加满水","开始烹饪",para,1)
                return
            }
        }
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

    ListModel {
        id:modeListModel
    }
    Component.onCompleted: {
//        console.log("PageSteamBakeBase onCompleted")
        var i

        //        var timeArray = []
        //        for(i=1; i<= 120; ++i) {
        //            timeArray.push(i+"分钟")
        //        }
        //        for(i=125; i<= 180; i+=5) {
        //            timeArray.push(i+"分钟")
        //        }
        //        timePathView.model=timeArray
        //        console.log("state",state,typeof state)
        if(multiMode==0 )//|| undefined != state || null != state || "" != state
        {
            if(cookWorkPosEnum.LEFT===device)
            {
                topBar.name="左腔蒸烤"
            }
            else
            {
                topBar.name="右腔速蒸"
                modePathView.model=rightWorkModeModelEnum
            }
            SendFunc.permitSteamStartStatus(1)
            if(reserve!=0)
                topBar.rightBtnText=""
        }
        else
        {
            for (i=0; i< rightWorkModeIndex; ++i) {
                modeListModel.append(workModeModelEnum[i])
            }
        }
    }
    //Component.onDestruction: {
    //    rowPathView.model=null
    //    tempPathView.model=null
    //    timePathView.model=null
    //    modeListModel.clear()
    //}
    //    PageGradient{
    //        anchors.fill: parent
    //        radius:0
    //        border.width:0
    //    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:""
        //        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{

            if(multiMode>0)
            {
                dismissTanchang();
            }
            else
            {
                backPrePage()
            }
        }

        onLeftClick:{
            steamStart()
        }
        onRightClick:{
            if(multiMode>0)
            {
                var param = {};
                param.mode=workModeNumberEnum[modePathView.model[modePathView.currentIndex].modelData]
                param.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
                param.time=parseInt(timePathView.model[timePathView.currentIndex])
                showListData(param);
                dismissTanchang();
            }
            else
            {
                var list = []
                var steps={}
                steps.mode=workModeNumberEnum[modePathView.model[modePathView.currentIndex].modelData]
                steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
                steps.time=parseInt(timePathView.model[timePathView.currentIndex])
                list.push(steps)

                var para =CookFunc.getDefHistory()
                para.cookPos=device
                para.dishName=CookFunc.getDishName(list)
                para.cookSteps=JSON.stringify(list)

                load_page("pageSteamBakeReserve",{"root":para})
                para=undefined
            }
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

        Row {
            id:rowPathView
            width: parent.width-36
            height:parent.height-71
            anchors.centerIn: parent
            spacing: 0

            DataPathView {
                id:modePathView
                width: 292
                height:parent.height
                model:workModeModelEnum
                delegateIndex:1
                currentIndex:0
                Image {
                    visible: modePathView.moving
                    asynchronous:true
                    smooth:false
                    //                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/mode-change-background.png"
                }
                onValueChanged: {
                    //                    console.log("model onValueChanged:",model[index].modelData)
                    var modeItem=model[index]
                    var minTemp=modeItem.minTemp
                    var maxTemp=modeItem.maxTemp
                    var tempArray=[]
                    for(var i=minTemp; i<= maxTemp; ++i) {
                        tempArray.push(i+"℃")
                    }

                    tempPathView.model=tempArray
                    tempPathView.currentIndex=modeItem.temp-minTemp

                    var maxTime=modeItem.maxTime
                    if(maxTime!=null && maxTime!=0)
                    {

                    }
                    else
                    {
                        maxTime=300
                    }
                    var timeArray = []
                    for(i=1; i<= 120; ++i) {
                        timeArray.push(i+"分钟")
                    }
                    for(i=125; i<= maxTime; i+=5) {
                        timeArray.push(i+"分钟")
                    }
                    timePathView.model=timeArray
                    timePathView.currentIndex=CookFunc.getCookTimeIndex(modeItem.time)
                    modeItem=null
                }
                Component.onCompleted:{
                    //                    console.log("modePathView",modePathView.currentIndex,modePathViewIndex)
                    if(modePathViewIndex==null)
                    {

                    }
                    else
                    {
                        modePathView.currentIndex=modePathViewIndex
                    }
                    var modeItem=modePathView.model[modePathView.currentIndex]
                    var minTemp=modeItem.minTemp
                    var maxTemp=modeItem.maxTemp
                    var tempArray=[]
                    for(var i=minTemp; i<= maxTemp; ++i) {
                        tempArray.push(i+"℃")
                    }
                    tempPathView.model=tempArray

                    if(tempPathViewIndex==null)
                    {
                        tempPathView.currentIndex=modeItem.temp-minTemp
                    }
                    else
                    {
                        tempPathView.currentIndex=tempPathViewIndex-minTemp
                    }

                    var maxTime=modeItem.maxTime
                    if(maxTime!=null && maxTime!=0)
                    {

                    }
                    else
                    {
                        maxTime=300
                    }
                    var timeArray = []
                    for(i=1; i<= 120; ++i) {
                        timeArray.push(i+"分钟")
                    }
                    for(i=125; i<= maxTime; i+=5) {
                        timeArray.push(i+"分钟")
                    }
                    timePathView.model=timeArray
                    if(timePathViewIndex==null)
                    {
                        timePathView.currentIndex=CookFunc.getCookTimeIndex(modeItem.time)
                    }
                    else
                    {
                        timePathView.currentIndex=CookFunc.getCookTimeIndex(timePathViewIndex)
                    }
                    modeItem=null
                }
            }
            DataPathView {
                id:tempPathView
                width: 236
                height:parent.height
                delegateIndex:0
                Image {
                    visible: tempPathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                //                Component.onCompleted:{
                //                    console.log("tempPathView",tempPathView.currentIndex,tempPathViewIndex)
                //                }
            }
            DataPathView {
                id:timePathView
                width: 236
                height:parent.height
                delegateIndex:0
                Image {
                    visible: timePathView.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: "qrc:/x50/steam/temp-time-change-background.png"
                }
                //                Component.onCompleted:{
                //                    console.log("timePathView",timePathView.currentIndex,timePathViewIndex)
                //                }
            }
        }
    }

}
