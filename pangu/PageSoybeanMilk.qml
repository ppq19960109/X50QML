import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property int listClickIndex:0
    property var cookSteps
    function steamStart()
    {
        if(listModel.count==0)
            return
        var list = []
        var step
        for(var i = 0; i < listModel.count; ++i)
        {
            step=listModel.get(i)
            if(step.mode==4)
            {
                step.mode=3
                if(step.temp>0)
                    step.temp+=4
            }
            else if(step.mode==5)
            {
                step.mode=3
            }
            if(step.repeat>0)
                step.repeat-=1
            list.push(step)
        }

        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=list

        startPanguCooking(para,list)
    }

    Component.onCompleted: {
        if(cookSteps!=null)
        {
            console.log("cookSteps:",cookSteps.length,JSON.stringify(cookSteps))
            for(var i = 0; i < cookSteps.length; ++i)
            {
                listModel.append(cookSteps[i])
            }
        }
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

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("豆浆")
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onLeftClick:{
            steamStart()
        }
        onRightClick:{
            if(listModel.count==0)
                return
            //            var list = []
            //            var step
            //            for(var i = 0; i < listModel.count; ++i)
            //            {
            //                step=listModel.get(i)
            //                var steps={}
            //                //                steps.device=0
            //                steps.mode=step.mode
            //                steps.temp=step.temp
            //                steps.time=step.time
            //                steps.number=i+1
            //                list.push(steps)
            //                step=null
            //            }
            //            var para =CookFunc.getDefHistory()
            //            para.cookPos=cookWorkPosEnum.LEFT
            //            para.dishName=CookFunc.getDishName(list)
            //            para.cookSteps=JSON.stringify(list)
            //            load_page("pageSteamBakeReserve",{"root":para})
            //            para=undefined
        }
        onClose:{
            backPrePage()
        }
    }

    Component {
        id: footerView
        Item{
            width: parent.width
            height: 80
            //visible:listView.count >= 3?false:true
            // 新增按钮
            Button {
                width: 160
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                //                anchors.rightMargin:40

                background: Image {
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesImagesPath+"icon_cook_add.png"
                }
                onClicked:{
                    listClickIndex=listView.count
                    showTanchang()
                }
            }
            PageDivider{
                anchors.bottom: parent.bottom
            }
        }
    }
    ListModel {
        id: listModel
        //        ListElement {
        //            mode: 1
        //            temp: 75
        //            time:30
        //        }
    }
    // 定义delegate
    Component {
        id: listDelegate
        PagePanguMultistageDelegate {
            nameText:CookFunc.panguModeName(mode)+"-"+temp+"℃"+"-火力"+fire+"档"+"-"+cookTime+"秒"
                     +"-"+(motorDir?"反转":"正转")+motorSpeed+"档"+"-"+waterTime+"ml"+"-重复"+repeat+"次"+"-步长"+repeatStep
            closeVisible:true
            onCancel:{
                listView.model.remove(index)
                if(listView.count==0)
                    SendFunc.permitSteamStartStatus(0)
            }
            onConfirm:{
                listClickIndex=index
                showTanchang()
            }
        }
    }
    //内容
    Item{
        width:parent.width
        height:parent.height-topBar.height
        anchors.bottom:topBar.top

        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: 10
            //interactive: false
            delegate: listDelegate
            model: listModel

            footer: footerView
            focus: true
            clip: true
            //            boundsBehavior:Flickable.StopAtBounds
            //            highlightRangeMode: ListView.StrictlyEnforceRange
        }
    }
    Component{
        id:component_tanchuang
        PageModeMultistage {
            name:'第'+ (listClickIndex+1) +'段'
            leftBtnText:""
            rightBtnText:"确定"
            modeIndex:listClickIndex >= listView.count?-1:CookFunc.leftWorkModeToIndex(listModel.get(listClickIndex).mode)-1
            tempIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).temp
            timeIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).cookTime
            fireIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).fire
            waterIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).waterTime
            motorDirIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).motorDir
            motorSpeedIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).motorSpeed
            repeatIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).repeat
            repeatStepIndex:listClickIndex >= listView.count?-1:listModel.get(listClickIndex).repeatStep
        }
    }
    function showTanchang(){
        loader_tanchuang.sourceComponent = component_tanchuang
        SendFunc.permitSteamStartStatus(0)
    }
    function dismissTanchang(){
        loader_tanchuang.sourceComponent = undefined
        if(listView.count>0)
            SendFunc.permitSteamStartStatus(1)
    }
    Loader{
        //加载弹窗组件
        id:loader_tanchuang
        asynchronous: true
        anchors.fill: parent
        Connections {
            target: loader_tanchuang.item
            onShowListData:{
                //                console.log("onShowListData",listData.mode,listData.temp,listData.time,listView.count)

                if(listClickIndex >= listView.count){
                    listModel.append(listData)
                }else{
                    //                    console.log("onShowListData listClickIndex",listClickIndex)
                    listModel.set(listClickIndex,listData)
                    //                    listModel.setProperty(listClickIndex,"temp",listData.temp)
                    //                    listModel.setProperty(listClickIndex,"time",listData.time)
                }
                listData=null
            }
        }
    }
}



