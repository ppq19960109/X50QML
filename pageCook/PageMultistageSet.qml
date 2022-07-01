import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property int listClickIndex:0

    function steamStart()
    {
        if(listModel.count==0)
            return
        var list = []
        var step
        for(var i = 0; i < listModel.count; ++i)
        {
            step=listModel.get(i)
            var steps={}
            steps.mode=step.mode
            steps.temp=step.temp
            steps.time=step.time
            steps.number=i+1
            list.push(steps)
        }

        var para =CookFunc.getDefHistory()
        para.cookPos=cookWorkPosEnum.LEFT
        para.dishName=CookFunc.getDishName(list)
        para.cookSteps=JSON.stringify(list)

        if(systemSettings.cookDialog[4]>0)
        {
            if(CookFunc.isSteam(list))
                loaderSteamShow(360,"请将食物放入左腔\n将水箱加满水","开始烹饪",para,4)
            else
                loaderSteamShow(292,"请将食物放入左腔","开始烹饪",para,4)
            return
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
        }
    }
    StackView.onActivated:{
        connections.enabled=true
    }
    StackView.onDeactivated:{
        connections.enabled=false
    }
    Component.onCompleted: {
        console.log("PageMultistage onCompleted",systemSettings.multistageRemind)
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("多段烹饪 <font size='30px'>(最多可添加三段烹饪)</font>")
        //                leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onLeftClick:{
            steamStart()
        }
        onRightClick:{
            if(listModel.count==0)
                return
            var list = []
            var step
            for(var i = 0; i < listModel.count; ++i)
            {
                step=listModel.get(i)
                var steps={}
                //                steps.device=0
                steps.mode=step.mode
                steps.temp=step.temp
                steps.time=step.time
                steps.number=i+1
                list.push(steps)
            }
            var para =CookFunc.getDefHistory()
            para.cookPos=cookWorkPosEnum.LEFT
            para.dishName=CookFunc.getDishName(list)
            para.cookSteps=JSON.stringify(list)
            load_page("pageSteamBakeReserve",JSON.stringify(para))
            para=undefined
        }
        onClose:{
            backPrePage()
        }
    }

    Component {
        id: footerView
        Item{
            width: parent.width
            height: 100
            visible:listView.count >= 3?false:true
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
        PageMultistageDelegate {
            nameText:CookFunc.leftWorkModeName(mode)+"-"+temp+"℃"+"-"+time+"分钟"

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
            anchors.topMargin: 50
            interactive: false
            delegate: listDelegate
            model: listModel

            footer: footerView
            focus: true
//            boundsBehavior:Flickable.StopAtBounds
            //            highlightRangeMode: ListView.StrictlyEnforceRange
//            snapMode: ListView.SnapToItem
        }
    }
    Component{
        id:component_tanchuang
        PageSteamBakeBase {
            multiMode:1
            name:'第'+ (listClickIndex+1) +'段'
            leftBtnText:""
            rightBtnText:"确定"
            modePathViewIndex:listClickIndex >= listView.count?undefined:CookFunc.leftWorkModeToIndex(listView.model.get(listClickIndex).mode)-1
            tempPathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).temp
            timePathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).time
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
                console.log("onShowListData",listData.mode,listData.temp,listData.time,listView.count)

                if(listClickIndex >= listView.count){
                    listView.model.append(listData)
                }else{
                    console.log("onShowListData listClickIndex",listClickIndex)

                    listView.model.get(listClickIndex).mode=listData.mode;
                    listView.model.get(listClickIndex).temp=listData.temp;
                    listView.model.get(listClickIndex).time=listData.time;
                }
            }
        }
    }
    PageMultistageRemind{
        id:remind
        anchors.fill: parent
        visible: systemSettings.multistageRemind
    }
}



