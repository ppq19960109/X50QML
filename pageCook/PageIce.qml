import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc

import "../"
Item {
    property string name: "PageMultistage"
    property int listClickIndex:0
    readonly property var modeStepsEnum:[[{"iceSteam":0,"mode":120,"temp":5,"time":240}],[{"iceSteam":2,"mode":120,"temp":5,"time":480},{"mode":1,"temp":100,"time":30}],[{"iceSteam":2,"mode":120,"temp":5,"time":480},{"mode":1,"temp":100,"time":20}],[{"mode":1,"temp":100,"time":80},{"iceSteam":1,"mode":120,"temp":10,"time":360}],[{"mode":66,"temp":35,"time":300},{"iceSteam":0,"mode":120,"temp":5,"time":80}],[{"iceSteam":3,"mode":120,"temp":5,"time":180},{"mode":1,"temp":100,"time":60},{"iceSteam":0,"mode":120,"temp":5,"time":240}]]
    property var modeSteps
    Component.onCompleted: {
        console.log("PageIce onCompleted")
        listModel.append(modeStepsEnum[0])
    }
    Component.onDestruction: {
        loaderMainHide()
    }

    function steamStart(reserve)
    {
        var cookSteps = []
        var step
        for(var i = 0; i < listModel.count; ++i)
        {
            step=listModel.get(i)
            var steps={}
            steps.mode=step.mode
            steps.temp=step.temp
            steps.time=step.time
            if(step.iceSteam!=null)
                steps.iceSteamID=step.iceSteam
            steps.number=i+1
            cookSteps.push(steps)
        }

        var cookItem =CookFunc.getDefCookItem()
        cookItem.cookPos=cookWorkPosEnum.RIGHT
        cookItem.dishName=CookFunc.getDishName(cookSteps)
        cookItem.cookSteps=JSON.stringify(cookSteps)

        if(reserve)
        {

        }
        else
        {
            //            if(systemSettings.cookDialog[3] === true)
            //            {
            //                if(CookFunc.isSteam(cookSteps))
            //                    loaderSteamShow("请将食物放入右腔，水箱中加满水","开始",cookItem,3)
            //                else
            //                    loaderSteamShow("当前模式需要预热\n请您在右腔预热完成后再放入食材","开始",cookItem,3)
            //                return
            //            }
            startCooking(cookItem,cookSteps)
        }
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("冰蒸模式(右腔)")
    }

    ListModel {
        id: listModel
    }
    // 定义delegate
    Component {
        id: listDelegate
        Item {
            width: 620
            height: 105
            anchors.left: parent.left
            anchors.leftMargin: 48

            Rectangle {
                width: 34
                height: width
                anchors.left: parent.left
                anchors.verticalCenter: listDelegateBtn.verticalCenter
                color:listClickIndex==index?themesTextColor:"#434343"
                radius: width/2
                Text{
                    anchors.centerIn: parent
                    color:"#fff"
                    font.pixelSize: 22
                    text: index+1
                }
            }
            Button {
                id:listDelegateBtn
                width: 563
                height: 75
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                background:Rectangle {
                    color:themesTextColor2
                    radius: 4
                }
                Text{
                    color:"#000"
                    font.pixelSize: 36
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: mode==iceSteamMode?iceSteamEnum[iceSteam]:qsTr(CookFunc.workModeName(mode))
                }
                Text{
                    color:"#000"
                    font.pixelSize: 36
                    anchors.left: parent.left
                    anchors.leftMargin: 232
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr(temp+"℃")
                }
                Text{
                    color:"#000"
                    font.pixelSize: 36
                    anchors.left: parent.left
                    anchors.leftMargin: 370
                    anchors.verticalCenter: parent.verticalCenter
                    text:Math.floor(time/60)+"时"+Math.floor(time%60)+"分"
                }
                Image {
                    anchors.left: parent.left
                    anchors.leftMargin: 535
                    anchors.verticalCenter: parent.verticalCenter
                    smooth:false
                    source: themesPicturesPath+"/ice/more.png"
                }
                onClicked: {
                    console.log("listDelegate index",index)
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
        Item{
            id:leftContent
            width:247
            height:parent.height

            ListView{
                id:menuList
                model:['生腌酱醉','大菜预约','便捷早餐','冷卤','酸奶发酵','冰镇甜汤']
                width:parent.width
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.bottom: parent.bottom
                orientation:ListView.Vertical
                currentIndex:0
                interactive:false
                delegate:Button {
                    width:parent.width
                    height:54
                    background:null
                    Text{
                        text: modelData
                        font.pixelSize: menuList.currentIndex===index?46:36
                        anchors.centerIn: parent
                        color:menuList.currentIndex===index?themesTextColor:themesTextColor2
                    }
                    onClicked: {
                        console.log("menuList",index)
                        if(menuList.currentIndex!=index)
                        {
                            menuList.currentIndex=index
                            listClickIndex=0
                            listModel.remove(0,listModel.count)
                            listModel.append(modeStepsEnum[index])
                        }
                    }
                }
            }
        }
        Item{
            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            ListView {
                id: listView
                anchors.fill: parent
                interactive: false
                delegate: listDelegate
                model: listModel
            }
            PageLaunchBtn {
                anchors.verticalCenter: listView.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 30
                reserveVisible:false
                onStartUp:{
                    steamStart(false)
                }
                onReserve:{
                }
            }
        }
    }
    Component{
        id:component_tanchuang
        Item {
            property alias mode:tempTimeDelegate.mode
            property alias tempIndex:tempTimeDelegate.tempIndex
            property alias timeIndex:tempTimeDelegate.timeIndex
            signal showListData(int index,var listData)
            MouseArea{
                anchors.fill: parent
            }
            Rectangle {
                width: 930
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

                PageTempTimeDelegate {
                    id:tempTimeDelegate
                    width:180*3+50*2
                    height: parent.height-100
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.left: parent.left
                    anchors.leftMargin: 70
                    tempWidth:180
                    timeWidth:180
                    tempItemCount:3
                    timeItemCount:3
                    modeName:mode==iceSteamMode?iceSteamEnum[listModel.get(listClickIndex).iceSteam]:null
                    mode:listModel.get(listClickIndex).mode
                    tempIndex:listModel.get(listClickIndex).temp
                    timeIndex:listModel.get(listClickIndex).time
                }
                Item {
                    width:80+140*2
                    height: 50
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
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
                            showListData(listClickIndex,tempTimeDelegate.getCurrentState())
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
            console.log("onShowListData",index,listData.temp,listData.time)

            listModel.get(index).temp=listData.temp
            listModel.get(index).time=listData.time
        }
    }
    function loaderMultistageShow(index){
        listClickIndex=index
        loaderMultistage.sourceComponent = component_tanchuang
    }
    function loaderMultistageHide(){
        loaderMultistage.sourceComponent = undefined
    }
}
