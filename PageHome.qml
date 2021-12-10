import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property int childLockPressCount:0

    //    anchors.fill: parent
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onLocalConnectedChanged:{
            console.log("page home onLocalConnectedChanged",value)
            if(value > 0)
            {
                closeLoaderError()
            }
            else
            {
                showLoaderError()
            }
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page home onStateChanged",key)
            if(("LStOvState"==key || "RStOvState"==key))
            {
                console.log("LStOvState RStOvState",value,QmlDevState.state.LStOvState,QmlDevState.state.RStOvState)
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
                    if(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_STOP && QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_STOP)
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
                    wifiConnecting=true
                }
                else
                {
                    wifiConnecting=false
                    if(value==4)
                    {
                        wifiConnected=true
                    }
                }
                console.log("WifiState",value,wifiConnected)
            }
        }
    }

    Component.onCompleted: {
        console.log("page home onCompleted")
//        systemSettings.setValue("multistageRemind",true)
    }
    StackView.onActivated:{
        console.log("page home onActivated")

    }

    Rectangle{
        enabled:!systemSettings.childLock
        width:parent.width
        anchors.top:parent.top
        anchors.bottom:topBar.top
        color:"#4A5150"

        SwipeView {
            id: swipeview

            currentIndex:0
            width:parent.width

            interactive:true //是否可以滑动

            anchors.top:parent.top
            anchors.bottom: parent.bottom
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
            width:72
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
                console.log('preBtn',swipeview.currentIndex)
                if(swipeview.currentIndex>0){
                    swipeview.currentIndex-=1
                }
            }
        }

        Button{
            id:nextBtn
            width:72
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
                console.log('nextBtn',swipeview.currentIndex)
                if(swipeview.currentIndex < swipeview.count){
                    swipeview.currentIndex+=1
                }
            }
        }

    }
    PageHomeBar {
        id:topBar
        width:parent.width
        anchors.bottom: parent.bottom
        height:80
    }

}
