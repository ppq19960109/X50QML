import QtQuick 2.7
import QtQuick.Controls 2.2

import "pageMain"
import "WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
Item {
    property var lStOvState: QmlDevState.state.LStOvState
    property var rStOvState: QmlDevState.state.RStOvState
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
        id:component_updateConfirm
        PageDialogConfirm{
            hintTopText:"系统更新"
            hintCenterText:"检测到最新版本 "+QmlDevState.state.OTANewVersion+"\n请问是否立即更新?"
            cancelText:"取消"
            confirmText:"升级"
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

    function steamInterfaceChange(state){
        if(state==false)
        {
            if(isExistView("PageSteaming")!=null)
            {
                let page=isExistView("PageSteamOven")
                if(page==null)
                    backTopPage()
                else
                    backPage(page)
            }
        }
        else
        {
            if(isExistView("PageSteaming")==null)
            {
                if(isExistView("PageSteamOvenConfig")!=null||isExistView("PageMultistage")!=null)
                    push_page(pageSteaming)
            }
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onLocalConnectedChanged:{
            console.log("page home onLocalConnectedChanged",value)
            if(value > 0)
            {
                loaderErrorHide()

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
                //                push_page("pageTestFront")
            }
            else
            {
                loaderErrorShow("通讯板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false)
                standbyWakeup()
            }
        }
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page home onStateChanged",key,value)
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
                if(value===workStateEnum.WORKSTATE_STOP)
                {
                    if(rStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        steamInterfaceChange(false)
                    }
                }
                else
                {
                    steamInterfaceChange(true)
                }

                if(value===workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastLStOvState!=value && lastLStOvState>=0)
                {
                    if(value===workStateEnum.WORKSTATE_PAUSE||value===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        if(QmlDevState.state.LStOvDoorState===1)
                            loaderDoorAutoShow("左腔门打开，暂停烹饪","","好的",cookWorkPosEnum.LEFT)
                    }
                    else
                    {
                        if(QmlDevState.state.LStOvDoorState===0)
                        {
                            if(value===workStateEnum.WORKSTATE_STOP)
                                loaderDoorAutoHide(cookWorkPosEnum.LEFT)
                        }
                    }
                }
                lastLStOvState=value
            }
            else if("LStOvDoorState"==key)
            {
                if(value==0)
                {
                    if(lStOvState===workStateEnum.WORKSTATE_PAUSE||lStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                        loaderDoorAutoShow("左腔门已关闭，是否继续烹饪？","结束烹饪","继续烹饪",cookWorkPosEnum.LEFT)
                }
            }
            else if("RStOvState"==key)
            {
                if(value===workStateEnum.WORKSTATE_STOP)
                {
                    if(lStOvState===workStateEnum.WORKSTATE_STOP)
                    {
                        steamInterfaceChange(false)
                    }
                }
                else
                {
                    steamInterfaceChange(true)
                }
                if(value===workStateEnum.WORKSTATE_RUN)
                    sleepWakeup()

                if(lastRStOvState!=value && lastRStOvState>=0)
                {
                    if(value===workStateEnum.WORKSTATE_PAUSE||value===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        if(QmlDevState.state.RStOvDoorState===1)
                            loaderDoorAutoShow("右腔门打开，暂停烹饪","","好的",cookWorkPosEnum.RIGHT)
                    }
                    else
                    {
                        if(QmlDevState.state.RStOvDoorState===0)
                        {
                            if(value===workStateEnum.WORKSTATE_STOP)
                                loaderDoorAutoHide(cookWorkPosEnum.RIGHT)
                            else
                                loaderDoorAutoShow("右腔门已关闭，是否继续烹饪？","结束烹饪","继续烹饪",cookWorkPosEnum.RIGHT)
                        }
                    }
                }
                lastRStOvState=value
            }
            else if("RStOvDoorState"==key)
            {
                if(value==0)
                {
                    if(rStOvState===workStateEnum.WORKSTATE_PAUSE||rStOvState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                        loaderDoorAutoShow("右腔门已关闭，是否继续烹饪？","结束烹饪","继续烹饪",cookWorkPosEnum.RIGHT)
                }
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
                console.log("ErrorCodeShow:",value)
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
                console.log("WifiEnable",value)
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
                    wifiConnecting=false
                    if(value==2 || value==3||value==5)
                    {
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
                }
                console.log("WifiState",value,wifiConnected,wifiConnecting)
            }
            else if("ssid"==key)
            {
                if(wifiConnected==true && wifiConnectInfo.ssid!="")
                {
                    var real_ssid
                    if(pattern.test(wifiConnectInfo.ssid))
                    {
                        real_ssid=decodeURI(value.replace(/\\x/g,'%'))
                    }
                    else
                    {
                        real_ssid=value
                    }
                    if(real_ssid==wifiConnectInfo.ssid)
                    {
                        WifiFunc.addWifiInfo(wifiConnectInfo)
                        QmlDevState.executeShell("(wpa_cli list_networks | tail -n +3 | grep "+value+" | grep -v 'CURRENT' | awk '{system(\"wpa_cli remove_network \" $1)}' && wpa_cli save_config) &")
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
                    push_page("pageTestFront")
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
                console.log("OTAProgress:",value)
                loaderUpdateProgress(value);
                if(value==100)
                {
                }
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
                if(value>0)
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
                        push_page("pageDemoMode")
                }
            }
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
            //            console.log("result:",QmlDevState.state.bssid,element.bssid,element.rssi,result.connected,result.ssid,result.level,result.flags)
        }

        if(bssid==="")
        {
            console.log("setWifiList:",wifiConnected,bssid)
            //            wifiConnected=false
        }
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
                    loaderMainHide()
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
        loader_main.sourceComponent = component_burn_wifi
    }
    function getQuadScanWifi()
    {
        console.log("getQuadScanWifi",productionTestFlag)
        SendFunc.scanWifi()
        timer_scanwifi.restart()
    }

    function parseWifiList()
    {
        var i
        for( i = 0; i < wifiModel.count; ++i) {
            if(wifiModel.get(i).ssid==productionTestWIFISSID)//productionTestWIFISSID
            {
                wifiModel.setProperty(0,"connected",0)
                wifiModel.setProperty(i,"connected",2)
                wifiModel.move(i,0,1)
                break
            }
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
        push_page("pageGetQuad")
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
        //        loaderAutoPopupShow("","右灶定时关火结束，\n请将旋钮复位",292,"",null,false)
        //        loaderUpdateConfirmShow()
        //       loaderUpdateResultShow("系统已更新至最新版本\n"+"1.2.0")
    }
    StackView.onActivating:{
        console.log("PageHome StackView onActivating")
    }

    Item{
        anchors.fill:parent
        Row {
            width: 292*3+100
            height: 360
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: 50
            Repeater {
                model: [{"background":"home_hood_background.png","text1":"烟机灶具","text2":"HOOD"}, {"background":"home_steamoven_background.png","text1":"蒸烤箱","text2":"STEAM OVEN"},{"background":"home_smartrecipes_background.png","text1":"智慧菜谱","text2":"SMART RECIPES"}]
                Button{
                    width: 292
                    height:parent.height

                    background:Image {
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+modelData.background
                    }
                    Text{
                        text:modelData.text1
                        color:"#fff"
                        font.pixelSize: 40
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 45
                        Text{
                            text:modelData.text2
                            color:"#C3C2C2"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            anchors.topMargin: 10
                            anchors.left: parent.left
                        }
                    }
                    onClicked: {
                        switch (index){
                        case 0:
                            push_page(pageHood)
                            break
                        case 1:
                            push_page(pageSteamOven)
                            break
                        case 2:
                            push_page(pageSmartRecipes)
                            break
                        }
                    }
                }
            }

        }
    }

}
