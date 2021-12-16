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
        //        showLoaderFault("烤箱加热异常！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
        //        showLoaderFault("蒸箱干烧告警！","请暂停使用蒸箱并<br/>拨打售后电话<font color='#00E6B6'>400-888-8490</font>");
        //        showLoaderFault("烟机进风口高温告警！","请及时关闭旋塞阀\n等待温度降低后使用");
        //        showLoaderFault("燃气泄漏告警！","燃气已泄露\n请立即复位塞阀\n关闭总阀并开窗通气");
        //        showLoaderFaultImg("/x50/icon/icon_pop_th.png","记得及时清理油盒\n保持清洁哦")
        //        showLoaderFaultCenter("左腔门开启，工作暂停",274)
        //        showLoaderFaultCenter("右灶未开启\n开启后才可定时关火",274)
    }
    StackView.onActivated:{
        console.log("page home onActivated")

    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageHomeBar {
        id:topBar
        width:parent.width
        anchors.bottom: parent.bottom
        height:80
        windImg:QmlDevState.state.HoodSpeed===0?"":"qrc:/x50/main/icon_wind_"+QmlDevState.state.HoodSpeed+".png"
    }
    Rectangle{
        enabled:!systemSettings.childLock
        width:parent.width
        anchors.top:parent.top
        anchors.bottom:topBar.top
        color:"transparent"

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
        PageIndicator {
            count: swipeview.count
            currentIndex: swipeview.currentIndex
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: true
            //            delegate: Image {

            //                source:index===swipeview.currentIndex
            //                       ?"images/main_menu/user_active"+index+".png":"images/main_menu/user_normal"+index+".png"
            //                anchors.verticalCenter:parent.verticalCenter
            //            }
        }
        Button{
            id:preBtn
            width:75
            height:110
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter

            background:Rectangle{
                color:"transparent"
            }
            Image{
                anchors.centerIn: parent
                source: "qrc:/x50/main/icon_leftgo.png"
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
            width:75
            height:110
            anchors.right:parent.right
            anchors.verticalCenter: parent.verticalCenter
            background:Rectangle{
                color:"transparent"
            }
            Image{
                anchors.centerIn: parent
                source: "qrc:/x50/main/icon_rightgo.png"
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


}
