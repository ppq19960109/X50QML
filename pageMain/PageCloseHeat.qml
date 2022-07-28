import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Component.onCompleted: {

    }
    Component{
        id:component_heat
        Item {
            property int cookWorkPos:0

            Component.onCompleted: {
                var i
                var hourArray = []
                for(i=0; i<= 2; ++i) {
                    hourArray.push(i)
                }
                hourPathView.model=hourArray
                var minuteArray = []
                for(i=0; i<= 60; ++i) {
                    minuteArray.push(i)
                }
                minutePathView.model=minuteArray
            }

            //内容
            Rectangle{
                width:730
                height: 350
                anchors.centerIn: parent
                color: "#333333"
                radius: 10

                Button {
                    width:closeImg.width+50
                    height:closeImg.height+50
                    anchors.top:parent.top
                    anchors.right:parent.right
                    Image {
                        id:closeImg
                        asynchronous:true
                        smooth:false
                        cache:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+"icon_window_close.png"
                    }
                    background: null
                    onClicked: {
                        loaderMainHide()
                    }
                }

                PageDivider{
                    anchors.verticalCenter:row.verticalCenter
                    anchors.verticalCenterOffset:-30
                }
                PageDivider{
                    anchors.verticalCenter:row.verticalCenter
                    anchors.verticalCenterOffset:30
                }

                Row {
                    id:row
                    width: parent.width
                    height:222
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.left:parent.left
                    anchors.leftMargin: 30
                    spacing: 10

                    Text{
                        width:130
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text:qsTr(cookWorkPos==0?"左灶将在 ":"右灶将在")
                    }
                    PageCookPathView {
                        id:hourPathView
                        width: 200
                        height:parent.height
                        pathItemCount:3
                        currentIndex:0
                        Image {
                            anchors.fill: parent
                            visible: hourPathView.moving
                            asynchronous:true
                            smooth:false
                            anchors.centerIn: parent
                            source: themesPicturesPath+"steamoven/"+"roll_background.png"
                        }
                        Text{
                            text:qsTr("小时")
                            color:themesTextColor
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 60
                        }
                    }
                    PageCookPathView {
                        id:minutePathView
                        width: 200
                        height:parent.height
                        pathItemCount:3
                        Image {
                            anchors.fill: parent
                            visible: minutePathView.moving
                            asynchronous:true
                            smooth:false
                            anchors.centerIn: parent
                            source: themesPicturesPath+"steamoven/"+"roll_background.png"
                        }
                        Text{
                            text:qsTr("分钟")
                            color:themesTextColor
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 60
                        }
                    }
                    Text{
                        width:100
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                        text:qsTr("后关火")
                    }
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
                            loaderMainHide()
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
                            text:qsTr("开始")
                            color:"#000"
                            font.pixelSize: 34
                            anchors.centerIn: parent
                        }
                        onClicked: {

                            loaderMainHide()
                        }
                    }
                }
            }
        }
    }
    function steamStart()
    {
        if(QmlDevState.state.RStoveStatus===1)
        {
            if(hourPathView.currentIndex==0 && minutePathView.currentIndex==0)
                return
            console.log("PageCloseHeat",hourPathView.model[hourPathView.currentIndex],minutePathView.model[minutePathView.currentIndex])

            var Data={}
            Data.RStoveTimingOpera = timingOperationEnum.START
            Data.RStoveTimingSet = hourPathView.currentIndex*60+minutePathView.currentIndex
            Data.DataReportReason=0
            SendFunc.setToServer(Data)

            //                            QmlDevState.setState("RStoveTimingLeft",hourPathView.currentIndex*60+minutePathView.currentIndex)
            //                            QmlDevState.setState("RStoveTimingState",timingStateEnum.RUN)
            backPrePage()
        }
        else
        {
            loaderPopupShow("","右灶未开启\n开启后才可定时关火",292)
        }
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:"定时关火"
    }

    Row {
        width: 309*2+124
        height: 309
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 124

        Repeater {
            model: ["左灶","右灶"]
            Button{
                width: 309
                height: width

                background:Image {
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"icon_close_heat.png"
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return false
                        }
                        else
                        {
                            return true
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:modelData
                        color:"#fff"
                        font.pixelSize: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 105
                    }
                    Text{
                        text:"定时关火"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 157
                    }
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:modelData+"将在"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 90
                    }
                    Text{
                        text:"10:11"
                        color:themesTextColor
                        font.pixelSize: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 135
                    }
                    Text{
                        text:"后关火"
                        color:"#fff"
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 188
                    }
                }
                onClicked: {
                    if(index==0)
                    {

                    }
                    else
                    {

                    }
                }
            }
        }
    }

}
