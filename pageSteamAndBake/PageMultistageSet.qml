import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {
    property int listClickIndex:0

    function steamStart()
    {
        if(listModel.count==0)
            return
        var list = []
        for(var i = 0; i < listModel.count; ++i)
        {
            var steps={}
            steps.mode=listModel.get(i).mode
            steps.temp=listModel.get(i).temp
            steps.time=listModel.get(i).time
            steps.number=i+1
            list.push(steps)
        }

        var para =getDefHistory()
        para.cookPos=leftDevice
        para.dishName=getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)

        startCooking(para,list,0)
    }


    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
            if("SteamStart"==key)
            {
                steamStart()
            }
        }
    }
    Component.onCompleted: {

        console.log("PageMultistage onCompleted",systemSettings.multistageRemind)
    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("多段烹饪（最多可添加三段烹饪）")
        leftBtnText:qsTr("启动")
        rightBtnText:qsTr("预约")
        onLeftClick:{
            steamStart()
        }
        onRightClick:{
            if(listModel.count==0)
                return
            var list = []
            for(var i = 0; i < listModel.count; ++i)
            {
                var steps={}
                steps.device=0
                steps.mode=listModel.get(i).mode
                steps.temp=listModel.get(i).temp
                steps.time=listModel.get(i).time
                steps.number=i+1
                list.push(steps)
            }
            var para =getDefHistory()
            para.cookPos=leftDevice
            para.dishName=getDishName(list,para.cookPos)
            para.cookSteps=JSON.stringify(list)
            load_page("pageSteamBakeReserve",JSON.stringify(para))
        }
        onClose:{
            permitSteamStartStatus(0)
            backPrePage()
        }
    }

    Component {
        id: footerView
        Item{
            id: footerRootItem
            width: parent.width
            height: 100
            visible:listView.count >= 3?false:true
            // 新增按钮
            Button {
                width: addImg.width
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin:40

                background: Rectangle{
                    color:"transparent"
                    Image {
                        id:addImg
                        anchors.centerIn: parent
                        source: "qrc:/x50/icon/icon_add.png"
                    }
                }
                onClicked:{
                    listClickIndex=listView.count
                    showTanchang()
                }
            }
            PageDivider{
                anchors.horizontalCenter: parent.horizontalCenter
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
            nameText:leftWorkModeFun(mode)+"-"+temp+"℃"+"-"+time+"分钟"
            //            modeIndex:mode
            //            tempIndex:temp+"℃"
            //            timeIndex:time+"分钟"
            closeVisible:true
            onCancel:{
                listView.model.remove(index)
                if(listView.count==0)
                    permitSteamStartStatus(0)
            }
            onConfirm:{
                listClickIndex=index
                showTanchang()
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        height:parent.height-topBar.height
        anchors.bottom:topBar.top
        color:"transparent"

        ListView {
            id: listView
            anchors.fill: parent
            anchors.topMargin: 50
            interactive: true
            delegate: listDelegate
            model: listModel

            footer: footerView
            focus: true
            //            highlightRangeMode: ListView.StrictlyEnforceRange
            //            highlightFollowsCurrentItem: true
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
            modePathViewIndex:listClickIndex >= listView.count?undefined:leftWorkModeNumberFun(listView.model.get(listClickIndex).mode)-1
            tempPathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).temp-leftModel[modePathViewIndex].minTemp
            timePathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).time-1
        }
    }
    function showTanchang(){
        loader_tanchuang.sourceComponent = component_tanchuang

    }
    function dismissTanchang(){
        loader_tanchuang.sourceComponent = null
    }
    Loader{
        //加载弹窗组件
        id:loader_tanchuang
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

                if(listView.count==1)
                    permitSteamStartStatus(1)
            }
        }
    }
    PageMultistageRemind{
        id:remind
        anchors.fill: parent
        visible: systemSettings.multistageRemind
    }
}



