import QtQuick 2.2
import QtQuick.Controls 2.2
import QmlWifi 1.0
Item {
    property int childLockPressCount:0
    //    anchors.fill: parent

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onNameChanged: { // 处理目标对象信号的槽函数

        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page home onStateChanged")
            if(("StOvState"==name || "RStOvState"==name))
            {
                if(value > 0)
                {
                    var ret=isExistView("pageSteamBakeRun")
                    console.log(ret,typeof ret)
                    if(ret===null)
                    {
                        load_page("pageSteamBakeRun")
                    }
                }
                else
                {
                    if(QmlDevState.state.StOvState===0 && QmlDevState.state.RStOvState===0)
                    {
                        backTopPage()
                    }
                }
            }

        }
    }

    Component.onCompleted: {
        console.log("page home onCompleted")

        if(systemSettings.wifiSwitch){
            qmlWifi.scanWiFi();
        }
    }
    StackView.onActivated:{
        console.log("page home onActivated")

        if(systemSettings.wifiSwitch){
            getWifiStatus()
        }
        else{
            wifi_icon.source = "images/wifi/icon_wifi_error.png"
        }
    }
    function getWifiStatus()
    {
        var wifi_state=qmlWifi.getWifiState()
        console.log("pagehome getWifiStatus",wifi_state,QmlWifi.WiFiEventConnected)

        if(wifi_state!==QmlWifi.WiFiEventConnected){
            wifi_icon.source = "images/wifi/icon_wifi_error.png"
        }
        else{
            wifi_icon.source = "images/wifi/wifi.png"
        }
    }

    QmlWifi{
        id:qmlWifi
        onWifiEvent:{
            console.log("WiFi status:" ,event)
        }
    }
    Timer{
        property int timer_wifi_count:0
        id:timer_wifi
        repeat: true
        running: systemSettings.wifiSwitch
        interval: 30000
        triggeredOnStart: false
        onTriggered: {
            console.log("pagehome timer_wifi",timer_wifi_count)

            if(++timer_wifi_count>3)
            {
                timer_wifi_count=0;
                qmlWifi.scanWiFi();
            }
            getWifiStatus()
        }
    }
    Rectangle{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom:topBar.top
        color:"#000"

        SwipeView {
            id: swipeview
            currentIndex:1
            width:parent.width

            interactive:true //是否可以滑动

            anchors.top:parent.top
            anchors.bottom: indicator.top
            anchors.bottomMargin: 10
            Item {
                PageHomeFirst{}
            }
            Item {
                PageHomeSecond{}
            }
            Item {
                PageHomeThird{}
            }
        }

        Button{
            id:preBtn
            width:60
            height:swipeview.height
            anchors.left:parent.left

            background:Rectangle{
                color:"transparent"
            }
            Image{
                anchors.centerIn: parent
                source: "/images/main_menu/zuohua.png"
                opacity: swipeview.currentIndex===0?0:1
            }
            onClicked:{
                console.log('preBtn',swipeview.currentIndex);
                if(swipeview.currentIndex>0){
                    swipeview.currentIndex-=1
                }
            }
        }

        Button{
            id:nextBtn
            width:60
            height:swipeview.height
            anchors.right:parent.right

            background:Rectangle{
                color:"transparent"
            }
            Image{
                anchors.centerIn: parent
                source: "/images/main_menu/youhua.png"
                opacity: swipeview.currentIndex===(swipeview.count-1)?0:1
            }
            onClicked:{
                console.log('nextBtn',swipeview.currentIndex);
                if(swipeview.currentIndex < swipeview.count){
                    swipeview.currentIndex+=1
                }
            }
        }
        PageIndicator {
            id:indicator
            count: swipeview.count
            currentIndex: swipeview.currentIndex
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: true
            delegate: Image {

                source:index===swipeview.currentIndex
                       ?"images/main_menu/user_active"+index+".png":"images/main_menu/user_normal"+index+".png"
                anchors.verticalCenter:parent.verticalCenter
            }
        }

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
            source: "images/main_menu/zhuangtai_bj.png"
        }
        //wifi图标
        TabButton {
            id:wifi
            width:100
            height:parent.height
            anchors.left:parent.left

            background: Rectangle {
                opacity: 0
            }
            Image{
                id:wifi_icon
                anchors.centerIn: parent
                source: "images/wifi/wifi.png"
            }
            onClicked: {
                load_page("pageWifi")
            }
        }

        TabButton {
            id:closeHeat
            width:100
            height:parent.height
            anchors.right:childLockBtn.left
            visible: true
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
                text:Qt.formatTime(new Date( 2020,1, 1, 14, 15, 0),"hh:mm")//qsTr("01:12")
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
                    if(systemSettings.childLock == false)
                    {
                        childLockPressCount = 0
                        longPressTimer.running = true
                    }
                }
                else
                {
                    if(systemSettings.childLock == false)
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
                            //                            QmlDevState.setUartData("HoodSpeed",150)
                            //                            QmlDevState.sendUartData()
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
}
