import QtQuick 2.12
import QtQuick.Controls 2.5
import "pageCook"
Item {
    property bool runing: timer_alarm.running
    Component.onCompleted: {
        if(gTimerLeft==0)
        {
            var i
            var array = []
            for(i=0; i<= 12; ++i) {
                array.push(i)
            }
            hourPathView.model=array
            array = []
            for(i=0; i< 60; ++i) {
                array.push(i)
            }
            minutePathView.model=array

            secondsPathView.model=array
        }
    }
    MouseArea{
        anchors.fill: parent
    }
    //内容
    Rectangle{
        visible: gTimerLeft==0
        width:510
        height: 350
        anchors.centerIn: parent
        color: "#333333"
        radius: 10

        PageCloseButton {
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                loaderMainHide()
            }
        }
        Text{
            color:"#fff"
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            text:qsTr("计时器")
        }
        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:-20
        }
        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:20
        }

        Row {
            id:row
            width: parent.width
            height:210
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.left:parent.left
            anchors.leftMargin: 30
            spacing: 10

            PageCookPathView {
                id:hourPathView
                width: 140
                height:parent.height
                currentIndex:0
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("时")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 60
                }
            }
            PageCookPathView {
                id:minutePathView
                width: 140
                height:parent.height
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("分")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 60
                }
            }
            PageCookPathView {
                id:secondsPathView
                width: 140
                height:parent.height
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("秒")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 60
                }
            }
        }
        Item {
            width:105+140*2
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
                    text:qsTr("确认")
                    color:"#000"
                    font.pixelSize: 34
                    anchors.centerIn: parent
                }
                onClicked: {
                    gTimerLeft=gTimerTotalTime=hourPathView.currentIndex*3600+minutePathView.currentIndex*60+secondsPathView.currentIndex
                    timer_alarm.restart()
                }
            }
        }
    }
    Rectangle{
        anchors.fill: parent
        visible: gTimerLeft>0
        color: themesWindowBackgroundColor
        PageBackBar{
            id:topBar
            anchors.top:parent.top
            name:"计时器"
            customClose:true
            onClose:{
                loaderMainHide()
            }
        }

        Item
        {
            id:timeLeft
            width: 290
            height: 290
            anchors.top: topBar.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"icon_steam_runing_background.png"
            }
            Text{
                text:"倒计时"
                color:themesTextColor
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 80
            }
            Text{
                text:gTimerLeftText
                color:themesTextColor
                font.pixelSize: 40
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 130
            }
            PageCirBar{
                width: 290
                height: width
                anchors.centerIn: parent
                runing: gTimerLeft>0
                canvasDiameter:width
                outerRing:false
                percent:{
                    return 100-Math.floor(100*gTimerLeft/gTimerTotalTime)
                }
            }
        }
        Button {
            width:140
            height: 50
            anchors.right: timeLeft.left
            anchors.rightMargin: 25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45
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
                timer_alarm.stop()
                gTimerLeft=0
                loaderMainHide()
            }
        }
        Button {
            width:140
            height: 50
            anchors.left: timeLeft.right
            anchors.leftMargin: 25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45
            background: Rectangle{
                color:themesTextColor2
                radius: 25
            }
            Text{
                text:qsTr(runing==true?"暂停":"继续")
                color:"#000"
                font.pixelSize: 34
                anchors.centerIn: parent
            }
            onClicked: {
                if(runing==true)
                    timer_alarm.stop()
                else
                    timer_alarm.start()
            }
        }
    }
}
