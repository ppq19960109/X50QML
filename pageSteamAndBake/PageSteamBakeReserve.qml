import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {
    property var root
    Component.onCompleted: {
        var i
        var hourArray = new Array
        for(i=0; i< 12; ++i) {
            hourArray.push(i+"小时")
        }
        hourPathView.model=hourArray
        var minuteArray = new Array
        for( i=0; i< 60; ++i) {
            minuteArray.push(i+"分钟")
        }
        minutePathView.model=minuteArray

        console.log("state",state,typeof state)
        root=JSON.parse(state)

        reserveData.text=getDishName(root)
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backTopPage()
            }
        }

        Text{
            id:pageName
            width:100
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("预约")
        }

        Text{
            id:reserveData
            width:200
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:pageName.right
            anchors.verticalCenter: parent.verticalCenter

        }

        //启动
        TabButton{
            id:startBtn
            width:160
            height:parent.height
            anchors.right:parent.right
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("启动")
            }
            onClicked: {
                console.log("启动",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])
                var page=isExistView("pageSteamBakeRun")
                if(page!==null)
                    backPage(page)
                else
                    backTopPage()
                if(root.length===1)
                {
                    if(leftDevice===root[0].device)
                    {
                        QmlDevState.setState("LStOvState",1)
                        QmlDevState.setState("LStOvMode",root[0].mode)
                        QmlDevState.setState("LStOvRealTemp",root[0].temp)
                        QmlDevState.setState("LStOvOrderTimerLeft",root[0].time)
                    }
                    else
                    {
                        QmlDevState.setState("RStOvState",1)
                        QmlDevState.setState("RStOvRealTemp",root[0].temp)
                        QmlDevState.setState("RStOvOrderTimerLeft",root[0].time)
                    }
                    root[0].orderTime=hourPathView.currentIndex*60+minutePathView.currentIndex
                    setCooking(root)
                }
                else
                {
                    QmlDevState.setState("LStOvState",1)
                    QmlDevState.setState("LStOvMode",root[0].mode)
                    QmlDevState.setState("LStOvRealTemp",root[0].temp)
                    QmlDevState.setState("LStOvOrderTimerLeft",root[0].time)
                    root[0].orderTime=hourPathView.currentIndex*60+minutePathView.currentIndex
                    setMultiCooking(root)
                }

                var para =getDefHistory()
                para.dishName=getDishName(root)
                para.cookSteps=JSON.stringify(root)

                QmlDevState.insertHistory(para)
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Image{
            width:parent.width
            source: "/images/fengexian.png"
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3

        }
        Image{
            width:parent.width
            source: "/images/fengexian.png"
            anchors.top:parent.top
            anchors.topMargin:rowPathView.height/3*2
        }
        ListModel {
            id:modeListModel
        }
        Row {
            id:rowPathView
            width: parent.width
            height:parent.height
            spacing: 10

            DataPathView {
                id:hourPathView
                width: parent.width/3
                height:parent.height

                currentIndex:0
                onValueChanged: {

                }
            }
            DataPathView {
                id:minutePathView
                width: parent.width/3
                height:parent.height

                Component.onCompleted:{

                }
            }
            Text{
                width:120
                color:"white"
                font.pixelSize: 40
                anchors.verticalCenter: parent.verticalCenter
                text:qsTr("后启动")
            }
        }
    }
}
