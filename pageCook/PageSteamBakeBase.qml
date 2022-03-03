import QtQuick 2.2
import QtQuick.Controls 2.2
import "../"
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
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
    property var leftWorkBigImg: ["qrc:/x50/steam/icon_便捷蒸.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_高温蒸.png", "qrc:/x50/steam/icon_热风烧烤.png", "qrc:/x50/steam/icon_上下加热.png", "qrc:/x50/steam/icon_立体热风.png", "qrc:/x50/steam/icon_蒸汽烤.png", "qrc:/x50/steam/icon_空气炸.png", "qrc:/x50/steam/icon_保暖烘干.png"]
    property var leftWorkSmallImg: ["", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_高温蒸缩小.png", "qrc:/x50/steam/icon_热风烧烤缩小.png", "qrc:/x50/steam/icon_上下加热缩小.png", "qrc:/x50/steam/icon_立体热风缩小.png", "qrc:/x50/steam/icon_蒸汽烤缩小.png", "qrc:/x50/steam/icon_空气炸缩小.png", "qrc:/x50/steam/icon_保暖烘干缩小.png"]

    function steamStart()
    {
        console.log("PageSteamBakeBase",modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
        var list = []
        var steps={}
        steps.device=root.device
        steps.mode=leftWorkModeNumber[modePathView.currentIndex+1]
        steps.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
        steps.time=parseInt(timePathView.model[timePathView.currentIndex])
        list.push(steps)

        para =CookFunc.getDefHistory()
        para.cookPos=root.device
        para.dishName=CookFunc.getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)
        console.log("para:",JSON.stringify(para))

        if(root.device===leftDevice)
        {
            if(systemSettings.leftCookDialog==true)
            {
                showLoaderSteam1()
                return
            }
        }
        else
        {
            if(systemSettings.rightCookDialog==true)
            {
                showLoaderSteam1()
                return
            }
        }
        startCooking(para,list,0)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                console.log("PageSteamBakeBase onStateChanged",value)
                steamStart()
            }
        }
    }
    Component.onCompleted: {
        console.log("PageSteamBakeBase onCompleted")
        var i;

        var timeArray = new Array
        for(i=1; i< 180; ++i) {
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
        }
        else
        {
            if(multiMode>0)
            {
                for (i=0; i< leftModel.length; ++i) {
                    modeListModel.append(leftModel[i])
                }
            }
        }

    }
    Component{
        id:component_steam1
        PageDialog{
            id:steamDialog1
            hintHeight: 358
            hintTopText:"请将食物放入"+(root.device===leftDevice?"左腔":"右腔")+"\n将水箱加满水"
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam1 onCancel")
                closeLoaderMain()
            }
            onConfirm:{
                console.info("component_steam1 onConfirm")

                if(steamDialog1.checkboxState)
                {
                    if(root.device===leftDevice)
                    {
                        systemSettings.leftCookDialog=false
                    }
                    else
                    {
                        systemSettings.rightCookDialog=false
                    }
                }
                showLoaderSteam2()
            }
        }
    }
    Component{
        id:component_steam2
        PageDialog{
            id:steamDialog2
            hintHeight: 306
            hintTopText:"请将食物放入"+(root.device===leftDevice?"左腔":"右腔")
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam2 onCancel")
                closeLoaderMain()
            }
            onConfirm:{
                console.info("component_steam2 onConfirm",root.device)

                if(steamDialog2.checkboxState)
                {
                    if(root.device===leftDevice)
                    {
                        systemSettings.leftCookDialog=false
                    }
                    else
                    {
                        systemSettings.rightCookDialog=false
                    }
                }
                closeLoaderMain()
                startCooking(para,JSON.parse(para.cookSteps),0)
            }
        }
    }
    function showLoaderSteam1(){
        loader_main.sourceComponent = component_steam1
    }
    function showLoaderSteam2(){
        loader_main.sourceComponent = component_steam2
    }
    Image {
        source: "/x50/main/背景.png"
    }

    //    PageGradient{
    //        anchors.fill: parent
    //        radius:0
    //        border.width:0
    //    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:""
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{

            if(multiMode>0)
            {
                dismissTanchang();
            }
            else
            {
                SendFunc.permitSteamStartStatus(0)
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
                param.mode=leftWorkModeNumber[modePathView.currentIndex+1]
                param.temp=parseInt(tempPathView.model[tempPathView.currentIndex])
                param.time=parseInt(timePathView.model[timePathView.currentIndex])
                showListData(param);
                dismissTanchang();
            }
            else
            {
                var list = []
                var steps={}
                steps.mode=leftWorkModeNumber[modePathView.currentIndex+1]
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
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

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
        Image {
            anchors.centerIn: parent
            source: "qrc:/x50/steam/黑色块.png"
        }
        ListModel {
            id:modeListModel
        }

        Row {
            id:rowPathView
            width: parent.width-80
            height:parent.height-100
            anchors.centerIn: parent
            spacing: 10

            DataPathView {
                id:modePathView
                width: parent.width/3
                height:parent.height
                model:modeListModel
                delegateIndex:1
                currentIndex:0
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
                width: parent.width/3
                height:parent.height
                delegateIndex:0
                Component.onCompleted:{
                    console.log("tempPathView",tempPathView.currentIndex,tempPathViewIndex)

                }
            }
            DataPathView {
                id:timePathView
                width: parent.width/3
                height:parent.height
                delegateIndex:0
                Component.onCompleted:{
                    console.log("timePathView",timePathView.currentIndex,timePathViewIndex)
                }
            }
        }
    }

}
