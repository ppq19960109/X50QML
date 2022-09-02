import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0
//import QtQuick.Window 2.2

import "pageCook"
import "pageMain"
import "pageSet"
import "pageProductionTest"

import "qrc:/SendFunc.js" as SendFunc

ApplicationWindow {
    id: window
    width: 1280
    height: 400
//    visible: true
    property int sysPower:-1
    property int productionTestStatus:0
    property int productionTestFlag:1
    property int demoModeStatus:0
    property bool wifiPageStatus:false
    property bool errorBuzzer:false
    property bool testMode:false
    property var decode_ssid:""

    property var smartSmokeSwitch: QmlDevState.state.SmartSmokeSwitch
    property var hoodSpeed: QmlDevState.state.HoodSpeed
    property var lTimingState: QmlDevState.state.LStoveTimingState
    property var rTimingState: QmlDevState.state.RStoveTimingState
    property var lStOvState: QmlDevState.state.LStOvState
    property var rStOvState: QmlDevState.state.RStOvState
    property var errorCodeShow: QmlDevState.state.ErrorCodeShow
    property var auxiliarySwitch: QmlDevState.state.RAuxiliarySwitch

    readonly property string productionTestWIFISSID:"moduletest"
    readonly property string productionTestWIFIPWD:"58185818"

    readonly property var cookWorkPosEnum:{"LEFT":0,"RIGHT":1,"ALL":2,"ASSIST":3}
    readonly property var cookModeUncheckedImg: ["icon_steame_unchecked.png","icon_bake_unchecked.png","icon_multistage_unchecked.png"]
    readonly property var cookModecheckedImg: ["icon_steame_checked.png","icon_bake_checked.png","icon_multistage_checked.png"]
    readonly property var workModeEnum: ["未设定", "经典蒸", "鲜嫩蒸", "高温蒸", "热风烧烤", "上下加热", "立体热风", "蒸汽嫩烤", "空气炸", "解冻","发酵","保温"]
    readonly property var workModeNumberEnum:[0,1,3,4,35,36,38,40,42,65,66,68]

    readonly property var leftWorkModeModelEnum:[{"modelData":7,"temp":150,"time":60,"minTemp":50,"maxTemp":200},{"modelData":4,"temp":200,"time":60,"minTemp":50,"maxTemp":230},{"modelData":8,"temp":220,"time":30,"minTemp":200,"maxTemp":230,"maxTime":180},{"modelData":3,"temp":120,"time":20,"minTemp":101,"maxTemp":120},{"modelData":5,"temp":180,"time":120,"minTemp":50,"maxTemp":230}
        ,{"modelData":6,"temp":180,"time":120,"minTemp":50,"maxTemp":230}]
    readonly property var rightWorkModeModelEnum:[{"modelData":1,"temp":100,"time":30,"minTemp":40,"maxTemp":100},{"modelData":3,"temp":120,"time":20,"minTemp":101,"maxTemp":120},{"modelData":2,"temp":90,"time":15,"minTemp":80,"maxTemp":100}]
    readonly property var rightAssistWorkModeModelEnum:[{"modelData":10,"temp":35,"time":60,"minTemp":30,"maxTemp":50},{"modelData":9,"temp":40,"time":30,"minTemp":30,"maxTemp":50},{"modelData":11,"temp":60,"time":60,"minTemp":50,"maxTemp":105}]

    readonly property var workStateEnum:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5,"WORKSTATE_PAUSE_RESERVE":6}
    readonly property var workStateChineseEnum:["停止","预约中","预热中","运行中","烹饪完成","暂停中","预约暂停中"]
    readonly property var workOperationEnum:{"START":0,"PAUSE":1,"CANCEL":2,"CONFIRM":3,"RUN_NOW":4}

    readonly property var timingStateEnum:{"STOP":0,"RUN":1,"PAUSE":2,"CONFIRM":3}
    readonly property var timingOperationEnum:{"START":1,"CANCEL":2}
    property bool wifiConnecting: false
    property bool wifiConnected:false
    property bool sleepState: false
    property var wifiConnectInfo:{"ssid":"","psk":"","encryp":0}
    readonly property var multiModeEnum:{"NONE":0,"RECIPE":1,"MULTISTAGE":2}
    readonly property var buzControlEnum:{"STOP":0,"SHORT":1,"SHORTTWO":2,"SCECONDS2":3,"OPEN":4,"SHORTFIVE":5}

    readonly property string themesPicturesPath:"file:themes/X8GCZ/"
    readonly property string themesWindowBackgroundColor:"#1A1A1A"
    readonly property string themesPopupWindowColor:"#333333"
    readonly property string themesTextColor:"#E68855"
    readonly property string themesTextColor2:"#A2A2A2"

    property var pattern: new RegExp("[\u4E00-\u9FA5]+")
    property var screenSaverInfo:{"month":"","date":"","hours":"","minutes":"","temp":"","lowTemp":"","highTemp":"","weatherId":0,"weather":"","holiday":""}
    readonly property var weeksEnum:["日","一","二","三","四","五","六"]
    readonly property var weatherEnum:["晴","阴","多云","大雨","中雨","小雨","雷雨","大风","雪","雾","雨夹雪"]

    property int timeSync:0
    property int gYear
    property int gMonth
    property int gDate
    property int gDay
    property int gHours
    property int gMinutes
    property string gHoliday
    property int gTemp
    property int gLowTemp
    property int gHighTemp
    property string gWeatherId

    property int gTimerTotalTime:0
    property int gTimerLeft:0

    property string gTimerLeftText:generateTwoTime(Math.floor(gTimerLeft/3600))+":"+generateTwoTime(Math.floor(gTimerLeft%3600/60))+":"+generateTwoTime(gTimerLeft%60)
    property string gTimeText:generateTwoTime(gHours)+":"+generateTwoTime(gMinutes)
    Settings {
        id: testSettings
        category: "test"
        property int productionTestLcd:0
        property int productionTestLight:0
        property int productionTestAging:0
        property int productionTestTouch:0
        onProductionTestLcdChanged:{
            if(productionTestStatus>0)
                systemSync()
        }
        onProductionTestLightChanged:{
            if(productionTestStatus>0)
                systemSync()
        }
        onProductionTestAgingChanged:{
            if(productionTestStatus>0)
                systemSync()
        }
        onProductionTestTouchChanged:{
            if(productionTestStatus>0)
                systemSync()
        }
    }
    Settings {
        id: systemSettings
        category: "system"
        property bool firstStartup: true
        //设置-休眠时间(范围:1-5,单位:分钟 )
        property bool sleepSwitch: true
        property int sleepTime: 3
        property int screenSaverIndex:0
        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 250
        property bool wifiEnable: false
        property bool reboot: false
        property var cookDialog:[true,true,true,true,true,true,true]
        property bool multistageRemind:true
        property bool rMovePotLowHeatRemind:true
        property var wifiPasswdArray:[]
        property bool otaSuccess:false

        onBrightnessChanged: {
            console.log("onBrightnessChanged...",systemSettings.brightness)
            Backlight.backlightSet(systemSettings.brightness)
        }
        onSleepTimeChanged: {
            console.log("onSleepTimeChanged...",systemSettings.sleepTime)
            timer_sleep.interval=systemSettings.sleepTime*60000
            timer_sleep.restart()
        }
    }
    function systemSync()
    {
        QmlDevState.executeShell("(sleep 2;sync) &")
    }
    function generateTwoTime(time)
    {
        return time<10?("0"+time):time
    }

    function systemReset()
    {
        var Data={}
        Data.reset = null
        Data.LocalOperate = 0xa4
        SendFunc.setToServer(Data)

        systemSettings.sleepTime=3
        systemSettings.brightness=200

        systemSettings.wifiEnable=true
        systemSettings.sleepSwitch=true
        systemSettings.screenSaverIndex=0
        systemSettings.cookDialog=[true,true,true,true,true,true,true]
        systemSettings.multistageRemind=true
        systemSettings.wifiPasswdArray=[]
        systemSync()
    }
    function closeHeatShortTime()
    {
        let lStoveTimingLeft=QmlDevState.state.LStoveTimingLeft
        let rStoveTimingLeft=QmlDevState.state.RStoveTimingLeft
        let timingTime
        if(lStoveTimingLeft>0 && rStoveTimingLeft>0)
            timingTime=lStoveTimingLeft > rStoveTimingLeft ? rStoveTimingLeft : lStoveTimingLeft
        else if(lStoveTimingLeft>0)
            timingTime=lStoveTimingLeft
        else if(rStoveTimingLeft>0)
            timingTime=rStoveTimingLeft
        return  generateTwoTime(Math.floor(timingTime/60))+":"+generateTwoTime(timingTime%60)
    }

    function systemPower(power){
        console.log("systemPower",power)

        if(sysPower===power || (productionTestStatus>0 && power===0))
        {
            return
        }
        loaderScreenSaverHide()
        if(power)
        {
            Backlight.backlightSet(systemSettings.brightness)
            timer_sleep.restart()
        }
        else
        {
            gTimerLeft=0
            Backlight.backlightSet(0)
            timer_sleep.stop()
            loaderMainHide()
            if(productionTestFlag==0 && timer_standby.running==true)
                timer_standby.stop()
            backTopPage()
        }
        if(window.visible==false)
            window.visible=true
        sysPower=power
    }

    Component.onCompleted: {
        console.warn("Window onCompleted: ",Qt.fontFamilies())

        //        var pattern = new RegExp("[\u4E00-\u9FA5]+")
        //        var str='\\xE6\\x95\\xB0\\xE6\\x8D\\xae'
        //        console.warn("Window onCompleted1: ",str,str.replace('\\x','%'),decodeURI(str.replace(/\\x/g,'%')))
        //                console.warn("Window onCompleted test: ",encodeURI("a1数b2据C3"),encodeURIComponent("a1数b2据C3"),decodeURI("a1%E6%95%B0b2%E6%8D%AEC3"),decodeURIComponent("a1%E6%95%B0b2%E6%8D%AEC3"),pattern.test("数据a1"),pattern.test("adwe445-._"))

        push_page(pageHome)
        //                push_page(pageTestFront)
        //        push_page(pageDemoMode)
        //push_page(pageGetQuad)
        if(systemSettings.wifiPasswdArray!=null)
        {
            console.log("systemSettings.wifiPasswdArray",systemSettings.wifiPasswdArray.length)
            var element
            for(var i = 0; i < systemSettings.wifiPasswdArray.length; ++i)
            {
                element=systemSettings.wifiPasswdArray[i]
                console.log("ssid:",element.ssid)
                console.log("psk:",element.psk)
                console.log("encryp:",element.encryp)
            }
        }
        if(systemSettings.brightness<1 || systemSettings.brightness>255)
        {
            systemSettings.brightness=200
        }
        getCurrentTime(1640966400)
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: MNetwork
        onReplyLocationData:{
            console.log("onReplyLocationData",value)
            if(value=="")
                return

            var resp=JSON.parse(value)
            if(resp.code!==200)
                return
            ++timeSync
            gTemp=resp.data.temp
            gLowTemp=resp.data.lowTemp
            gHighTemp=resp.data.highTemp
            gWeatherId=resp.data.weatherId
            //            MNetwork.weatherRequest(resp.data.cityName);//杭州
        }
        onReplyTimeData:{
            console.log("onReplyTimeData",value)
            if(value=="")
                return
            var resp=JSON.parse(value)
            if(resp.code!==200)
                return
            ++timeSync
            gHoliday=resp.data.holiday
        }
        onReplyWeatherData:{
            console.log("onReplyWeatherData",value)
            if(value=="")
                return
            var resp=JSON.parse(value);
            gTemp=resp.current_condition[0].temp_C
            gLowTemp=resp.weather[0].mintempC
            gHighTemp=resp.weather[0].maxtempC
        }
    }
    function getCurrentTime(ms)
    {
        var date
        if(ms==null)
        {
            date=new Date()
        }
        else
        {
            date=new Date(ms*1000)
        }
        gYear=date.getFullYear()
        gMonth=date.getMonth()+1
        gDate=date.getDate()
        gDay=date.getDay()
        gHours=date.getHours()
        gMinutes=date.getMinutes()
        //        console.log("getCurrentTime",ms,gYear,gMonth,gDate,gDay,gHours,gMinutes)
    }

    Timer{
        id:timer_time
        repeat: true
        running: true
        interval: 20000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_time onTriggered")
            getCurrentTime()
            if(gHours==0)
            {
                if(gMinutes==0||gMinutes==5)
                    timeSync=0
            }

            if(timeSync>=2)
            {
                ++timeSync
                if(timeSync>60*3)
                    timeSync=0
            }
            if(timeSync<2)
            {
                if(wifiConnected)
                {
                    if(timer_time.interval==20000)
                    {
                        console.log("time onTriggered interval:",timer_time.interval)
                        timer_time.interval=60000
                    }

                    MNetwork.locationRequest()
                    MNetwork.timeRequest()
                }
                //                SendFunc.makeRequest()
            }
        }
    }

    function sleepStandby()
    {
        if(sleepState==true && QmlDevState.state.LStoveStatus === 0 && QmlDevState.state.RStoveStatus === 0 && QmlDevState.state.HoodSpeed == 0 && QmlDevState.state.HoodLight === 0 && QmlDevState.state.LStoveTimingState===timingStateEnum.STOP && QmlDevState.state.RStoveTimingState===timingStateEnum.STOP)
        {
            if((QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_STOP || QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_FINISH) && (QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_STOP || QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_FINISH))
            {
                SendFunc.setBuzControl(buzControlEnum.SHORTTWO)
                SendFunc.setSysPower(0)
                return 0
            }
        }
        return -1
    }

    Timer{
        id:timer_auxiliary
        repeat: false
        running: false
        interval: 1000*60*10
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_auxiliary onTriggered")
            if(auxiliarySwitch===0)
                return
            var Data={}
            Data.RAuxiliarySwitch = 0
            SendFunc.setToServer(Data)
            loaderAutoTextShow("长时间未开启右灶，已自动取消右灶控温")
        }
    }
    Timer{
        id:timer_standby
        repeat: false
        running: true
        interval: 180000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_standby onTriggered",productionTestFlag)
            if(productionTestFlag>0)
            {
                productionTestFlag=0
            }
            else
            {
                if(sleepStandby()===0)
                    return
                timer_standby.interval=8*60000
                timer_standby.restart()
            }
        }
    }

    Timer{
        id:timer_wifi_connecting
        repeat: false
        running: false
        interval: 62000
        triggeredOnStart: false
        onTriggered: {
            if(wifiConnecting==true)
            {
                console.log("timer_wifi_connecting...")
                //                wifiConnecting=false
                //                QmlDevState.executeShell("(wpa_cli reconfigure) &")
            }
        }
    }

    function screenSleep()
    {
        sleepState=true
        loaderScreenSaverShow()

        productionTestFlag=0
        timer_standby.interval=10*60000
        timer_standby.restart()
    }

    Timer{
        id:timer_sleep
        repeat: false
        running: systemSettings.sleepSwitch && sysPower == 1
        interval: systemSettings.sleepTime*60000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_sleep onTriggered...")
            if(productionTestStatus==0 && demoModeStatus==0 && wifiConnecting==false && QmlDevState.localConnected > 0 && errorCodeShow === 0)
            {
                if((QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_STOP || QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_FINISH || QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_RESERVE || QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_PAUSE_RESERVE) && (QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_STOP || QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_FINISH || QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_RESERVE || QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_PAUSE_RESERVE ))
                {
                    screenSleep()
                    return
                }
            }
            sleepState=false
            timer_sleep.restart()
        }
    }
    Timer{
        id:timer_alarm
        repeat: gTimerLeft > 0
        running: gTimerLeft > 0
        interval: 2000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_alarm onTriggered...")
            if(gTimerLeft>0)
                gTimerLeft-=2
            if(gTimerLeft<=0)
            {
                gTimerLeft=0
                if(loaderManual.sourceComponent === pageTimer)
                    loaderManual.sourceComponent = null
                if(sleepState==true)
                    loaderScreenSaverHide()
                loaderAutoTimerShow("时间到！计时结束")
            }
        }
    }
    background:Image {
        source: themesPicturesPath+"window-background.png"
    }
    StackView {
        id: stackView
        //initialItem: pageTestFront // pageHome pageTestFront pageTest pageGetQuad
        width: 1160
        height: parent.height
        anchors.left: parent.left
    }
    PageHomeBar{
        anchors.left: stackView.right
        anchors.right: parent.right
    }

    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loaderStackView
        anchors.fill: stackView
        sourceComponent:null
    }
    Loader{
        //加载弹窗组件
        id:loaderManual
        anchors.fill: parent
        sourceComponent:null
    }
    function loaderMainHide(){
        loaderManual.sourceComponent = null
    }
    function loaderCookReserve(cookWorkPos,cookItem)
    {
        loaderManual.sourceComponent = pageReserve
        loaderManual.item.cookWorkPos=cookWorkPos
        loaderManual.item.cookItem=cookItem
    }

    Component{
        id:component_steam
        PageDialog{
            cancelText:"取消"
            checkboxVisible:true
            onCancel:{
                loaderSteamHide()
            }
            onConfirm:{
                if(checkboxChecked)
                {
                    var dialog=systemSettings.cookDialog
                    dialog[cookDialogIndex]=false
                    systemSettings.cookDialog=dialog
                }
                if(cookItem!=null)
                    startCooking(cookItem,JSON.parse(cookItem.cookSteps))
                loaderSteamHide()
            }
        }
    }
    function loaderSteamShow(hintCenterText,confirmText,cookItem,cookDialogIndex){
        loaderManual.sourceComponent = component_steam

        loaderManual.item.hintCenterText=hintCenterText
        loaderManual.item.confirmText=confirmText
        loaderManual.item.cookItem=cookItem
        loaderManual.item.cookDialogIndex=cookDialogIndex
    }
    function loaderSteamHide(){
        if(loaderManual.sourceComponent===component_steam)
            loaderManual.sourceComponent = undefined
    }


    Component{
        id:component_qrcode
        PageDialogQrcode{
            onCancel: {
                loaderQrcodeHide()
            }
        }
    }
    function loaderQrcodeShow(title,hint){
        if(QmlDevState.state.DeviceSecret==="")
        {
            loaderErrorConfirmShow("四元组不存在")
            return
        }
        if(wifiConnected==true)
        {
            loaderManual.sourceComponent = component_qrcode
            loaderManual.item.hintTopText=title
            if(hint==null)
                loaderManual.item.hintCenterText="下载火粉APP   绑定设备\n海量智慧菜谱  一键烹饪"
            else
                loaderManual.item.hintCenterText=hint
        }
        else
        {
            loaderWifiConfirmShow("当前设备离线，请检查网络")
        }
    }
    function loaderQrcodeHide(){
        if(loaderManual.sourceComponent===component_qrcode)
            loaderManual.sourceComponent = undefined
    }

    Component{
        id:component_warnManual
        PageDialogConfirm{
            onCancel: {
                loaderMainHide()
            }
            onConfirm:{
                loaderMainHide()
            }
        }
    }
    function loaderWarnManualShow(text,cancelText,confirmText,topImageSrc){
        if(loaderManual.sourceComponent !== component_warnManual)
        {
            loaderManual.sourceComponent = component_warnManual
        }
        loaderManual.item.topImageSrc=topImageSrc
        loaderManual.item.hintCenterText=text
        loaderManual.item.cancelText=cancelText
        loaderManual.item.confirmText=confirmText
    }
    function loaderWarnConfirmShow(text){
        loaderWarnManualShow(text,"","好的",themesPicturesPath+"icon_warn.png")
    }
    function loaderErrorConfirmShow(text){
        loaderWarnManualShow(text,"","好的",themesPicturesPath+"icon_error.png")
    }
    function loaderWifiConfirmShow(text){
        loaderWarnManualShow(text,"","好的",themesPicturesPath+"icon_wifi_warn.png")
    }
    Component{
        id:component_loading
        PageLoadingPopup{
            hintText:""
            onCancel: {
                loaderManual.sourceComponent = undefined
            }
        }
    }
    function loaderLoadingShow(text,closeVisible){
        loaderManual.sourceComponent = component_loading
        loaderManual.item.hintText=text
        loaderManual.item.closeVisible=closeVisible
    }

    Loader{
        //加载弹窗组件
        id:loaderAuto
        anchors.fill: parent
        sourceComponent:null
    }
    function loaderAutoHide(){
        loaderAuto.sourceComponent = null
    }
    Component{
        id:component_autoConfirm
        PageDialogConfirm{
            confirmText:""
            onCancel: {
                loaderAutoHide()
            }
            onConfirm:{
                loaderAutoHide()
            }
        }
    }
    function loaderAutoConfirmShow(hintCenterText,cancelText,confirmText,topImageSrc){
        if(loaderAuto.sourceComponent !== component_autoConfirm)
            loaderAuto.sourceComponent = component_autoConfirm
        loaderAuto.item.topImageSrc=topImageSrc
        loaderAuto.item.hintCenterText=hintCenterText
        loaderAuto.item.confirmText=cancelText
        loaderAuto.item.confirmText=confirmText
    }
    function loaderAutoTextShow(text){
        loaderAutoConfirmShow(text,"","好的",themesPicturesPath+"icon_warn.png")
    }
    function loaderAutoCompleteShow(text){
        loaderAutoConfirmShow(text,"","好的",themesPicturesPath+"icon_checked.png")
    }
    function loaderAutoConfirmHide(){
        if(loaderAuto.sourceComponent === component_autoConfirm)
            loaderAuto.sourceComponent = null
    }
    function loaderStoveAutoPopupHide(text){
        if(loaderAuto.sourceComponent === component_autoConfirm)
        {
            if(loaderAuto.item.hintCenterText.indexOf(text)!==-1)
                loaderAuto.sourceComponent = null
        }
    }
    Component{
        id:component_autoTimer
        PageDialogConfirm{
            confirmText:""
            onCancel: {
                loaderAutoHide()
            }
            onConfirm:{
                loaderAutoHide()
            }
            Component.onCompleted: {
                SendFunc.setBuzControl(buzControlEnum.OPEN)
            }
            Component.onDestruction: {
                SendFunc.setBuzControl(buzControlEnum.STOP)
            }
            Timer{
                repeat: false
                running: true
                interval: 1000*60
                triggeredOnStart: false
                onTriggered: {
                    SendFunc.setBuzControl(buzControlEnum.STOP)
                }
            }
        }
    }
    function loaderAutoTimerShow(text){
        if(loaderAuto.sourceComponent !== component_autoTimer)
            loaderAuto.sourceComponent = component_autoTimer
        loaderAuto.item.topImageSrc=themesPicturesPath+"icon_timer.png"
        loaderAuto.item.hintCenterText=text
        loaderAuto.item.confirmText=""
        loaderAuto.item.confirmText="好的"
    }
    Component{
        id:component_doorAuto
        PageDialogConfirm{
            onCancel: {
                if(cancelText!="")
                {
                    SendFunc.setCookOperation(cookWorkPos,workOperationEnum.CANCEL)
                }
                loaderAutoHide()
            }
            onConfirm:{
                if(cancelText!="")
                {
                    SendFunc.setCookOperation(cookWorkPos,workOperationEnum.START)
                }
                loaderAutoHide()
            }
            Component.onCompleted: {
                SendFunc.setBuzControl(buzControlEnum.OPEN)
            }
            Component.onDestruction: {
                SendFunc.setBuzControl(buzControlEnum.STOP)
            }
        }
    }
    function loaderDoorAutoShow(text,cancelText,confirmText,cookWorkPos){
        if(loaderAuto.sourceComponent !== component_doorAuto)
        {
            loaderAuto.sourceComponent = component_doorAuto
        }
        loaderAuto.item.hintCenterText=text
        loaderAuto.item.cancelText=cancelText
        loaderAuto.item.confirmText=confirmText
        loaderAuto.item.cookWorkPos=cookWorkPos
    }
    function loaderDoorAutoHide(cookWorkPos){
        if(loaderAuto.sourceComponent === component_doorAuto)
        {
            if(loaderAuto.item.cookWorkPos===cookWorkPos)
                loaderAuto.sourceComponent = null
        }
    }
    Component{
        id:component_hoodoff
        PageDialogConfirm{
            hintCenterText:"灶具已关闭，烟机将延时<br/><b><font color='#E68855'>"+QmlDevState.state.HoodOffLeftTime+"分钟</font></b>后关闭，清除余烟"
            cancelText:"好的"
            confirmText:"立即关闭("+QmlDevState.state.HoodOffLeftTime+"分钟)"
            confirmBtnWidth:130
            onCancel: {
                loaderAutoHide()
            }
            onConfirm:{
                SendFunc.setHoodSpeed(0)
                loaderAutoHide()
            }
        }
    }

    function showLoaderHoodOff(){
        loaderAuto.sourceComponent = component_hoodoff
    }
    function closeLoaderHoodOff(){
        if(loaderAuto.sourceComponent === component_hoodoff)
        {
            loaderAuto.sourceComponent = null
        }
    }

    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loader_error
        anchors.fill: parent
        sourceComponent:null
    }

    function loaderErrorShow(hintTopText,hintBottomText,closeVisible){
        if(loader_error.source !== "PageErrorPopup.qml")
            loader_error.source = "PageErrorPopup.qml"

        loader_error.item.hintTopText=hintTopText
        loader_error.item.hintBottomText=hintBottomText
        loader_error.item.closeVisible=closeVisible==null?true:closeVisible
        errorBuzzer=false
        //        loader_error.setSource("PageErrorPopup.qml",{"hintTopText": hintTopText,"hintBottomText": hintBottomText,"closeVisible": closeVisible})
    }
    function loaderErrorHide(){
        if(loader_error.source != "")
            loader_error.source = ""
    }
    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loaderScreenSaver
        asynchronous: true
        anchors.fill: parent
        sourceComponent:null
    }
    function loaderScreenSaverShow()
    {
        loaderScreenSaver.source=systemSettings.screenSaverIndex==0?"PageScreenSaver0.qml":"PageScreenSaver1.qml"
    }
    function loaderScreenSaverHide(){
        if(loaderScreenSaver.source != "")
            loaderScreenSaver.source = ""
    }

    MouseArea{
        anchors.fill: parent
        propagateComposedEvents: true

        onPressed: {
            console.log("Window onPressed:",sysPower)
            if(sysPower > 0)
            {
                mouse.accepted = false
                timer_sleep.restart()

                if(sleepState==true)
                {
                    if(productionTestFlag==0 && timer_standby.running==true)
                        timer_standby.stop()

                    sleepState=false
                    loaderScreenSaverHide()
                    mouse.accepted = true
                }
            }
            else
            {
                SendFunc.setSysPower(1)
                mouse.accepted = true
            }
        }
    }

    function standbyWakeup(){
        systemPower(2)
    }
    function sleepWakeup(){
        if(sysPower > 0 && sleepState==true)
        {
            sleepState=false
            if(productionTestFlag==0 && timer_standby.running==true)
                timer_standby.stop()

            loaderScreenSaverHide()
            timer_sleep.restart()
        }
    }
    ListModel {
        id: wifiModel
        //        ListElement {
        //            connected: 1
        //            ssid: "qwertyuio"
        //            level:2
        //            flags:2
        //        }
        //        ListElement {
        //            connected: 0
        //            ssid: "123456789123456789123456789"
        //            level:2
        //            flags:1
        //        }
        //        ListElement {
        //            connected: 0
        //            ssid: "123"
        //            level:2
        //            flags:0
        //        }
        //        ListElement {
        //            connected: 0
        //            ssid: "gttr"
        //            level:2
        //            flags:1
        //        }
        //        ListElement {
        //            connected: 0
        //            ssid: "daaas"
        //            level:2
        //            flags:0
        //        }
    }
    //    Component {
    //        id: pageTest
    //        Item {
    //            SwipeView {
    //                id: swipeview
    //                anchors.fill: parent
    //                currentIndex:0

    //                interactive:true //是否可以滑动
    //                //                Item {Image{source: "file:x5/方案一/1.png" }}
    //                //                Item {Image{source: Qt.resolvedUrl("/test/images/x5/方案一/2.png")}}
    //                //                Item {Image{source: "/test/x5/上下排版/1.png" }}
    //                Repeater {
    //                    id: repeater
    //                    model: Backlight.getAllFileName("testPictures")
    //                    Item {
    //                        Image{
    //                            source: "file:"+modelData
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    Component {
        id: pageTimer
        PageTimer {}
    }
    Component {
        id: pageHome
        PageHome {}
    }
    Component {
        id: pageHood
        PageHood {}
    }
    Component {
        id: pageSteamOven
        PageSteamOven {}
    }
    Component {
        id: pageSteamOvenConfig
        PageSteamOvenConfig {}
    }
    Component {
        id: pageSteaming
        PageSteaming {}
    }
    Component {
        id: pageWifi
        PageWifi {}
    }
    Component {
        id: pageMultistage
        PageMultistage {}
    }
    Component {
        id: pageSmartRecipes
        PageSmartRecipes {}
    }
    Component {
        id: pageCookDetails
        PageCookDetails {}
    }

    Component {
        id: pageCloseHeat
        PageCloseHeat {}
    }
    Component {
        id: pageSmartCook
        PageSmartCook {}
    }
    Component {
        id: pageSet
        PageSet {}
    }
    Component {
        id: pageReserve
        PageReserve {}
    }
    Component {
        id: pageTestFront
        PageTestFront {}
    }
    Component {
        id: pageIntelligentDetection
        PageIntelligentDetection {}
    }
    Component {
        id: pageScreenTest
        PageScreenTest {}
    }
    Component {
        id: pageScreenLine
        PageScreenLine {}
    }
    Component {
        id: pageScreenClick
        PageScreenClick {}
    }
    Component {
        id: pageScreenLCD
        PageScreenLCD {}
    }
    Component {
        id: pageScreenLight
        PageScreenLight {}
    }
    Component {
        id: pageScreenTouch
        PageScreenTouch {}
    }
    Component {
        id: pageAgingTest
        PageAgingTest {}
    }
    Component {
        id: pageGetQuad
        PageGetQuad {}
    }
    Component {
        id: pagePowerBoard
        PagePowerBoard {}
    }
    Component {
        id: pagePowerOut
        PagePowerOut {}
    }
    Component {
        id: pagePowerInput
        PagePowerInput {}
    }
    Component {
        id: pageDemoMode
        PageDemoMode {}
    }
    function isExistView(pageName) {
        return stackView.find(function(item,index){
            return item.name === pageName
        })
    }

    function backPrePage() {
        if(stackView.depth>0)
            stackView.pop(StackView.Immediate)
        console.log("backPrePage stackView depth:"+stackView.depth)
    }

    function backTopPage() {
        stackView.pop(null,StackView.Immediate)
        console.log("backTopPage stackView depth:"+stackView.depth)
    }

    function backPage(page) {
        if(stackView.depth>0)
            stackView.pop(page,StackView.Immediate)
        console.log("backPage stackView depth:"+stackView.depth)
    }
    function replace_page(page,args) {
        if(stackView.depth>0)
            stackView.replace(page,args,StackView.Immediate)
        console.log("replace_page stackView depth:"+stackView.depth)
    }

    function push_page(page,args) {
        //        console.log("args:"+args)
        stackView.push(page,args,StackView.Immediate)
        console.log("push_page stackView depth:"+stackView.depth)
    }
    //获取当前时间方法
    //    function getCurtime()
    //    {
    //        return Qt.formatDateTime(new Date(),"hh:mm")
    //    }

    function startCooking(root,cookSteps)
    {
        if(cookSteps==null)
        {
            SendFunc.setCooking(cookSteps,root.orderTime,root.cookPos)
        }
        else
        {
            console.log("startCooking:",JSON.stringify(root))
            if(cookSteps.length===1 && (undefined === cookSteps[0].number || 0 === cookSteps[0].number))
            {
                SendFunc.setCooking(cookSteps,root.orderTime,root.cookPos)
                //                                if(cookWorkPosEnum.LEFT===root.cookPos)
                //                                {
                //                                    QmlDevState.setState("LStOvState",5)
                //                                    QmlDevState.setState("LStOvMode",cookSteps[0].mode)
                //                                    QmlDevState.setState("LStOvSetTemp",cookSteps[0].temp)
                //                                    QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
                //                                    QmlDevState.setState("LStOvSetTimer",cookSteps[0].time)
                //                                    QmlDevState.setState("LStOvSetTimerLeft",cookSteps[0].time/4)
                //                                    QmlDevState.setState("LStOvOrderTimer",cookSteps[0].time)
                //                                    QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)
                //                                }
                //                                else
                //                                {
                //                                    QmlDevState.setState("RStOvState",1)
                //                                    QmlDevState.setState("RStOvRealTemp",cookSteps[0].temp)
                //                                    QmlDevState.setState("RStOvSetTimerLeft",cookSteps[0].time)
                //                                    QmlDevState.setState("RStOvSetTimer",cookSteps[0].time)
                //                                    QmlDevState.setState("RStOvOrderTimer",cookSteps[0].time)
                //                                    QmlDevState.setState("RStOvOrderTimerLeft",cookSteps[0].time/2)
                //                                }
            }
            else
            {
                if(root.recipeid>0)
                {
                    SendFunc.setMultiCooking(cookSteps,root.orderTime,root.dishName,root.recipeid)
                }
                else
                {
                    SendFunc.setMultiCooking(cookSteps,root.orderTime)
                }
                //            QmlDevState.setState("LStOvState",1)
                //            QmlDevState.setState("LStOvMode",cookSteps[0].mode)
                //            QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
                //            QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)

                //            QmlDevState.setState("cnt",cookSteps.length)
                //            QmlDevState.setState("current",2)
            }
        }
        let page=isExistView("PageSteaming")
        if(page!=null)
            backPage(page)
    }

    function loaderErrorCodeShow(value,dir)
    {
        if(value!==0)
            sleepWakeup()
        if(productionTestStatus==0xff)
            return
        switch (value) {
        case 1:
            if(dir==null||dir===cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        case 2:
            loaderErrorShow("没有水箱或水箱没有放到位","请重新放置")
            break
        case 3:
            loaderErrorShow("水箱缺水","水箱缺水，请及时加水")
            break
        case 4:
            if(dir==null||dir===cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔蒸箱干烧！","请暂停使用左腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>")
            break
        case 5:
            if(dir==null||dir===cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        case 6:
            if(dir==null)
                loaderErrorShow("防火墙传感器故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        case 7:
            loaderErrorShow("烟机进风口出现火情！","请及时关闭灶具旋钮 等待温度降低后使用",false)
            standbyWakeup()
            break
        case 8:
            SendFunc.setSysPower(1)
            loaderErrorShow("燃气泄漏","燃气有泄露风险\n请立即关闭灶具旋钮\n关闭总阀并开窗通气",false)
            break
        case 9:
            if(dir==null)
            {
                loaderErrorShow("电源板串口故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false);
                standbyWakeup()
            }
            break
        case 10:
            if(dir==null||dir===cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔烤箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
            break
        case 12:
            if(dir==null||dir===cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔蒸箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
            break
        case 13:
            if(dir==null||dir===cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔蒸箱干烧","请暂停使用右腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>");
            break
        case 14:
            if(dir==null||dir===cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        default:
            break
        }
    }

    //    readonly property var weather_code:{
    //        "113": "Sunny",
    //        "116": "PartlyCloudy",
    //        "119": "Cloudy",
    //        "122": "VeryCloudy",
    //        "143": "Fog",
    //        "176": "LightShowers",
    //        "179": "LightSleetShowers",
    //        "182": "LightSleet",
    //        "185": "LightSleet",
    //        "200": "ThunderyShowers",
    //        "227": "LightSnow",
    //        "230": "HeavySnow",
    //        "248": "Fog",
    //        "260": "Fog",
    //        "263": "LightShowers",
    //        "266": "LightRain",
    //        "281": "LightSleet",
    //        "284": "LightSleet",
    //        "293": "LightRain",
    //        "296": "LightRain",
    //        "299": "HeavyShowers",
    //        "302": "HeavyRain",
    //        "305": "HeavyShowers",
    //        "308": "HeavyRain",
    //        "311": "LightSleet",
    //        "314": "LightSleet",
    //        "317": "LightSleet",
    //        "320": "LightSnow",
    //        "323": "LightSnowShowers",
    //        "326": "LightSnowShowers",
    //        "329": "HeavySnow",
    //        "332": "HeavySnow",
    //        "335": "HeavySnowShowers",
    //        "338": "HeavySnow",
    //        "350": "LightSleet",
    //        "353": "LightShowers",
    //        "356": "HeavyShowers",
    //        "359": "HeavyRain",
    //        "362": "LightSleetShowers",
    //        "365": "LightSleetShowers",
    //        "368": "LightSnowShowers",
    //        "371": "HeavySnowShowers",
    //        "374": "LightSleetShowers",
    //        "377": "LightSleet",
    //        "386": "ThunderyShowers",
    //        "389": "ThunderyHeavyRain",
    //        "392": "ThunderySnowShowers",
    //        "395": "HeavySnowShowers"
    //    }
    //    readonly property var weather_symbol:{
    //        "Unknown":             "✨",
    //        "Cloudy":              "☁️",
    //        "Fog":                 "🌫",
    //        "HeavyRain":           "🌧",
    //        "HeavyShowers":        "🌧",
    //        "HeavySnow":           "❄️",
    //        "HeavySnowShowers":    "❄️",
    //        "LightRain":           "🌦",
    //        "LightShowers":        "🌦",
    //        "LightSleet":          "🌧",
    //        "LightSleetShowers":   "🌧",
    //        "LightSnow":           "🌨",
    //        "LightSnowShowers":    "🌨",
    //        "PartlyCloudy":        "⛅️",
    //        "Sunny":               "☀️",
    //        "ThunderyHeavyRain":   "🌩",
    //        "ThunderyShowers":     "⛈",
    //        "ThunderySnowShowers": "⛈",
    //        "VeryCloudy": "☁️"
    //    }
}
