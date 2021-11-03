import QtQuick 2.2
import QtQuick.Controls 2.2
import QmlWifi 1.0
Item {
    //判断儿童锁(true表示锁定，false表示未锁定)
    property bool childLock:false

    property int childLockPressCount:0

    visible: true
    //    width: parent.width
    //    height: parent.height
    //    anchors.fill: parent
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
            currentIndex:0
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
//            Item {
//                PageHomeThird{}
//            }
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
        Image {
            anchors.fill: parent
            source: "images/main_menu/zhuangtai_bj.png"
        }
        //wifi图标
        TabButton {
            id:wifi
            width:130
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                id:wifi_icon
                anchors.centerIn: parent
                source: "images/wifi/wifi.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                console.log("TabButton wifi")
                load_page("pageWifi")
            }
        }

        //时间展示
        Text{
            id:currentTime
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: fontSize
            color:"#9BABC2"
            text:getCurtime()

            //时间Timer
            Timer {
                interval: 30000
                running: true
                repeat: true
                onTriggered: {
                    currentTime.text = getCurtime()//此处即是让时间显示到文本中去
                }
            }
        }

        //水箱问题
        Rectangle{
            id:waterTank
            width:80
            height:parent.height
            anchors.right:childLockBtn.left
            color:"transparent"
            visible: true

            Image{
                anchors.centerIn: parent
                source: "images/main_menu/queshuitubiao.png"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("click waterTank")
                }
            }
        }

        //童锁按钮
        TabButton{

            id:childLockBtn
            width:105
            height:parent.height
            anchors.right:parent.right
            background:Rectangle{
                color:"transparent"
                Image{
                    anchors.right:parent.right
                    anchors.rightMargin: 50
                    anchors.verticalCenter: parent.verticalCenter
                    source: childLock ?"images/main_menu/tongsuokai_sz.png" : "images/main_menu/tongsuokai.png"
                }

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
                    if(childLock == false)
                    {
                        childLockPressCount = 0
                        longPressTimer.running = true
                    }
                }
                else
                {
                    if(childLock == false)
                    {
                        longPressTimer.running = false
                        if(childLockPressCount < 2){
                            console.log("请长按童锁键启用童锁")
                        }
                        else
                        {
                            longPressTimer.running = false
                            childLock=true
                            console.log("童锁键启用")
                        }
                    }
                    else
                    {
                        console.log("取消童锁")
                        childLock=false
                    }
                }
            }
        }
    }
}
