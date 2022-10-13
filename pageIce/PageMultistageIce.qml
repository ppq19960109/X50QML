import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property int listClickIndex:0
    property int iceCookPos:0
    function steamStart()
    {
        if(listModel.count==0)
            return
        var list = []
        for(var i = 0; i < listModel.count; ++i)
        {
            var steps={}
            steps.pos=listModel.get(i).pos
            steps.mode=listModel.get(i).mode
            steps.temp=listModel.get(i).temp
            steps.time=listModel.get(i).time
            steps.number=i+1
            list.push(steps)
        }

        var para =CookFunc.getDefHistory()
        para.cookPos=iceDevice
        para.dishName=CookFunc.getDishName(list,para.cookPos)
        para.cookSteps=JSON.stringify(list)

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
        console.log("PageMultistage onCompleted")
        SendFunc.permitSteamStartStatus(1)
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("右腔冰蒸")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")//启动
        onLeftClick:{

        }
        onRightClick:{
            steamStart()
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
            visible:listView.count >= 2?false:true
            // 新增按钮
            Button {
                id:right
                width: 140
                height:50
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin:40

                background: Rectangle {
                    color:"transparent"
                    border.color:themesTextColor
                    radius: 16
                }
                Text{
                    anchors.centerIn: parent
                    color:themesTextColor
                    font.pixelSize:30
                    text:"右腔冰蒸"
                }
                onClicked:{
                    listClickIndex=listView.count
                    showTanchang(rightDevice)
                }
            }
            Button {
                id:left
                width: 140
                height:50
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: right.left
                anchors.rightMargin:40

                background: Rectangle {
                    color:"transparent"
                    border.color:themesTextColor
                    radius: 16
                }
                Text{
                    anchors.centerIn: parent
                    color:themesTextColor
                    font.pixelSize:30
                    text:"左腔蒸烤"
                }
                onClicked:{
                    listClickIndex=listView.count
                    showTanchang(leftDevice)
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
        PageMultistageIceDelegate {
            id:iceDelegate
            nameText:(cookPos==0?"左腔":"右腔")+" "+CookFunc.leftWorkModeName(mode)+"  "+temp+"℃"+"  "+time+"分钟"
            cookPos:pos
            closeVisible:false
            onCancel:{
                listView.model.remove(index)
                if(listView.count==0)
                    SendFunc.permitSteamStartStatus(0)
            }
            onConfirm:{
                console.log("onConfirm",index,cookPos)
                listClickIndex=index
                showTanchang(cookPos)
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
            interactive: true
            delegate: listDelegate
            model: listModel

            //            footer: footerView
            focus: true
            //            highlightRangeMode: ListView.StrictlyEnforceRange
            //            highlightFollowsCurrentItem: true
            //            snapMode: ListView.SnapToItem
        }
    }
    Component{
        id:component_tanchuang
        PageIceSteam {
            cookPos:iceCookPos
            modePathViewEnabled:cookPos==0
            name:'第'+ (listClickIndex+1) +'段'
            leftBtnText:""
            rightBtnText:"确定"
            modePathViewIndex:listClickIndex >= listView.count?undefined:CookFunc.leftWorkModeToIndex(listView.model.get(listClickIndex).mode)-1
            tempPathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).temp
            timePathViewIndex:listClickIndex >= listView.count?undefined:listView.model.get(listClickIndex).time
        }
    }
    function showTanchang(cookPos){
        console.log("showTanchang",cookPos)
        iceCookPos=cookPos
        loader_tanchuang.sourceComponent = component_tanchuang
    }
    function dismissTanchang(){
        loader_tanchuang.sourceComponent = undefined
    }
    Loader{
        //加载弹窗组件
        id:loader_tanchuang
        asynchronous: true
        anchors.fill: parent
        Connections {
            target: loader_tanchuang.item
            onShowListData:{
                console.log("onShowListData",listClickIndex,listData.pos,listData.mode,listData.temp,listData.time,listView.count)

                if(listClickIndex >= listView.count){
                    listView.model.append(listData)
                }else{
                    listView.model.get(listClickIndex).pos=listData.pos
                    listView.model.get(listClickIndex).mode=listData.mode;
                    listView.model.get(listClickIndex).temp=listData.temp;
                    listView.model.get(listClickIndex).time=listData.time;
                }

                if(listView.count==1)
                    SendFunc.permitSteamStartStatus(1)
            }
        }
    }

    Item {
        id:remind
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: topBar.top

        Grid
        {
            anchors.fill: parent
            rows: 2
            columns: 3
            Repeater
            {
                model: ListModel{
                    ListElement{name: "便捷早餐"
                        value:4
                        cookSteps:"[{\"pos\":1,\"mode\":120,\"temp\":5,\"time\":480,\"number\":1},{\"pos\":1,\"mode\":100,\"temp\":100,\"time\":20,\"number\":2}]"}
                    ListElement{name: "大菜预约"
                        value:4
                        cookSteps:"[{\"pos\":1,\"mode\":120,\"temp\":5,\"time\":480,\"number\":1},{\"pos\":1,\"mode\":100,\"temp\":100,\"time\":30,\"number\":2}]"}
                    ListElement{name: "冷卤"
                        value:3
                        cookSteps:"[{\"pos\":1,\"mode\":100,\"temp\":100,\"time\":80,\"number\":1},{\"pos\":1,\"mode\":131,\"temp\":10,\"time\":360,\"number\":2}]"}
                    ListElement{name: "冰鲜酸奶"
                        value:3
                        cookSteps:"[{\"pos\":0,\"mode\":134,\"temp\":35,\"time\":480,\"number\":1},{\"pos\":1,\"mode\":132,\"temp\":5,\"time\":180,\"number\":2}]"}
                    ListElement{name: "生腌酱醉"
                        value:1
                        cookSteps:"[{\"pos\":1,\"mode\":132,\"temp\":5,\"time\":240,\"number\":1}]"}
                }
                Button{
                    width:parent.width/3
                    height: parent.height/2
                    background:Image{
                        asynchronous:true
                        smooth:false
                        anchors.fill: parent
                        source:themesImagesPath+"statusset-button2-background.png"
                    }
                    Text {
                        width: parent.width
                        color:"#FFF"
                        text: qsTr(name)
                        anchors.centerIn: parent
                        font.pixelSize: 40
                        font.bold: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                    }
                    onClicked: {
                        remind.visible=false
                        topBar.rightBtnText="启动"

                        var steps=JSON.parse(cookSteps)
                        for(var i = 0; i < steps.length; i++)
                            listView.model.append(steps[i])
                    }
                }
            }
        }
    }
}



