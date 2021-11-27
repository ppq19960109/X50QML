import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    signal showListData(var listData)
    property alias title: name.text
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

        for (i=0; i< leftModel.length; ++i) {
            modeListModel.append(leftModel[i])
        }
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
                dismissTanchang()
            }
        }

        Text{
            id:name
            width:80
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
        }

        //确定
        TabButton{
            id:reserve
            width:160
            height:parent.height
            anchors.right:parent.right
            anchors.rightMargin: 10
            background:Rectangle{
                color:"transparent"
            }
            Text{
                color:"#ECF4FC"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:qsTr("确定")
            }
            onClicked: {

                var param = {};
                param.mode=modePathView.currentIndex+1
                param.temp=tempPathView.currentIndex+40
                param.time=timePathView.currentIndex+1
                console.log('listParam'+param);
                showListData(param);
                dismissTanchang();
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
                id:modePathView
                width: parent.width/3
                height:parent.height
                model:modeListModel
                currentIndex:0
                onValueChanged: {
                    console.log(index,valueName)
                    console.log("model value:",model.get(index).modelData);
                    tempPathView.currentIndex=model.get(index).temp-40;
                    timePathView.currentIndex=model.get(index).time-1;
                }
            }
            DataPathView {
                id:tempPathView
                width: parent.width/3
                height:parent.height
                Component.onCompleted:{
                    //                            tempPathView.positionViewAtIndex(1, PathView.End)
                    tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp-40;
                    console.log("tempPathView",tempPathView.currentIndex)
                }
            }
            DataPathView {
                id:timePathView
                width: parent.width/3
                height:parent.height
                Component.onCompleted:{
                    timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time-1;
                    console.log("timePathView",tempPathView.currentIndex)
                }
            }
        }

    }
}
