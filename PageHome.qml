import QtQuick 2.7
import QtQuick.Controls 2.2

import "pageMain"
import "WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property int lastLStOvState:-1
    property int lastRStOvState:-1
    property int lastErrorCodeShow:0
    property int lastHoodSpeed:0
    property int lastHoodLight:0

    enabled: sysPower > 0
    //    anchors.fill: parent

    function remindConfirmFunc(){
        SendFunc.setCookOperation(cookWorkPosEnum.LEFT,workOperationEnum.START)
        loaderRemindHide()
    }
    function loaderRemindHide(){
        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(loaderAuto.item.confirmText=="继续烹饪")
                loaderAuto.sourceComponent = undefined
        }
    }
    Component{
        id:component_alarm
        PagePopup{
            hintTopText:"点击机头图标\n或点击下方按钮关闭闹钟"
            confirmText:"关闭闹钟"
            onCancel: {
                loaderAlarmHide()
            }
            onConfirm: {
                SendFunc.setAlarm(0)
                loaderAlarmHide()
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
            //            Component.onCompleted: {
            //                SendFunc.setBuzControl(buzControlEnum.OPEN)
            //            }
            //            Component.onDestruction: {
            //                SendFunc.setBuzControl(buzControlEnum.STOP)
            //            }
        }
    }
    function loaderAlarmShow(){
        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(loaderAuto.item.closeVisible===false)
                return
        }
        loaderAuto.sourceComponent = component_alarm
    }
    function loaderAlarmHide(){
        if(loaderAuto.sourceComponent === component_alarm)
            loaderAuto.sourceComponent = undefined
    }

    Component{
        id:component_updateConfirm
        PageDialogConfirm{
            hintTopText:"系统更新"
            hintBottomText:"检测到最新版本 "+QmlDevState.state.OTANewVersion+"\n是否升级系统?"
            confirmText:"升级"
            hintHeight:360
            onCancel: {
                loaderAuto.sourceComponent = undefined
            }
            onConfirm: {
                SendFunc.otaRquest(1)
            }
        }
    }
    function loaderUpdateConfirmShow(){
        loaderAuto.sourceComponent = component_updateConfirm
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
    function loaderUpdateShow(){
        loaderAuto.sourceComponent = component_update
    }
    function loaderUpdateProgress(value){
        if(loaderAuto.sourceComponent === component_update)
            loaderAuto.item.updateProgress=value
    }

    function loaderUpdateResultShow(text){
        loaderAutoPopupShow("",text,292)
    }
    //    Connections { // 将目标对象信号与槽函数进行连接
    //        target: MNetwork
    //        onReplyLocationData:{

    //            var resp=JSON.parse(value);
    //            console.log("onReplyLocationData",value,resp.data.cityName)
    //            MNetwork.weatherRequest(resp.data.cityName);//杭州
    //        }
    //        onReplyWeatherData:{
    //            //            console.log("onReplyWeatherData",value)
    //            var resp=JSON.parse(value);
    //            var curTemp=resp.current_condition[0].temp_C
    //            var curMinTemp=resp.weather[0].mintempC
    //            var curMaxTemp=resp.weather[0].maxtempC
    //            console.log("onReplyWeatherData",curTemp,curMinTemp,curMaxTemp)
    //        }
    //    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onLocalConnectedChanged:{
            if(value > 0)
            {
                loaderErrorHide()

                SendFunc.permitSteamStartStatus(0)
                if(systemSettings.firstStartup===true)
                {
                    systemSettings.firstStartup=false
                    SendFunc.enableWifi(true)
                    Backlight.backlightSet(systemSettings.brightness)
                }
                SendFunc.setBuzControl(buzControlEnum.STOP)
                SendFunc.setBuzControl(buzControlEnum.SHORT)

                //                else if(systemSettings.wifiEnable==false)
                //                    SendFunc.enableWifi(false)
                //                                loaderErrorShow("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")

                //                load_page("pageTestFront")
            }
            else
            {
                loaderErrorShow("通讯板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false)
                standbyWakeup()
            }
            value=null
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            var ret
            //            console.log("page home onStateChanged",key,value)
            if("SysPower"==key)
            {
                if(sysPower<0 && value==0)
                {
                    SendFunc.setSysPower(1)
                }
                else if(value==1)
                {
                    var errorCode=QmlDevState.state.ErrorCodeShow
                    if(errorCode!==0)
                        loaderErrorCodeShow(errorCode)
                }
                systemPower(value)
            }
            else if("ComSWVersion"==key)
            {
                if(systemSettings.otaSuccess==true)
                {
                    systemSettings.otaSuccess=false
                    loaderUpdateResultShow("系统已更新至最新版本\n"+value)
                }
            }
            else if("SteamStart"==key)
            {
                sleepWakeup()
            }
            else if("LStOvState"==key)
            {
                ret=isExistView("pageSteamBakeRun")
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
                if(value==workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastLStOvState!=value && lastLStOvState>=0)
                {
                    if(value==workStateEnum.WORKSTATE_PAUSE||value==workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        if(QmlDevState.state.LStOvDoorState==1)
                            loaderDoorAutoPopupShow("左腔门开启，工作暂停")
                        //                            loaderAutoPopupShow("","左腔门开启，工作暂停",292)
                    }
                    else
                    {
                        if(QmlDevState.state.LStOvDoorState==0 || value==workStateEnum.WORKSTATE_STOP)
                            loaderDoorAutoPopupHide("左腔")
                    }
                    if(value==workStateEnum.WORKSTATE_STOP)
                        loaderRemindHide()
                }
                lastLStOvState=value
            }
            else if("RStOvState"==key)
            {
                ret=isExistView("pageSteamBakeRun")
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
                if(value==workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastRStOvState!=value && lastRStOvState>=0)
                {
                    if(value==workStateEnum.WORKSTATE_PAUSE||value==workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        if(QmlDevState.state.RStOvDoorState==1)
                            loaderDoorAutoPopupShow("右腔门开启，工作暂停")
                        //                            loaderAutoPopupShow("","右腔门开启，工作暂停",292)
                    }
                    else
                    {
                        if(QmlDevState.state.RStOvDoorState==0 || value==workStateEnum.WORKSTATE_STOP)
                            loaderDoorAutoPopupHide("右腔")
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
                    var LStOvState=QmlDevState.state.LStOvState
                    var RStOvState=QmlDevState.state.RStOvState
                    if(LStOvState == workStateEnum.WORKSTATE_PREHEAT || LStOvState == workStateEnum.WORKSTATE_RUN || LStOvState == workStateEnum.WORKSTATE_PAUSE || RStOvState == workStateEnum.WORKSTATE_PREHEAT || RStOvState == workStateEnum.WORKSTATE_RUN|| RStOvState == workStateEnum.WORKSTATE_PAUSE)
                        loaderAutoPopupShow("蒸烤箱工作中，\n需散热，烟机最低一档","",292,"知道了",loaderAutoPopupHide)
                }
                else if(value==3)
                {
                    var LStOvState=QmlDevState.state.LStOvState
                    if(LStOvState == workStateEnum.WORKSTATE_PREHEAT || LStOvState == workStateEnum.WORKSTATE_RUN|| LStOvState == workStateEnum.WORKSTATE_PAUSE)
                        loaderAutoPopupShow("烤模式运行中，\n需散热，烟机最低二档","",292,"知道了",loaderAutoPopupHide)
                }
                else if(value==4)
                {
                    if(QmlDevState.state.LStoveStatus > 0 || QmlDevState.state.RStoveStatus > 0)
                        loaderAutoPopupShow("灶具工作中，\n需散热，烟机最低一档","",292,"知道了",loaderAutoPopupHide)
                }
                else if(value==5)
                {
                    sleepStandby()
                }
            }
            else if("ErrorCodeShow"==key)
            {
                if(lastErrorCodeShow!=value)
                {
                    if(value>0)
                    {
                        SendFunc.setSysPower(1)
                        loaderErrorCodeShow(value)
                    }
                    else
                    {
                        loaderErrorHide()
                    }
                }
                lastErrorCodeShow=value
            }
            else if("WifiEnable"==key)
            {
                systemSettings.wifiEnable=value
                if(value==0)
                {
                    wifiConnected=false
                    wifiModel.clear()
                }
                if(productionTestFlag==2 && value > 0)
                {
                    getQuadScanWifi()
                }
                systemSync()
            }
            else if("WifiState"==key)
            {
                wifiConnected=false
                if(value==1)
                {
                    wifiConnecting=true
                }
                else
                {
                    if(value==2 || value==3||value==5)
                    {
                        //                        WifiFunc.deleteWifiInfo(wifiConnectInfo)
                        if(isExistView("pageWifi")==null)
                        {
                            wifiConnectInfo.ssid=""
                        }
                    }
                    else if(value==4)
                    {
                        wifiConnected=true
                    }
                    if(isExistView("pageWifi")==null)
                    {
                        SendFunc.getCurWifi()
                    }
                    wifiConnecting=false
                }
                //                console.log("WifiState",value,wifiConnected,wifiConnecting)
            }
            else if("ssid"==key)
            {
                if(wifiConnected==true && wifiConnectInfo.ssid!="")
                {
                    //                    if(pattern.test(wifiConnectInfo.ssid))
                    //                    {
                    decode_ssid=decodeURI(value.replace(/\\x/g,'%'))
                    //                    }
                    //                    else
                    //                    {
                    //                        decode_ssid=value
                    //                    }
                    //                    console.log("decode_ssid",decode_ssid,wifiConnectInfo.ssid)
                    if(decode_ssid==wifiConnectInfo.ssid)
                    {
                        WifiFunc.addWifiInfo(wifiConnectInfo)
                        var real_value=value.replace(/\\{1}x/g,"\\\\x")
                        QmlDevState.executeShell("(wpa_cli list_networks | tail -n +3 | grep \'"+real_value+"\' | grep -v 'CURRENT' | awk '{system(\"wpa_cli remove_network \" $1)}' && wpa_cli save_config) &")
                        real_value=null
                    }
                }
                if(isExistView("pageWifi")==null)
                {
                    wifiConnectInfo.ssid=""
                }
            }
            else if("ProductionTest"==key)
            {
                if(productionTestFlag > 0 && productionTestStatus==0)
                {
                    load_page("pageTestFront")
                }
                else
                {
                    var page=isExistView("pageTestFront")
                    if(page!==null)
                        backPage(page)
                }
            }
            else if("Alarm"==key)
            {
                if(value > 0)
                    loaderAlarmShow()
                else
                    loaderAlarmHide()
            }
            else if("RStoveStatus"==key)
            {
                if(value === 0)
                    loaderStoveAutoPopupHide()
            }
            else if("RStoveTimingState"==key)
            {
                if(value === timingStateEnum.CONFIRM)
                    loaderAutoPopupShow("","右灶定时结束，\n请将右灶旋钮复位",292)
                else if(value === timingStateEnum.STOP)
                    loaderStoveAutoPopupHide()
            }
            else if("HoodSpeed"==key)
            {
                if(value!=0)
                {
                    if(lastHoodSpeed!=value)
                        sleepWakeup()
                }
                lastHoodSpeed=value
            }
            else if("HoodLight"==key)
            {
                if(value!=0)
                {
                    if(lastHoodLight!=value)
                        sleepWakeup()
                }
                lastHoodLight=value
            }
            else if("OTAState"==key)
            {
                if(value==1)
                {
                }
                else if(value==2)
                {
                    loaderUpdateConfirmShow()
                }
                else if(value==3)
                {
                    loaderUpdateShow()
                }
                else if(value==4)
                {
                    loaderUpdateResultShow("系统下载失败")
                }
                else if(value==8)
                {
                    systemSettings.otaSuccess=true
                    //                    loaderUpdateResultShow("系统已更新至最新版本 "+QmlDevState.state.OTANewVersion)
                }
            }
            else if(("OTAProgress"==key))
            {
                loaderUpdateProgress(value);
                //                if(value==100)
                //                {
                //                }
            }
            else if( "DeviceSecret"==key && productionTestFlag==1)
            {
                if(value==""||value==null)
                {
                    productionTestStatus=0xff
                    systemPower(1)
                    SendFunc.setSysPower(1)
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
                    productionTestFlag=0x0f
                }
            }
            else if("WifiScanR"==key && systemSettings.wifiEnable>0)
            {
                setWifiList(value)
                if( productionTestFlag>=2 && productionTestFlag<=5 && QmlDevState.state.DeviceSecret==="")
                {
                    parseWifiList()
                }
            }
            else if("remind"==key)
            {
                if(value>0 && QmlDevState.state.MultiMode === 1)
                {
                    loaderAutoPopupShow(QmlDevState.state.RemindText,"",null,"继续烹饪",remindConfirmFunc)
                }
                else
                {
                    loaderRemindHide()
                }
            }
            else if("DemoStart"==key)
            {
                if(sysPower==0)
                {
                    if(demoModeStatus==0)
                        load_page("pageDemoMode")
                }
            }
            ret=null
            key=null
            value=null
        }
    }

    function setWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        root.sort(function(a, b){return b.rssi - a.rssi})
        wifiModel.clear()
        var result={}
        var element
        var bssid=QmlDevState.state.bssid
        for(var i = 0; i < root.length; ++i) {
            element=root[i]
            if(element.ssid==="")
                continue
            result.connected=0

            result.ssid=root[i].ssid
            result.level=WifiFunc.signalLevel(element.rssi)
            result.flags=WifiFunc.encrypType(element.flags)

            if(element.bssid===bssid && wifiConnected==true)
            {
                result.connected=1
                wifiModel.insert(0,result)
            }
            else
                wifiModel.append(result)
        }

        //        if(bssid==="")
        //        {
        //            console.log("setWifiList:",wifiConnected,bssid)
        //            wifiConnected=false
        //        }
    }

    Component{
        id:component_burn_wifi
        Item {
            Rectangle{
                width: 400
                height: 200
                color: "red"
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 50
                    color: "#FFF"
                    text: qsTr("烧录WIFI不存在")
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    loaderAuto.sourceComponent = undefined
                }
            }
            Component.onCompleted: {
                SendFunc.setBuzControl(buzControlEnum.SHORT)
            }
            Component.onDestruction: {
                productionTestStatus=0
                systemPower(QmlDevState.state.SysPower)
                loaderErrorCodeShow(QmlDevState.state.ErrorCodeShow)
            }
        }
    }
    function showBurnWifi(){
        loaderAuto.sourceComponent = component_burn_wifi
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
            var wifiItem=wifiModel.get(i)
            if(wifiItem.ssid==productionTestWIFISSID)//productionTestWIFISSID
            {
                wifiModel.setProperty(0,"connected",0)
                wifiModel.setProperty(i,"connected",2)
                wifiModel.move(i,0,1)
                break
            }
            wifiItem=null
        }

        if(i == wifiModel.count)
        {
            if(productionTestFlag<5)
            {
                ++productionTestFlag
                getQuadScanWifi()
                return
            }
            productionTestFlag=0x0f
            showBurnWifi()
            return
        }
        productionTestFlag=0x0f
        load_page("pageGetQuad")
    }
    Timer{
        id:timer_scanwifi
        repeat: false
        running: false
        interval: 3000
        triggeredOnStart: false
        onTriggered: {
            SendFunc.scanRWifi()
        }
    }
    Component.onCompleted: {
        console.log("page home onCompleted")

        QmlDevState.startLocalConnect()
        //        MNetwork.locationRequest();

        //        loaderAlarmShow()
        //        loaderErrorShow("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
        //                        loaderAutoPopupShow("","左腔门开启，工作暂停",292)
        //                        loaderPopupShow("","右灶未开启\n开启后才可定时关火",292)
        //        loaderErrorShow("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
        //        loaderImagePopupShow("网络连接失败，请重试","/x50/icon/icon_pop_error.png")
        //        loaderAutoPopupShow("","右灶定时关火结束，\n请将旋钮复位",292,"",null,false)
        //        loaderPopupShow("恢复出厂设置成功","",292,"确定")
        //        loaderUpdateConfirmShow()
        //       loaderUpdateResultShow("系统已更新至最新版本\n"+"1.2.0")
    }
    StackView.onActivating:{
//        console.log("PageHome StackView onActivating")
        SendFunc.permitSteamStartStatus(0)
    }
    StackView.onActivated:{
//        console.log("PageHome StackView onActivated")
        if(permitStartStatus>0)
            SendFunc.permitSteamStartStatus(0)
    }

    Item{
        id:swipe
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: homeBar.top

        SwipeView {
            id: swipeview
            currentIndex:1
            width:parent.width
            height:parent.height
            //            focus: true
            interactive:true //是否可以滑动

            PageHomeSecond{}
            PageHomeFirst{}
            PageHomeThird{}

            Component.onCompleted:{
                //                contentItem.highlightFollowsCurrentItem=true
                //                contentItem.highlightRangeMode=istView.StrictlyEnforceRange
                //                contentItem.highlightResizeDuration= 0
                //                contentItem.highlightResizeVelocity=-1
                contentItem.highlightMoveDuration = 100       //将移动时间设为0
                contentItem.highlightMoveVelocity = -1
                //                contentItem.snapMode=ListView.SnapOneItem
                contentItem.boundsBehavior=Flickable.StopAtBounds
            }
        }
        PageIndicator {
            count: swipeview.count
            currentIndex: swipeview.currentIndex
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: false
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
        visible:{
            if(swipeview.contentItem.moving==true)
                return false
            return swipeview.currentIndex===0?false:true
        }
        background:Image{
            asynchronous:true
            smooth:false
            anchors.centerIn: parent
            source: themesImagesPath+"previouspage-background.png"
        }
        onClicked:{
//            console.log('preBtn',swipeview.currentIndex)
            if(swipeview.currentIndex>0){
                //                    swipeview.currentIndex-=1
                //                    swipeview.setCurrentIndex(swipeview.currentIndex-1)
                swipeview.decrementCurrentIndex()
                swipeViewFocus=true
            }
        }
    }
    Button{
        id:nextBtn
        width:60
        height:100
        anchors.right:parent.right

        anchors.verticalCenter: swipe.verticalCenter
        visible: {
            if(swipeview.contentItem.moving==true)
                return false
            return swipeview.currentIndex===(swipeview.count-1)?false:true
        }
        background:Image{
            asynchronous:true
            smooth:false
            anchors.centerIn: parent
            source: themesImagesPath+"nextpage-background.png"
        }
        onClicked:{
//            console.log('nextBtn',swipeview.currentIndex)
            if(swipeview.currentIndex < swipeview.count){
                //                    swipeview.currentIndex+=1
                //                    swipeview.setCurrentIndex(swipeview.currentIndex+1)
                swipeview.incrementCurrentIndex()
                swipeViewFocus=true
            }
        }
    }
    PageHomeBar {
        id:homeBar
        anchors.bottom: parent.bottom
    }
}
