import QtQuick 2.7
import QtQuick.Controls 2.2

import "pageMain"
import "WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property int productionTestFlag:1
    property int lastLStOvState:-1
    property int lastRStOvState:-1
    property int lastErrorCodeShow:0

    id:root
    enabled: sysPower > 0
    //    anchors.fill: parent

    Timer{
        id:timer_test
        repeat: false
        running: true
        interval: 180000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_test onTriggered");
            productionTestFlag=0
        }
    }
    Component{
        id:component_alarm
        PagePopup{
            hintTopText:"点击机头图标\n或点击下方按钮关闭闹钟"
            hintHeight:306
            confirmText:"关闭闹钟"
            onCancel: {
                closeAlarm()
            }
            onConfirm: {
                SendFunc.setAlarm(0)
                closeAlarm()
            }
            Image {
                asynchronous:true
                smooth:false
                anchors.top: parent.top
                anchors.topMargin: 87+65
                anchors.right: parent.right
                anchors.rightMargin:100+160
                source: "qrc:/x50/icon/icon_alarm.png"
            }
        }
    }
    function showAlarm(){
        if(loader_main.status == Loader.Null || loader_main.status == Loader.Error)
            loader_main.sourceComponent = component_alarm
    }
    function closeAlarm(){
        if(loader_main.sourceComponent === component_alarm)
            loader_main.sourceComponent = undefined
    }

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
                SendFunc.otaRquest(1)
            }
        }
    }
    function showUpdateConfirm(){
        if(loader_main.status == Loader.Null || loader_main.status == Loader.Error)
            loader_main.sourceComponent = component_updateConfirm
    }

    Component{
        id:component_update
        Rectangle {
            anchors.fill: parent
            color: themesWindowBackgroundColor
            property alias updateProgress: updateBar.value
            MouseArea{
                anchors.fill: parent
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                color:themesTextColor
                font.pixelSize: 50
                text: qsTr("升级中,请勿断电!")
            }
            PageRotationImg {
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
                    color: themesTextColor2
                    radius: 2
                }

                contentItem: Item {
                    implicitWidth: parent.width
                    implicitHeight: 4

                    Rectangle {
                        width: updateBar.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: themesTextColor
                    }
                }
            }
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
            hintCenterText:""
            hintBottomText:""
            hintHeight:275
            onCancel:{
                closeLoaderMain()
            }
        }
    }
    function showUpdateResult(text){
        loader_main.sourceComponent = component_updateSuccess
        loader_main.item.hintCenterText=text
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onLocalConnectedChanged:{
            console.log("page home onLocalConnectedChanged",value)
            if(value > 0)
            {
                closeLoaderFault()
                SendFunc.permitSteamStartStatus(0)
                if(systemSettings.firstStartup===true)
                    systemSettings.firstStartup=false
                //                else if(systemSettings.wifiEnable==false)
                //                    SendFunc.enableWifi(false)
            }
            else
            {
                showLoaderFault("通讯板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false)
            }
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page home onStateChanged",key,value)
            if("SysPower"==key)
            {
                systemPower(value)
            }
            else if("LStOvState"==key)
            {
                console.log("LStOvState",value,QmlDevState.state.LStOvState)
                var ret=isExistView("pageSteamBakeRun")
                console.log(ret,typeof ret)
                if(value > 0)
                {
                    if(ret==null)
                    {
                        load_page("pageSteamBakeRun")
                    }
                }
                else
                {
                    if(ret!=null)
                    {
                        if(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_STOP)
                        {
                            backTopPage()
                        }
                    }
                }

                if(lastLStOvState!=value && lastLStOvState>=0)
                {
                    if(value==5)
                    {
                        if(QmlDevState.state.LStOvDoorState==1)
                            showLoaderPopup("","左腔门开启，工作暂停",275)
                    }
                    else
                    {
                        if(QmlDevState.state.LStOvDoorState==0)
                            closeLoaderDoorPopup("左腔")
                    }
                }
                lastLStOvState=value
            }
            else if("RStOvState"==key)
            {
                console.log("RStOvState",value,QmlDevState.state.RStOvState)
                var ret=isExistView("pageSteamBakeRun")
                console.log(ret,typeof ret)
                if(value > 0)
                {
                    if(ret==null)
                    {
                        load_page("pageSteamBakeRun")
                    }
                }
                else
                {
                    if(ret!=null)
                    {
                        if(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_STOP)
                        {
                            backTopPage()
                        }
                    }
                }
                if(lastRStOvState!=value && lastRStOvState>=0)
                {
                    if(value==5)
                    {
                        if(QmlDevState.state.RStOvDoorState==1)
                            showLoaderPopup("","右腔门开启，工作暂停",275)
                    }
                    else
                    {
                        if(QmlDevState.state.RStOvDoorState==0)
                            closeLoaderDoorPopup("右腔")
                    }
                }
                lastRStOvState=value
            }
            else if("HoodOffLeftTime"==key)
            {
                if(value==0)
                    closeLoaderHoodOff()
            }
            else if("HoodOffRemind"==key)
            {
                if(value==1)
                {
                    if(QmlDevState.state.HoodOffLeftTime!=0)
                    {
                        showLoaderHoodOff()
                    }
                }
                else if(value==2)
                {
                    showLoaderPopup("蒸烤箱工作中，\n烟机需要散热无法关闭","",306,"知道了",closeLoaderPopup)
                }
            }
            //            else if("ErrorCode"==key)
            //            {
            //                console.log("ErrorCode:",value)
            //                if(value==0)
            //                {
            //                    closeLoaderFault()
            //                }
            //            }
            else if("ErrorCodeShow"==key)
            {
                console.log("ErrorCodeShow:",value)
                if(lastErrorCodeShow!=value)
                {
                    if(value>0)
                    {
                        switch (value) {
                        case 1:
                            showLoaderFault("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
                            break
                        case 2:
                            showLoaderFault("没有水箱或水箱没有放到位","没有水箱或水箱没有放到位<br/>请重新放置")
                            break
                        case 3:
                            showLoaderFault("水箱缺水","水箱缺水，请及时加水")
                            break
                        case 4:
                            showLoaderFault("左腔蒸箱干烧！","请暂停使用左腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>")
                            break
                        case 5:
                            showLoaderFault("左腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
                            break
                        case 6:
                            showLoaderFault("防火墙传感器故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
                            break
                        case 7:
                            showLoaderFault("烟机进风口出现火情！","请及时关闭灶具旋钮 等待温度降低后使用")
                            break
                        case 8:
                            showLoaderFault("燃气泄漏","燃气有泄露风险\n请立即关闭灶具旋钮\n关闭总阀并开窗通气")
                            break
                        case 9:
                            showLoaderFault("电源板串口故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
                            break
                        case 10:
                            showLoaderFault("左腔烤箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
                            break
                        case 12:
                            showLoaderFault("右腔蒸箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
                            break
                        case 13:
                            showLoaderFault("右腔蒸箱干烧","请暂停使用右腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>");
                            break
                        case 14:
                            showLoaderFault("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
                            break
                        case 20:
                            showLoaderFault("手势板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
                            break
                        default:
                            break
                        }
                        SendFunc.setBuzControl(0x04)
                    }
                    else
                    {
                        SendFunc.setBuzControl(0)
                        closeLoaderFault()
                    }
                    lastErrorCodeShow=value
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
                if(productionTestFlag==2 && value > 0)
                {
                    getQuadScanWifi()
                }
            }
            else if("WifiState"==key)
            {
                console.log("...WifiState:",value)
                wifiConnected=false
                if(value==1)
                {
                    wifiConnecting=true
                }
                else
                {
                    wifiConnecting=false
                    if(value==2 || value==3|| value==5)
                    {
                        WifiFunc.deleteWifiInfo(wifiConnectInfo)
                    }
                    else if(value==4)
                    {
                        wifiConnected=true
                        WifiFunc.getCurWifi()
                    }
                }
                console.log("WifiState",value,wifiConnected,wifiConnecting)
            }
            else if("ssid"==key)
            {
                if(wifiConnected==true && value==wifiConnectInfo.ssid)
                    WifiFunc.addWifiInfo(wifiConnectInfo)
            }
            else if("ProductionTest"==key)
            {
                if(productionTestFlag > 0)
                    load_page("pageTestFront")
            }
            else if("Alarm"==key)
            {
                if(value > 0)
                    showAlarm()
                else
                    closeAlarm()
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
                else if(value==4)
                {
                    showUpdateResult("系统下载失败")
                }
                else if(value==8)
                {
                    showUpdateResult("系统已更新至最新版本 "+QmlDevState.state.OTANewVersion)
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
            else if( "DeviceSecret"==key && productionTestFlag==1)
            {
                if(value==""||value==null)
                {
                    productionTestFlag=2
                    if(systemSettings.wifiEnable==false)
                        SendFunc.enableWifi(true)
                    else
                    {
                        getQuadScanWifi()
                    }
                }
                else
                {
                    productionTestFlag=3
                }
            }
            else if("WifiScanR"==key && systemSettings.wifiEnable>0)
            {
                setWifiList(value)
                if( productionTestFlag==2 && QmlDevState.state.DeviceSecret==="")
                {
                    parseWifiList()
                }
            }
        }
    }

    function setWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        //        console.log("setWifiList:" ,sanR,root.length)
        root.sort(function(a, b){return b.rssi - a.rssi})
        wifiModel.clear()
        var result={}

        for(var i = 0; i < root.length; ++i) {
            if(root[i].ssid==="")
                continue
            result.connected=0

            result.ssid=root[i].ssid
            result.level=WifiFunc.signalLevel(root[i].rssi)
            result.flags=WifiFunc.encrypType(root[i].flags)

            if(root[i].bssid===QmlDevState.state.bssid)
            {
                if(wifiConnected==false)
                    wifiConnected=true
                result.connected=1
                wifiModel.insert(0,result)
            }
            else
                wifiModel.append(result)
            console.log("result:",QmlDevState.state.bssid,root[i].bssid,root[i].rssi,result.connected,result.ssid,result.level,result.flags)
        }
        if(QmlDevState.state.bssid=="")
        {
            wifiConnected=false
        }
    }

    Component{
        id:component_burn_wifi
        Item {
            Rectangle{
                width: 300
                height: 150
                color: "#000"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 40
                    color: "#FFF"
                    text: qsTr("烧录WIFI不存在")
                }
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    closeLoaderMain()
                }
            }
        }
    }
    function showBurnWifi(){
        if(loader_main.status == Loader.Null || loader_main.status == Loader.Error)
            loader_main.sourceComponent = component_burn_wifi
    }
    function getQuadScanWifi()
    {
        SendFunc.scanWifi()
        timer_scanwifi.restart()
    }

    function parseWifiList()
    {
        var i
        for( i = 0; i < wifiModel.count; ++i) {
            if(wifiModel.get(i).ssid==productionTestWIFISSID)
            {
                wifiModel.setProperty(0,"connected",0)
                wifiModel.setProperty(i,"connected",2)
                wifiModel.move(i,0,1)
                break
            }
        }
        if(i == wifiModel.count)
        {
            if(productionTestFlag==2)
            {
                productionTestFlag=3
                getQuadScanWifi()
                return
            }
            showBurnWifi()
            return
        }
        productionTestFlag=3
        load_page("pageGetQuad")
    }
    Timer{
        id:timer_scanwifi
        repeat: false
        running: false
        interval: 2500
        triggeredOnStart: false
        onTriggered: {
            SendFunc.scanRWifi()
        }
    }
    Component.onCompleted: {
        console.log("page home onCompleted")

        QmlDevState.startLocalConnect()
        //        showAlarm()
        //        showLoaderFault("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
        //                        showLoaderPopup("","左腔门开启，工作暂停",275)
        //                showLoaderPopup("","右灶未开启\n开启后才可定时关火",275)
// showLoaderFault("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
//        showLoaderFault("","网络连接失败，请重试",true,"","qrc:/x50/icon/icon_pop_error.png")
    }
    StackView.onActivated:{
        console.log("page home onActivated")
        SendFunc.permitSteamStartStatus(0)
    }

    Item{
        id:swipe
        anchors.top:parent.top
        width:parent.width
        height: 400

        SwipeView {
            id: swipeview
            currentIndex:1
            width:parent.width
            height:parent.height

            interactive:true //是否可以滑动
            Item {
                PageHomeSecond{}
            }
            Item {
                PageHomeFirst{}
            }
            Item {
                PageHomeThird{}
            }
            Component.onCompleted:{
                //                contentItem.highlightFollowsCurrentItem=true

                //                contentItem.highlightRangeMode=istView.StrictlyEnforceRange
                //                contentItem.highlightResizeDuration= 0
                //                contentItem.highlightResizeVelocity=-1
                contentItem.highlightMoveDuration = 5       //将移动时间设为0
                contentItem.highlightMoveVelocity = -1
            }
        }
        PageIndicator {
            count: swipeview.count
            currentIndex: swipeview.currentIndex
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            //            interactive: true
            delegate: Rectangle {
                color: index===swipeview.currentIndex?"#FFF":"#4C4C4C"
                implicitWidth: 22
                implicitHeight: 4
            }
        }
    }
    Button{
        id:preBtn
        width:60
        height:100
        anchors.left:parent.left

        anchors.verticalCenter: swipe.verticalCenter
        visible: swipeview.currentIndex===0?false:true
        background:Image{
            asynchronous:true
            smooth:false
            anchors.centerIn: parent
            source: themesImagesPath+"previouspage-background.png"
        }
        onClicked:{
            console.log('preBtn',swipeview.currentIndex)
            if(swipeview.currentIndex>0){
                //                    swipeview.currentIndex-=1
                //                    swipeview.setCurrentIndex(swipeview.currentIndex-1)
                swipeview.decrementCurrentIndex()
            }
        }
    }
    Button{
        id:nextBtn
        width:60
        height:100
        anchors.right:parent.right

        anchors.verticalCenter: swipe.verticalCenter
        visible: swipeview.currentIndex===(swipeview.count-1)?false:true
        background:Image{
            asynchronous:true
            smooth:false
            anchors.centerIn: parent
            source: themesImagesPath+"nextpage-background.png"
        }
        onClicked:{
            console.log('nextBtn',swipeview.currentIndex)
            if(swipeview.currentIndex < swipeview.count){
                //                    swipeview.currentIndex+=1
                //                    swipeview.setCurrentIndex(swipeview.currentIndex+1)
                swipeview.incrementCurrentIndex()
            }
        }
    }
    PageHomeBar {
        anchors.bottom: parent.bottom
    }
}
