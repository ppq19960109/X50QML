import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property bool startButtonState: false

    Component.onCompleted: {
        var i;
        var tempArray = new Array
        for(i=40; i< 230; ++i) {
            tempArray.push(i+"℃");
        }
        tempPathView.model=tempArray
        var timeArray = new Array
        for(i=1; i< 300; ++i) {
            timeArray.push(i+"分钟");
        }
        timePathView.model=timeArray
        console.log("mode",color)
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
                backPrePage();
            }
        }

        Text{
            id:name
            width:50
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("蒸箱")
        }
        //预约
        TabButton{
            width:160
            height:parent.height
            anchors.right:startBtn.left
            anchors.rightMargin: 10
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("预约")
            }
            onClicked: {

            }
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
                text:startButtonState?qsTr("停止"):qsTr("启动")
            }
            onClicked: {
                startButtonState=!startButtonState
                console.log(modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
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
            ListElement {modelData:"经典蒸";temp:100;time:40;}
            ListElement {modelData:"快速蒸";temp:110;time:30;}
            ListElement {modelData:"热风烧烤";temp:120;time:20}
            ListElement {modelData:"上下加热";temp:130;time:10}
        }

        Row {
            id:rowPathView
            width: parent.width
            height:parent.height
            spacing: 10

            DataPathView {
                id:modePathView
                width: parent.width/3
                height:parent.height
                model:modeListModel
                currentIndex:0
                onValueChanged: {
                    console.log(index,valueName)
                    console.log("model value:",model.get(index).modelData);
                    tempPathView.currentIndex=model.get(index).temp;
                    timePathView.currentIndex=model.get(index).time;

                }
            }
            DataPathView {
                id:tempPathView
                width: parent.width/3
                height:parent.height
                Component.onCompleted:{
                    //                            tempPathView.positionViewAtIndex(1, PathView.End)
                    tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp;
                }
            }
            DataPathView {
                id:timePathView
                width: parent.width/3
                height:parent.height
                Component.onCompleted:{
                    timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time;
                }
            }
        }


    }
}
