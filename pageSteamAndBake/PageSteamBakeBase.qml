import QtQuick 2.2
import QtQuick.Controls 2.2
import "../"
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
        steps.temp=tempPathView.currentIndex+40
        steps.time=timePathView.currentIndex+1
        list.push(steps)

        para =getDefHistory()
        para.cookPos=root.device
        para.dishName=getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)
        para.cookTime=timePathView.currentIndex+1

        showLoaderSteam1()
        //                startCooking(para,list,0)
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
        var i;
        var tempArray = new Array
        for(i=40; i< 230; ++i) {
            tempArray.push(i+"℃")
        }
        tempPathView.model=tempArray
        var timeArray = new Array
        for(i=1; i< 300; ++i) {
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
        permitSteamStartStatus(1)
    }
    Component{
        id:component_steam1
        PageDialog{
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
                showLoaderSteam2()
            }
        }
    }
    Component{
        id:component_steam2
        PageDialog{
            hintHeight: 306
            hintTopText:"请将食物放入"+(root.device===leftDevice?"左腔":"右腔")
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam2 onCancel")
                closeLoaderMain()
            }
            onConfirm:{
                console.info("component_steam2 onConfirm")
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
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:""
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onClose:{
            permitSteamStartStatus(0)
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
                param.mode=leftWorkModeNumber[modePathView.currentIndex+1]
                param.temp=tempPathView.currentIndex+40
                param.time=timePathView.currentIndex+1
                showListData(param);
                dismissTanchang();
            }
            else
            {
                var list = []
                var steps={}
                steps.mode=leftWorkModeNumber[modePathView.currentIndex+1]
                steps.temp=tempPathView.currentIndex+40
                steps.time=timePathView.currentIndex+1
                list.push(steps)

                var para =getDefHistory()
                para.cookPos=root.device
                para.dishName=getDishName(list,para.cookPos)
                para.cookSteps=JSON.stringify(list)
                para.cookTime=timePathView.currentIndex+1

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
                    console.log("model value:",model.get(index).modelData)
                    tempPathView.currentIndex=model.get(index).temp-40;
                    timePathView.currentIndex=model.get(index).time-1;
                }
                Component.onCompleted:{
                    if(tempPathViewIndex===undefined)
                    {

                    }
                    else
                    {
                        modePathView.currentIndex=modePathViewIndex
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
                    if(tempPathViewIndex===undefined)
                    {
                        //                            tempPathView.positionViewAtIndex(1, PathView.End)
                        tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp-40;
                    }
                    else
                    {
                        tempPathView.currentIndex=tempPathViewIndex
                    }
                }
            }
            DataPathView {
                id:timePathView
                width: parent.width/3
                height:parent.height
                delegateIndex:0
                Component.onCompleted:{
                    if(timePathViewIndex===undefined)
                    {
                        timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time-1;
                        console.log("timePathView",timePathView.currentIndex)
                    }
                    else
                    {
                        timePathView.currentIndex=timePathViewIndex
                    }
                }
            }
        }
    }

}
