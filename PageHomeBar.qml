import QtQuick 2.2
import QtQuick.Controls 2.2

ToolBar {

    property alias windImg:wind_icon.source
    background:Rectangle{
        color:"#000"
        opacity: 0.15
    }

    //wifi图标
    TabButton {
        id:wifi
        width: wifi_icon.width+40
        height:parent.height
        anchors.left:parent.left
        anchors.leftMargin: 20

        background: Rectangle {
            opacity: 0
        }
        Image{
            id:wifi_icon
            anchors.centerIn: parent
            source: wifiConnected ? "qrc:/x50/main/icon_wife_nor.png":"qrc:/x50/main/icon_wife_w.png"
        }
        onClicked: {
            load_page("pageWifi")
        }
    }

    TabButton {
        id:wind
        width: wind_icon.width+40
        height:parent.height
        anchors.left:wifi.right
        //        anchors.leftMargin: 140

        background: Rectangle {
            opacity: 0
        }
        Image{
            id:wind_icon
            anchors.centerIn: parent
        }
        onClicked: {

        }
    }

    TabButton {
        id:closeHeat
        width:time.width+closeHeatImg.width+20
        height:parent.height
        anchors.right:childLockBtn.left
        anchors.rightMargin: 20
        visible: QmlDevState.state.RStoveTimingState===timingStateEnum.RUN
        background: Rectangle {
            opacity: 0
        }
        Image{
            id:closeHeatImg
            anchors.right: time.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/x50/main/icon_time.png"
        }
        Text{
            id:time
            anchors.verticalCenter: parent.verticalCenter
            color:"#fff"
            text:"0"+Math.floor(QmlDevState.state.RStoveTimingLeft/60)+":"+Math.floor(QmlDevState.state.RStoveTimingLeft%60/10)+(QmlDevState.state.RStoveTimingLeft%60%10)//qsTr("01:12")
            font.pixelSize:35
            anchors.right: parent.right
        }
        onClicked: {
            console.log("closeHeat btn",time.width,closeHeatImg.width)
            if(visible)
                load_page("pageCloseHeat")
        }
    }

    Component{
        id:component_lock_screen
        PageLockScreen{
        }
    }

    function showLockScreen(){
        loader_lock_screen.sourceComponent = component_lock_screen
    }
    //童锁按钮
    TabButton{
        id:childLockBtn
        width:120
        height:parent.height
        anchors.right:parent.right
        //        anchors.rightMargin: 0
        background:Rectangle{
            color:"transparent"
            //            border.color: "#fff"
        }
        Image{
            id:tongsuoImg
            anchors.centerIn: parent
            source: systemSettings.childLock ?"qrc:/x50/main/icon_ts_g.png" : "qrc:/x50/main/icon_ts_k.png"
        }

        onPressedChanged: {

            if (pressed) {
                longPressTimer.running = true
            }
            else
            {
                longPressTimer.running = false
            }
        }
    }
    Timer {
        id: longPressTimer
        interval: 300
        repeat: false
        running: false

        onTriggered: {

            if(systemSettings.childLock==false)
            {
                console.log("启用童锁")
                systemSettings.childLock=true
                showLockScreen()
            }

        }
    }
}
