import QtQuick 2.2
import QtQuick.Controls 2.2

ToolBar {

    background:Rectangle{
        color:"#2B2E2E"
    }

    //wifi图标
    TabButton {
        id:wifi
        enabled:!systemSettings.childLock
        width:100
        height:parent.height
        anchors.left:parent.left

        background: Rectangle {
            opacity: 0
        }
        Image{
            id:wifi_icon
            anchors.centerIn: parent
            source: wifiConnected ? "images/wifi/wifi.png":"images/wifi/icon_wifi_error.png"
        }
        onClicked: {
            load_page("pageWifi")
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
        width:100
        height:parent.height
        anchors.right:parent.right

        background:Rectangle{
            color:"transparent"
        }
        Image{
            id:tongsuoImg
            anchors.centerIn: parent
            source: systemSettings.childLock ?"images/main_menu/tongsuokai_sz.png" : "images/main_menu/tongsuokai.png"
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
                if(systemSettings.childLock === false)
                {
                    childLockPressCount = 0
                    longPressTimer.running = true
                }
            }
            else
            {
                if(systemSettings.childLock === false)
                {
                    longPressTimer.running = false
                    if(childLockPressCount < 2){
                        console.log("请长按童锁键启用童锁")
                    }
                    else
                    {
                        longPressTimer.running = false
                        systemSettings.childLock=true
                        console.log("童锁键启用")
                    }
                }
                else
                {
                    console.log("取消童锁")
                    systemSettings.childLock=false
                }
            }
        }
    }
}
