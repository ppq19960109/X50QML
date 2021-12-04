import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property int childLockPressCount:0
    property bool wifiConnected:false
    //    anchors.fill: parent


    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onNameChanged: { // 处理目标对象信号的槽函数
            console.warn("Page Home onNameChanged...")
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page home onStateChanged")
            if(("StOvState"==key || "RStOvState"==key))
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
            else if(("WifiEnable"==key))
            {
                systemSettings.wifiEnable=value
                if(value==0)
                {
                    wifiConnected=false
                }
                console.log("WifiEnable",value)
            }
            else if(("WifiState"==key))
            {
                wifiConnected=false
                if(value==1)
                {
                    wifi_connecting=true
                }
                else
                {
                    wifi_connecting=false
                    if(value==4)
                    {
                        wifiConnected=true
                    }
                }
                console.log("WifiState",value,wifiConnected)
            }
        }
//        onHistoryChanged: { // 处理目标对象信号的槽函数
//            console.warn("Page Home onHistoryChanged...")
//        }
    }

    Component.onCompleted: {
        console.log("page home onCompleted")

    }
    StackView.onActivated:{
        console.log("page home onActivated")

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
                source: wifiConnected ? "images/wifi/wifi.png":"images/wifi/icon_wifi_error.png"
            }
            onClicked: {
                load_page("pageWifi")
            }
        }

        TabButton {
            id:closeHeat
            width:150
            height:parent.height
            anchors.right:childLockBtn.left
            visible: QmlDevState.state.RStoveTimingState==1
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
