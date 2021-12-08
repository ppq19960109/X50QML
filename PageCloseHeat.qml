import QtQuick 2.0
import QtQuick.Controls 2.2
import "pageSteamAndBake"
Item {
    property var root
    Component.onCompleted: {
        var i
        var hourArray = new Array
        for(i=0; i< 3; ++i) {
            hourArray.push(i+"小时")
        }
        hourPathView.model=hourArray
        var minuteArray = new Array
        for( i=0; i< 60; ++i) {
            minuteArray.push(i+"分钟")
        }
        minutePathView.model=minuteArray

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
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("定时关火")
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
                console.log("startBtn",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])

                QmlDevState.setState("RStoveTimingState",1)
                QmlDevState.setState("RStoveTimingLeft",hourPathView.currentIndex*60+minutePathView.currentIndex)
                backPrePage()
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
            anchors.top:parent.top
            anchors.bottom: prompt.top
            spacing: 10

            DataPathView {
                id:hourPathView
                width: parent.width/3
                height:parent.height

                currentIndex:0
                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===1)
                        currentIndex=Math.floor(QmlDevState.state.RStoveTimingLeft/60)
                }
            }
            DataPathView {
                id:minutePathView
                width: parent.width/3
                height:parent.height

                Component.onCompleted:{
                    if(QmlDevState.state.RStoveTimingState===1)
                        currentIndex=QmlDevState.state.RStoveTimingLeft%60
                }
            }
            Text{
                width:120
                color:"white"
                font.pixelSize: 40
                anchors.verticalCenter: parent.verticalCenter
                text:qsTr("后定时关火")
            }
        }
        Text{
            id:prompt
            //            width:120
            anchors.bottom:parent.bottom
            color:"white"
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            text:qsTr("右灶开启后才可定时关火")
        }
    }
}
