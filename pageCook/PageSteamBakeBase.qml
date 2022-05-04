import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Rectangle {
    color:themesWindowBackgroundColor
    property int multiMode:0
    property alias name: topBar.name
    property alias leftBtnText: topBar.leftBtnText
    property alias rightBtnText: topBar.rightBtnText
    property var modePathViewIndex
    property var tempPathViewIndex
    property var timePathViewIndex
    signal showListData(var listData)

    property var root
    property var para

    readonly property var leftWorkBigImg: ["qrc:/x50/steam/icon_便捷蒸.png", "qrc:/x50/steam/icon_经典蒸.png", "qrc:/x50/steam/icon_高温蒸.png", "qrc:/x50/steam/icon_热风烧烤.png", "qrc:/x50/steam/icon_上下加热.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_蒸汽烤.png", "qrc:/x50/steam/icon_空气炸.png", "qrc:/x50/steam/icon_保暖烘干.png"]
    readonly property var leftWorkSmallImg: ["", "qrc:/x50/steam/icon_经典蒸缩小.png", "qrc:/x50/steam/icon_高温蒸缩小.png", "qrc:/x50/steam/icon_热风烧烤缩小.png", "qrc:/x50/steam/icon_上下加热缩小.png", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_蒸汽烤缩小.png", "qrc:/x50/steam/icon_空气炸缩小.png", "qrc:/x50/steam/icon_保暖烘干缩小.png"]

    function steamStart()
    {
        console.log("PageSteamBakeBase",modePathView.currentIndex,modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var list = []
        var steps={}
        steps.device=root.device
        if(root.device==leftDevice)
            steps.mode=leftWorkModeNumber[modePathView.model.get(modePathView.currentIndex).modelData]
        else
            steps.mode= 100

        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.time=parseInt(timePathView.model[timePathView.currentIndex])
        list.push(steps)

        para =CookFunc.getDefHistory()
        para.cookPos=root.device
        para.dishName=CookFunc.getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)
        console.log("para:",JSON.stringify(para),systemSettings.leftCookDialog,systemSettings.rightCookDialog,root.device)

        if(para.cookPos===leftDevice)
        {
            if(systemSettings.cookDialog[0]>0)
            {
                if(CookFunc.isSteam(list))
                    showLoaderSteam1(358,"请将食物放入左腔\n将水箱加满水","开始烹饪",para,0)
                else
                    showLoaderSteam1(306,"请将食物放入左腔","开始烹饪",para,0)
                return
            }
        }
        else
        {
            if(systemSettings.cookDialog[1]>0)
            {
                showLoaderSteam1(358,"请将食物放入右腔\n将水箱加满水","开始烹饪",para,1)
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
            console.log("PageSteamBakeBase onStateChanged",key)
            if("SteamStart"==key)
            {
                console.log("PageSteamBakeBase onStateChanged",value)
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
        console.log("PageSteamBakeBase onCompleted")
        var i;

        var timeArray = new Array
        for(i=1; i<= 120; ++i) {
            timeArray.push(i+"分钟")
        }
        for(i=125; i<= 180; i+=5) {
            timeArray.push(i+"分钟")
        }
        timePathView.model=timeArray
        console.log("state",state,typeof state)
        if(multiMode==0 )//|| undefined != state || null != state || "" != state
        {
            root=JSON.parse(state)
            if(leftDevice===root.device)
            {
                topBar.name="左腔蒸烤"
                for (i=0; i< leftModel.length; ++i) {
                    modeListModel.append(leftModel[i])
                }
            }
            else
            {
                topBar.name="右腔速蒸"
                modeListModel.append(rightModel)
            }
            SendFunc.permitSteamStartStatus(1)
            if(root.reserve!=null)
                topBar.rightBtnText=""
        }
        else
        {
            for (i=0; i< leftModel.length; ++i) {
                modeListModel.append(leftModel[i])
            }
        }

    }

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
                param.mode=leftWorkModeNumber[modePathView.model.get(modePathView.currentIndex).modelData]
                param.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
                param.time=parseInt(timePathView.model[timePathView.currentIndex])
                showListData(param);
                dismissTanchang();
            }
            else
            {
                var list = []
                var steps={}
                if(root.device==leftDevice)
                    steps.mode=leftWorkModeNumber[modePathView.model.get(modePathView.currentIndex).modelData]
                else
                    steps.mode= 100
                steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
                steps.time=parseInt(timePathView.model[timePathView.currentIndex])
                list.push(steps)

                var para =CookFunc.getDefHistory()
                para.cookPos=root.device
                para.dishName=CookFunc.getDishName(list,para.cookPos)
                para.cookSteps=JSON.stringify(list)

                load_page("pageSteamBakeReserve",JSON.stringify(para))
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

        ListModel {
            id:modeListModel
        }

        Row {
            id:rowPathView
            width: parent.width-60
            height:parent.height-60
            anchors.centerIn: parent
            spacing: 0

            DataPathView {
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
            DataPathView {
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
            DataPathView {
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
