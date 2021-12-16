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

        reserveData.text=root.dishName
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom: parent.bottom
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
                console.log("PageSteamBakeReserve",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])
                startCooking(root,JSON.parse(root.cookSteps),hourPathView.currentIndex*60+minutePathView.currentIndex)
            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
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
