import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property int childLockPressCount:0
    //    anchors.fill: parent

    Component{
        id:component_updateConfirm
        PageDialogConfirm{
            hintTopText:"系统更新"
            hintBottomText:"检测到最新版本 "+QmlDevState.state.OTANewVersion+"\n是否升级系统?"
            confirmText:"升级"
            hintHeight:360
            onCancel: {
                closeLoaderMain()
            }
            onConfirm: {
                //               closeLoaderMain()
                otaRquest(1)
            }
        }
    }
    function showUpdateConfirm(){
        loader_main.sourceComponent = component_updateConfirm
    }

    Component{
        id:component_update
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            property alias updateProgress: updateBar.value
            MouseArea{
                anchors.fill: parent
            }
            Image {
                anchors.fill: parent
                source: "/x50/main/背景.png"
            }
            Image {
                anchors.top: parent.top
                anchors.topMargin: 155
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/x50/set/jiazaizhong.png"
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 300
                anchors.horizontalCenter: parent.horizontalCenter
                color:"#FFF"
                font.pixelSize: 40
                text: qsTr(updateBar.value+"%")
            }
            ProgressBar {
                id:updateBar
                width: 650
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 100
                anchors.horizontalCenter: parent.horizontalCenter
                from:0
                to:100
                value: 0

                background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: 4
                    color: "#FFF"
                    opacity: 0.35
                    radius: 2
                }

                contentItem: Item {
                    implicitWidth: parent.width
                    implicitHeight: 4

                    Rectangle {
                        width: updateBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: "#00E6B6"
                    }
                }
            }

            //            Slider {
            //                id: slider
            //                anchors.bottom: parent.bottom
            //                anchors.bottomMargin: 20
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                stepSize: 2
            //                to: 100
            //                value: 0
            //                onValueChanged: {
            //                    console.log("slider:",value)
            //                    updateBar.value=value
            //                }
            //            }
        }
    }
    function showUpdate(){
        loader_main.sourceComponent = component_update
    }
    function showUpdateProgress(value){
        loader_main.item.updateProgress=value
    }
    Component{
        id:component_updateSuccess
        PageFaultPopup {
            hintTopText:""
            hintTopImgSrc:""
            hintCenterText:"系统已更新至最新版本 "+QmlDevState.state.OTANewVersion
            hintBottomText:""
            hintHeight:275
            onCancel:{
                closeLoaderMain()
                backTopPage()
            }
        }
    }
    function showUpdateSuccess(){
        loader_main.sourceComponent = component_updateSuccess
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onLocalConnectedChanged:{
            console.log("page home onLocalConnectedChanged",value)
            if(value > 0)
            {
                closeLoaderError()
                permitSteamStartStatus(0)
            }
            else
            {
                showLoaderFault("通讯板故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员",false)
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
            else if("ErrorCodeShow"==key)
            {
                console.log("ErrorCodeShow:",value)

                if(value>0)
                {
                    switch (value) {
                    case 1:
                        showLoaderFault("左腔蒸箱加热异常！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
                        break
                    case 3:
                        showLoaderFault("水箱缺水","水箱缺水，请及时加水");
                        break
                    case 4:
                        showLoaderFault("左腔蒸箱干烧！","请暂停使用左腔蒸箱并<br/>拨打售后电话<font color='#00E6B6'>400-888-8490</font>");
                        break
                    case 5:
                        showLoaderFault("左腔干烧检测电路故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员")
                        break
                    case 6:
                        showLoaderFault("防火墙传感器故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员")
                        break
                    case 7:
                        showLoaderFault("烟机进风口出现火情！","请及时关闭灶具旋钮 等待温度降低后使用")
                        break
                    case 8:
                        showLoaderFault("燃气泄漏","燃气有泄露风险\n请立即关闭灶具旋钮\n关闭总阀并开窗通气")
                        break
                    case 9:
                        showLoaderFault("电源板串口故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
                        break
                    case 10:
                        showLoaderFault("左腔烤箱加热异常！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
                        break
                    case 12:
                        showLoaderFault("右腔蒸箱加热异常！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
                        break
                    case 13:
                        showLoaderFault("右腔蒸箱干烧","请暂停使用右腔蒸箱并<br/>拨打售后电话<font color='#00E6B6'>400-888-8490</font>");
                        break
                    case 14:
                        showLoaderFault("右腔干烧检测电路故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员")
                        break
                    case 20:
                        showLoaderFault("手势板故障！","请拨打售后电话<font color='#00E6B6'>400-888-8490</font><br/>咨询售后人员");
                        break
                    default:
                        break
                    }
                    setBuzControl(0x04)
                }
                else
                {
                    setBuzControl(0)
                }
            }
            else if("ProductionTest"==key)
            {
                load_page("pageTestFront")
            }
            else if("LStOvDoorState"==key)
            {
                if(value==1)
                {
                    if(QmlDevState.state.LStOvState!==workStateEnum.WORKSTATE_STOP)
                        showLoaderFaultCenter("左腔门开启，工作暂停",275)
                }
            }
            else if("RStOvDoorState"==key)
            {
                if(value==1)
                {
                    if(QmlDevState.state.RStOvState!==workStateEnum.WORKSTATE_STOP)
                        showLoaderFaultCenter("右腔门开启，工作暂停",275)
                }
            }
            else if("WifiEnable"==key)
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
                    if(value==2 || value==3)
                    {
                        deleteWifiInfo(wifiConnectInfo)
                    }
                    else if(value==4)
                    {
                        wifiConnected=true
                        addWifiInfo(wifiConnectInfo)
                    }
                }
                console.log("WifiState",value,wifiConnected)
            }
            else if("OTAState"==key)
            {
                if(value==1)
                {
                }
                else if(value==2)
                {
                    showUpdateConfirm()
                }
                else if(value==3)
                {
                    showUpdate()
                }
                else if(value==8)
                {
                    showUpdateSuccess()
                }
            }
            else if(("OTAProgress"==key))
            {
                console.log("OTAProgress:",value)
                showUpdateProgress(value);
                if(value==100)
                {

                }
            }
        }
    }

    Component.onCompleted: {
        console.log("page home onCompleted")

        //        systemSettings.multistageRemind=true

        //        showLoaderFaultImg("/x50/icon/icon_pop_th.png","记得及时清理油盒\n保持清洁哦")
        //        showLoaderFaultCenter("左腔门开启，工作暂停",275)
        //                showLoaderFaultCenter("右灶未开启\n开启后才可定时关火",275)
    }
    StackView.onActivated:{
        console.log("page home onActivated")
        permitSteamStartStatus(0)
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
        windImg:(QmlDevState.state.HoodSpeed==0 || QmlDevState.state.HoodSpeed==null)?"":"qrc:/x50/main/icon_wind_"+QmlDevState.state.HoodSpeed+".png"
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
            delegate: Rectangle {
                color:"transparent"
                implicitWidth: indicatorCir.implicitWidth+8
                implicitHeight: 6
                Rectangle {
                    id:indicatorCir
                    implicitWidth: index===swipeview.currentIndex?8:6
                    implicitHeight: implicitWidth
                    anchors.centerIn: parent
                    radius: implicitWidth/2
                    opacity: index===swipeview.currentIndex?0.9:0.4
                    color:"#FFF"
                }
            }

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
