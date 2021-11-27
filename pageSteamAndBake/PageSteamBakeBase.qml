import QtQuick 2.2
import QtQuick.Controls 2.2
import "../"
Item {
    property var root

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
        console.log("state",state,typeof state)
        root=JSON.parse(state);
        if(0===root.device)
        {
            name.text="左腔蒸烤"
            for (i=0; i< leftModel.length; ++i) {
                modeListModel.append(leftModel[i])
            }
        }
        else
        {
            name.text="右腔速蒸"
            modeListModel.append(rightModel)
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
                backPrePage();
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

        //启动
        TabButton{
            id:startBtn
            width:160
            height:parent.height
            anchors.right:reserve.left
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
                console.log(modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])

                backPrePage()

                if(0===root.device)
                {
                    QmlDevState.setState("StOvState",3)
                    QmlDevState.setState("StOvMode",modePathView.currentIndex+1)

                    QmlDevState.setState("StOvSetTemp",tempPathView.currentIndex+40)
                    QmlDevState.setState("StOvSetTimer",timePathView.currentIndex+1)

                }
                else
                {
                    QmlDevState.setState("RStOvState",2)

                    QmlDevState.setState("RStOvSetTemp",tempPathView.currentIndex+40)
                    QmlDevState.setState("RStOvSetTimer",timePathView.currentIndex+1)
                }
                var list = [];
                var steps={}
                steps.device=root.device
                steps.mode=modePathView.currentIndex+1
                steps.temp=tempPathView.currentIndex+40
                steps.time=timePathView.currentIndex+1
                list.push(steps)

                var para =getDefHistory()
                para.dishName=getDishName(list)
                para.cookSteps=JSON.stringify(list)

                QmlDevState.addSingleHistory(para)
            }
        }
        //预约
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
                text:qsTr("预约")
            }
            onClicked: {
                var list = [];
                var param = {};
                    param.device=root.device
                param.mode=modePathView.currentIndex+1
                param.temp=tempPathView.currentIndex+40
                param.time=timePathView.currentIndex+1
                list.push(param)
                load_page("pageSteamBakeReserve",JSON.stringify(list))
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
