import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {
    property var root
    Component.onCompleted: {
        var hourArray = new Array
        for(let i=0; i< 12; ++i) {
            hourArray.push(i+"小时");
        }
        hourPathView.model=hourArray
        var minuteArray = new Array
        for(let i=0; i< 60; ++i) {
            minuteArray.push(i+"分钟");
        }
        minutePathView.model=minuteArray

        console.log("state",state,typeof state)
        root=JSON.parse(state);
        console.log("root",root.length)

        for(let i = 0; i < root.length; i++){
            console.log(root[i].mode,root[i].temp,root[i].time)
            if(i==0)
            {
                console.log("dishName",root[i].dishName)
                if(root[i].dishName!=null)
                {
                    reserveData.text=root[i].dishName
                }
                else
                {
                    if(root.length===1)
                    {
                        if(0===root[i].device)
                            reserveData.text=leftWorkModeArr[root[i].mode]+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
                        else
                            reserveData.text=rightWorkMode+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
                    }
                }
            }
            else
            {
                reserveData.text+=leftWorkModeArr[root[i].mode]
                if(i!==root.length-1)
                    reserveData.text+="-"
            }
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
            text:qsTr("预约")
        }

        Text{
            id:reserveData
            width:200
            //            height:parent.height
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
                console.log("startBtn",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])
                for(let i = 0; i < root.length; i++){
                    console.log(root[i].mode,root[i].temp,root[i].time)
                    if(root.length===1)
                    {
                        if(0===root[i].device)
                        {
                            QmlDevState.setState("StOvState",1)
                            QmlDevState.setState("StOvMode",root[i].mode)
                            QmlDevState.setState("StOvSetTemp",root[i].temp)
                            QmlDevState.setState("StOvSetTimer",root[i].time)
                        }
                        else
                        {
                            QmlDevState.setState("RightStOvState",1)
                            QmlDevState.setState("RightStOvSetTemp",root[i].temp)
                            QmlDevState.setState("RightStOvSetTimer",root[i].time)
                        }
                    }
                    else
                    {

                    }
                }

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
