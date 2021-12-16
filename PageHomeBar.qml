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
        enabled:!systemSettings.childLock
        width: wifi_icon.width
        height:parent.height
        anchors.left:parent.left
        anchors.leftMargin: 40

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
        enabled:!systemSettings.childLock
        width: wind_icon.width
        height:parent.height
        anchors.left:parent.left
        anchors.leftMargin: 140

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
        enabled:!systemSettings.childLock
        width:150
        height:parent.height
        anchors.right:childLockBtn.left
        visible: QmlDevState.state.RStoveTimingState===timingStateEnum.RUN
        background: Rectangle {
            opacity: 0
        }
        Image{
            anchors.right: time.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            source: "/images/main_menu/naozhong.png"
        }
        Text{
            id:time
            anchors.verticalCenter: parent.verticalCenter
            color:"#fff"
            text:"0"+Math.floor(QmlDevState.state.RStoveTimingLeft/60)+":"+Math.floor(QmlDevState.state.RStoveTimingLeft%60/10)+(QmlDevState.state.RStoveTimingLeft%60%10)//qsTr("01:12")
            font.pixelSize:40
            anchors.right: parent.right
        }
        onClicked: {
            if(visible)
                load_page("pageCloseHeat")
        }
    }
    //童锁按钮
    TabButton{
        id:childLockBtn
        width:tongsuoImg.width
        height:parent.height
        anchors.right:parent.right
        anchors.rightMargin: 30
        background:Rectangle{
            color:"transparent"
        }
        Image{
            id:tongsuoImg
            anchors.centerIn: parent
            source: systemSettings.childLock ?"images/main_menu/tongsuokai_sz.png" : "qrc:/x50/main/icon_ts_k.png"
        }
        Timer {
            id: longPressTimer
            interval: 1000
            repeat: true
            running: false

            onTriggered: {
                ++childLockPressCount
                console.log("childLockPressCount:"+childLockPressCount)
            }
        }

        onPressedChanged: {
            if (pressed) {
                if(systemSettings.childLock === true)
                {
                    childLockPressCount = 0
                    longPressTimer.running = true
                }
            }
            else
            {
                if(systemSettings.childLock === true)
                {
                    longPressTimer.running = false
                    if(childLockPressCount < 3){
                        console.log("请长按童锁键取消童锁")
                    }
                    else
                    {
                        longPressTimer.running = false
                        systemSettings.childLock=false
                        console.log("童锁键取消")
                    }
                }
                else
                {
                    console.log("启用童锁")
                    systemSettings.childLock=true
                }
            }
        }
    }
}
