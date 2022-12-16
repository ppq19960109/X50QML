import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc

import "../"
Item {
    property string name: "PageMultistage"
    property int listLastIndex:0
    property int listClickIndex:0

    Component.onCompleted: {
        console.log("PageMultistage onCompleted")
        if(systemSettings.multistageRemind === true)
        {
            loaderManual.sourceComponent=component_remind
        }
    }
    Component.onDestruction: {
        loaderMainHide()
    }

    function steamStart(reserve)
    {
        if(listLastIndex==0)
            return
        var cookSteps = []
        var step
        for(var i = 0; i < listLastIndex; ++i)
        {
            step=listModel.get(i)
            var steps={}
            steps.mode=step.mode
            steps.temp=step.temp
            steps.time=step.time
            if(step.steamGear>0)
                steps.steamGear=step.steamGear
            steps.number=i+1
            cookSteps.push(steps)
        }

        var cookItem =CookFunc.getDefCookItem()
        cookItem.cookPos=cookWorkPosEnum.LEFT
        cookItem.dishName=CookFunc.getDishName(cookSteps)
        cookItem.cookSteps=JSON.stringify(cookSteps)

        if(reserve)
        {
            loaderCookReserve(cookWorkPosEnum.LEFT,cookItem)
        }
        else
        {
            if(systemSettings.cookDialog[3] === true)
            {
                if(CookFunc.isSteam(cookSteps))
                    loaderSteamShow("请将食物放入左腔，水箱中加满水","开始",cookItem,3)
                else
                    loaderSteamShow("当前模式需要预热\n请您在左腔预热完成后再放入食材","开始",cookItem,3)
                return
            }
            startCooking(cookItem,cookSteps)
        }
        cookSteps=undefined
        cookItem=undefined
    }
    Component{
        id:component_remind
        PageDialog{
            hintWidth:850
            hintTopText:"多段烹饪说明"
            hintCenterText:"1、只有左腔具有多段烹饪功能。\n2、完成第一段设置后，可以增加下一段，或是删除该段。\n3、可设置1-3段。"
            hintCenterTextAlign:Text.AlignLeft
            confirmText:"知道了"
            checkboxVisible:true
            onCancel:{
                loaderManual.sourceComponent = undefined
            }
            onConfirm:{
                if(checkboxChecked)
                    systemSettings.multistageRemind=false
                loaderManual.sourceComponent = undefined
            }
        }
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("多段烹饪（只有左腔可多段烹饪）")
    }

    ListModel {
        id: listModel
        ListElement {
            mode: -1
            temp: -1
            time:-1
            steamGear:-1
        }
        ListElement {
            mode: -1
            temp: -1
            time:-1
            steamGear:-1
        }
        ListElement {
            mode: -1
            temp: -1
            time:-1
            steamGear:-1
        }
    }
    // 定义delegate
    Component {
        id: listDelegate
        Item {
            width: 300
            height: 250
            anchors.verticalCenter: parent.verticalCenter
            Button {
                id:listDelegate_btn
                width: parent.height
                height: parent.height
                anchors.right: parent.right

                background:null
                Image{
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: {
                        if(mode<0)
                            return themesPicturesPath+(listLastIndex==index?"icon_round_checkable.png":"icon_round.png")
                        else
                            return themesPicturesPath+"icon_round_checked.png"
                    }
                }
                Image{
                    visible: mode<0
                    asynchronous:true
                    smooth:false
                    anchors.top: parent.top
                    anchors.topMargin: 66
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: themesPicturesPath+(listLastIndex==index?"icon_cook_add_checked.png":"icon_cook_add.png")
                }
                Text{
                    visible: mode<0
                    color:listLastIndex==index?"#DF932F":"#878787"
                    font.pixelSize: 24
                    anchors.top: parent.top
                    anchors.topMargin: 166
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("第"+(index+1)+"段")
                }
                Text{
                    visible: mode>=0
                    color:"#FFA834"
                    font.pixelSize: 30
                    anchors.top: parent.top
                    anchors.topMargin: 75
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr(CookFunc.workModeName(mode))+(steamGear>0?steamGear+"档":"")
                }
                Text{
                    visible: mode>=0
                    color:"#FFA834"
                    font.pixelSize: 24
                    anchors.top: parent.top
                    anchors.topMargin: 130
                    anchors.left: parent.left
                    anchors.leftMargin: 36
                    text: qsTr(temp+"℃")//°C
                }
                Text{
                    visible: mode>=0
                    color:"#FFA834"
                    font.pixelSize: 24
                    anchors.top: parent.top
                    anchors.topMargin: 125
                    anchors.right: parent.right
                    anchors.rightMargin: 36
                    text: qsTr(time+"分钟")
                }
                onClicked: {
                    console.log("listDelegate index",index,listLastIndex)
                    if(listLastIndex != index)
                        return
                    loaderMultistageShow(index)
                }
            }
            Button {
                width: 70
                height: width
                anchors.left: listDelegate_btn.left
                anchors.bottom: listDelegate_btn.bottom
                visible: mode>=0
                background:null
                Image{
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_close.png"
                }
                onClicked: {
                    mode=temp=time=steamGear=-1
                    listModel.move(index,listModel.count-1,1)
                    --listLastIndex
                }
            }
            Button {
                width: 70
                height: width
                anchors.right: listDelegate_btn.right
                anchors.bottom: listDelegate_btn.bottom
                visible: mode>=0
                background:null
                Image{
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_restart.png"
                }
                onClicked: {
                    console.log("listDelegate restart",mode,temp,time,steamGear,index,listLastIndex)
                    loaderMultistageShow(index)
                }
            }
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        PageLaunchBtn {
            anchors.verticalCenter: listView.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            onStartUp:{
                steamStart(false)
            }
            onReserve:{
                steamStart(true)
            }
        }
        ListView {
            id: listView
            anchors.fill: parent
            interactive: false
            orientation:ListView.Horizontal
            delegate: listDelegate
            model: listModel
        }
    }
    Component{
        id:component_tanchuang
        Item {
            signal showListData(int index,var listData)
            function modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
            {
                steamOvenDelegate.modeChange(modeIndex,tempIndex,timeIndex,steamGearIndex)
            }
            MouseArea{
                anchors.fill: parent
            }
            anchors.fill: parent
            Rectangle{
                anchors.fill: parent
                color: "#000"
                opacity: 0.6
            }
            Rectangle {
                width: 1066
                height: 351
                anchors.centerIn: parent
                color: "#333333"
                radius: 4

                Button {
                    width:closeImg.width+50
                    height:closeImg.height+50
                    anchors.top:parent.top
                    anchors.right:parent.right
                    Image {
                        id:closeImg
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+"icon_window_close.png"
                    }
                    background: null
                    onClicked: {
                        loaderMultistageHide()
                    }
                }

                PageSteamOvenDelegate {
                    id:steamOvenDelegate
                    width:291+180*3+20*3
                    height: parent.height-70
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 60
                    modeModel:leftWorkModeModelEnum
                    modeItemCount:3
                    tempItemCount:3
                    timeItemCount:3
                    workPos:cookWorkPosEnum.LEFT
                }
                Item {
                    width:80+140*2
                    height: 50
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        width:140
                        height: 50
                        anchors.left: parent.left
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:qsTr("取消")
                            color:"#000"
                            font.pixelSize: 34
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            loaderMultistageHide()
                        }
                    }
                    Button {
                        width:140
                        height: 50
                        anchors.right: parent.right
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:qsTr("添加")
                            color:"#000"
                            font.pixelSize: 34
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            showListData(listClickIndex,steamOvenDelegate.getCurrentSteamOven())
                            loaderMultistageHide()
                        }
                    }
                }
            }
        }
    }
    Loader{
        //加载弹窗组件
        id:loaderMultistage
        //        asynchronous: true
        anchors.fill: parent
        sourceComponent:undefined
    }
    Connections {
        enabled:loaderMultistage.sourceComponent!=null
        target: loaderMultistage.item
        onShowListData:{
            console.log("onShowListData",index,listData.mode,listData.temp,listData.time,listData.steamGear)

            listModel.get(index).mode=listData.mode
            listModel.get(index).temp=listData.temp
            listModel.get(index).time=listData.time
            listModel.get(index).steamGear=listData.steamGear==null?-1:listData.steamGear
            if(listLastIndex==index)
                ++listLastIndex
        }
    }
    function loaderMultistageShow(index){
        listClickIndex=index
        loaderMultistage.sourceComponent = component_tanchuang
        var model=listModel.get(listClickIndex)
        if(model.mode>=0)
        {
            loaderMultistage.item.modeChange(CookFunc.leftWorkModeToIndex(model.mode),model.temp,model.time,model.steamGear)
        }
    }
    function loaderMultistageHide(){
        loaderMultistage.sourceComponent = undefined
    }
}
