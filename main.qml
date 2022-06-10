import QtQuick 2.7
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0
//import QtQuick.Window 2.2

import "pageCook"
import "pageMain"
import "pageSet"
import "pageProductionTest"

import "qrc:/SendFunc.js" as SendFunc

ApplicationWindow {
    id: window
    width: 800
    height: 480
    //    visible: true
    property int sysPower:-1
    property int permitStartStatus:0
    property int productionTestStatus:0
    property int productionTestFlag:1

    //    readonly property string uiVersion:"1.1"
    readonly property string productionTestWIFISSID:"moduletest"
    readonly property string productionTestWIFIPWD:"58185818"

    readonly property var cookWorkPosEnum:{"LEFT":0,"RIGHT":1,"ALL":2}
    readonly property var  cookModeImg: ["icon-steamed.png","icon-bake.png","icon-multistage.png"]
    readonly property var workModeEnum: ["未设定", "经典蒸", "高温蒸", "热风烧烤", "上下加热", "立体热风", "蒸汽烤", "空气炸", "保温烘干","便捷蒸"]
    readonly property var workModeNumberEnum:[0,1,2,35,36,38,40,42,72,100]
    readonly property int rightWorkModeIndex:8

    readonly property var workModeModelEnum:[{"modelData":1,"temp":100,"time":30,"minTemp":40,"maxTemp":100},{"modelData":2,"temp":120,"time":20,"minTemp":101,"maxTemp":120},{"modelData":6,"temp":150,"time":60,"minTemp":50,"maxTemp":200},{"modelData":7,"temp":220,"time":15,"minTemp":200,"maxTemp":230,"maxTime":180},{"modelData":3,"temp":200,"time":60,"minTemp":50,"maxTemp":230}
        ,{"modelData":5,"temp":180,"time":120,"minTemp":50,"maxTemp":230},{"modelData":4,"temp":180,"time":120,"minTemp":50,"maxTemp":230}
        ,{"modelData":8,"temp":60,"time":30,"minTemp":50,"maxTemp":120},{"modelData":9,"temp":100,"time":30,"minTemp":40,"maxTemp":100}]

    readonly property var workStateEnum:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5,"WORKSTATE_PAUSE_RESERVE":6}
    readonly property var workStateArray:["停止","预约中","预热中","运行中","烹饪完成","暂停","暂停预约"]

    readonly property var workOperationEnum:{"START":0,"PAUSE":1,"CANCEL":2,"CONFIRM":3,"RUN_NOW":4}

    readonly property var timingStateEnum:{"STOP":0,"RUN":1,"PAUSE":2,"CONFIRM":3}
    readonly property var timingOperationEnum:{"START":1,"CANCEL":2}
    property bool wifiConnecting: false
    property bool wifiConnected:false
    property bool sleepState: false
    property var wifiConnectInfo:{"ssid":"","psk":"","encryp":0}
    readonly property var multiModeEnum:{"NONE":0,"RECIPE":1,"MULTISTAGE":2}
    readonly property var buzControlEnum:{"STOP":0,"SHORT":1,"SHORTTWO":2,"2SCECONDS":3,"OPEN":4}

    property string themesImagesPath:"file:themes/default/"
    readonly property string themesWindowBackgroundColor:"#1A1A1A"
    readonly property string themesPopupWindowColor:"#333333"
    readonly property string themesTextColor:"#E68855"
    readonly property string themesTextColor2:"#A2A2A2"

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
        property int sleepTime: 3

        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 250
        property bool wifiEnable: false

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false
        property var cookDialog:[1,1,1,1,1,1]
        property bool multistageRemind:true
        property var wifiPasswdArray:[]
        property bool otaSuccess:false
        //        onFirstStartupChanged: {
        //            console.log("onFirstStartupChanged....",systemSettings.firstStartup)
        //        }
        onBrightnessChanged: {
            console.log("onBrightnessChanged....",systemSettings.brightness)
            Backlight.backlightSet(systemSettings.brightness)
        }
        onWifiEnableChanged: {
            console.log("onWifiEnableChanged....",systemSettings.wifiEnable)
        }
        onSleepTimeChanged: {
            console.log("onSleepTimeChanged",systemSettings.sleepTime)
            timer_window.interval=systemSettings.sleepTime*60000
            timer_window.restart()
        }
    }
    function systemSync()
    {
        QmlDevState.executeShell("(sleep 2;sync) &")
    }

    function systemReset()
    {
        var Data={}
        Data.reset = null
        SendFunc.setToServer(Data)

        systemSettings.sleepTime=3
        systemSettings.brightness=250

        //        SendFunc.enableWifi(true)
        systemSettings.wifiEnable=true

        systemSettings.childLock=false
        systemSettings.cookDialog=[1,1,1,1,1,1]
        systemSettings.multistageRemind=true
        systemSettings.wifiPasswdArray=[]
        systemSync()
    }

    function systemPower(power){
        console.log("systemPower",power)
        if(sysPower==power || sysPower==0xff)
            return
        if(power)
        {
            Backlight.backlightSet(systemSettings.brightness)
            timer_window.restart()
        }
        else
        {
            Backlight.backlightSet(0)
            timer_window.stop()
            loaderMainHide()
            if(productionTestFlag==0 && timer_standby.running==true)
                timer_standby.stop()
            if(productionTestStatus==0)
            {
                backTopPage()
            }
        }
        if(window.visible===false)
            window.visible=true
        sysPower=power
    }

    Component.onCompleted: {
        console.warn("Window onCompleted: ",Qt.fontFamilies())
        load_page("pageHome")
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
        systemSettings.childLock=false
        if(systemSettings.brightness<1 || systemSettings.brightness>255)
        {
            systemSettings.brightness=250
        }
        //        SendFunc.makeRequest()
        //        SendFunc.weatherRequest("杭州")
    }
    background:Rectangle {
        color: themesWindowBackgroundColor
    }

    Timer{
        id:timer_standby
        repeat: false
        running: true
        interval: 180000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_standby onTriggered",productionTestFlag);
            if(productionTestFlag>0)
            {
                productionTestFlag=0
                if(sleepState==true)
                {
                    timer_standby.interval=9*60000
                    timer_standby.restart()
                }
            }
            else
            {
                if(sleepState==true && QmlDevState.state.RStOvState == 0 && QmlDevState.state.LStOvState == 0 && QmlDevState.state.LStoveStatus == 0 && QmlDevState.state.RStoveStatus == 0 && QmlDevState.state.HoodSpeed == 0 && QmlDevState.state.RStoveTimingState==timingStateEnum.STOP&& QmlDevState.state.AlarmStatus != 1 && QmlDevState.state.Alarm != 1)
                {
                    SendFunc.setSysPower(0)
                }
                else
                {
                    timer_standby.interval=9*60000
                    timer_standby.restart()
                }
            }
        }
    }

    Timer{
        id:timer_wifi_connecting
        repeat: false
        running: false
        interval: 63000
        triggeredOnStart: false
        onTriggered: {
            if(wifiConnecting==true)
            {
                console.log("timer_wifi_connecting...")
                wifiConnecting=false
                QmlDevState.executeShell("(wpa_cli reconfigure) &")
                //                QmlDevState.executeShell("(wpa_cli reconfigure && wpa_cli enable_network all && wpa_cli save_config) &")
            }
        }
    }

    Timer{
        id:timer_window
        repeat: false
        running: sysPower > 0
        interval: systemSettings.sleepTime*60000//
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_window sleep:")
            //            console.log("timer_window sleep:",QmlDevState.state.HoodSpeed,QmlDevState.state.RStOvState,QmlDevState.state.LStOvState,QmlDevState.state.ErrorCodeShow,QmlDevState.localConnected)
            if(QmlDevState.state.ErrorCodeShow == 0 && QmlDevState.localConnected > 0 && productionTestStatus==0 && sysPower==1 && wifiConnecting==false)
            {
                if((QmlDevState.state.RStOvState == workStateEnum.WORKSTATE_PREHEAT || QmlDevState.state.RStOvState == workStateEnum.WORKSTATE_RUN || QmlDevState.state.RStOvState == workStateEnum.WORKSTATE_PAUSE ) || (QmlDevState.state.LStOvState == workStateEnum.WORKSTATE_PREHEAT || QmlDevState.state.LStOvState == workStateEnum.WORKSTATE_RUN || QmlDevState.state.LStOvState == workStateEnum.WORKSTATE_PAUSE ))
                    return
                //                Backlight.backlightDisable()
                sleepState=true
                Backlight.backlightSet(0)

                timer_standby.interval=10*60000
                timer_standby.restart()
            }
            else
            {
                sleepState=false
                timer_window.restart()
            }
        }
    }
    signal sleepTimerRestart()
    onSleepTimerRestart:{
        //        console.log("onSleepTimerRestart")
        timer_window.restart()
    }

    StackView {
        id: stackView
        //initialItem: pageTestFront // pageHome pageTestFront pageTest pageGetQuad
        anchors.fill: parent
    }

    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loader_main
        //        asynchronous: true
        anchors.fill: parent
        sourceComponent:null
    }
    function loaderMainHide(){
        loader_main.sourceComponent = undefined
    }
    Component{
        id:component_steam
        PageDialog{
            id:steamDialog
            hintHeight: 360
            hintTopText:"请将食物放入\n将水箱加满水"
            confirmText:"开始烹饪"
            checkboxVisible:true
            onCancel:{
                console.info("component_steam onCancel")
                loaderMainHide()
            }
            onConfirm:{
                console.info("component_steam onConfirm")

                if(steamDialog.checkboxState)
                {
                    var dialog=systemSettings.cookDialog
                    dialog[steamDialog.cookDialog]=0
                    systemSettings.cookDialog=dialog
                }
                startCooking(steamDialog.para,JSON.parse(steamDialog.para.cookSteps))
                loaderMainHide()
            }
        }
    }
    function loaderSteamShow(hintHeight,hintTopText,confirmText,para,cookDialog){
        loader_main.sourceComponent = component_steam
        loader_main.item.hintHeight=hintHeight
        loader_main.item.hintTopText=hintTopText
        loader_main.item.confirmText=confirmText
        loader_main.item.para=para
        loader_main.item.cookDialog=cookDialog
    }
    Component{
        id:component_qrcode
        PageDialogQrcode{
            onCancel: {
                loaderQrcodeHide()
            }
        }
    }
    function loaderQrcodeShow(title){
        //        console.log("BindTokenState",QmlDevState.state.BindTokenState,QmlDevState.state.DeviceSecret,QmlDevState.state.WifiState)//QmlDevState.state.BindTokenState > 0
        if(QmlDevState.state.DeviceSecret=="")
        {
            loaderImagePopupShow("四元组不存在","/x50/icon/icon_pop_error.png")
            return
        }
        if(systemSettings.wifiEnable && wifiConnected==true)
        {
            loader_main.sourceComponent = component_qrcode
            loader_main.item.hintTopText=title
        }
        else
        {
            loaderImagePopupShow("未连网，请连接网络后再试","/x50/icon/icon_pop_error.png")
        }
    }
    function loaderQrcodeHide(){
        if(loader_main.sourceComponent===component_qrcode)
            loader_main.sourceComponent = undefined
    }

    Component{
        id:component_imagePopup
        PageImagePopup{
            hintTopImgSrc:""
            hintCenterText:""
            onCancel: {
                loader_main.sourceComponent = undefined
            }
        }
    }
    function loaderImagePopupShow(hintCenterText,hintTopImgSrc){
        loader_main.sourceComponent = component_imagePopup
        loader_main.item.hintTopImgSrc=hintTopImgSrc
        loader_main.item.hintCenterText=hintCenterText
    }
    Component{
        id:component_popup
        PagePopup{
            hintTopText:""
            hintCenterText:""
            confirmText:""
            onCancel: {
                loaderPopupHide()
            }
            onConfirm:{
                loaderPopupHide()
            }
        }
    }
    function loaderPopupShow(hintTopText,hintCenterText,hintHeight,confirmText,confirmFunc,closeVisible){

        if(loader_main.sourceComponent === component_popup)
        {
            if(closeVisible!==false && loader_main.item.closeVisible===false)
                return
        }
        else
            loader_main.sourceComponent = component_popup

        loader_main.item.hintTopText=hintTopText==null?"":hintTopText
        loader_main.item.hintCenterText=hintCenterText==null?"":hintCenterText
        loader_main.item.hintHeight=hintHeight==null?300:hintHeight
        loader_main.item.confirmText=confirmText==null?"":confirmText
        loader_main.item.confirmFunc=confirmFunc
        loader_main.item.closeVisible=closeVisible==null?true:closeVisible
    }
    function loaderPopupHide(){
        if(loader_main.sourceComponent === component_popup)
            loader_main.sourceComponent = undefined
    }

    Loader{
        //加载弹窗组件
        id:loaderAuto
        anchors.fill: parent
        sourceComponent:undefined
    }
    Component{
        id:component_autoPopup
        PagePopup{
            hintTopText:""
            hintCenterText:""
            confirmText:""
            onCancel: {
                loaderAutoPopupHide()
            }
            onConfirm:{
                loaderAutoPopupHide()
            }
        }
    }
    function loaderAutoPopupShow(hintTopText,hintCenterText,hintHeight,confirmText,confirmFunc,closeVisible){

        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(closeVisible!==false && loaderAuto.item.closeVisible===false)
                return
        }
        else
            loaderAuto.sourceComponent = component_autoPopup

        loaderAuto.item.hintTopText=hintTopText==null?"":hintTopText
        loaderAuto.item.hintCenterText=hintCenterText==null?"":hintCenterText
        loaderAuto.item.hintHeight=hintHeight==null?300:hintHeight
        loaderAuto.item.confirmText=confirmText==null?"":confirmText
        loaderAuto.item.confirmFunc=confirmFunc
        loaderAuto.item.closeVisible=closeVisible==null?true:closeVisible
    }
    function loaderAutoPopupHide(){
        if(loaderAuto.sourceComponent === component_autoPopup)
            loaderAuto.sourceComponent = undefined
    }
    function loaderStoveAutoPopupHide(){
        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(loaderAuto.item.hintCenterText.indexOf("定时")!=-1)
                loaderAuto.sourceComponent = undefined
        }
    }
    function loaderDoorAutoPopupHide(dirText){
        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(loaderAuto.item.hintCenterText.indexOf("门开启")!=-1 &&  loaderAuto.item.hintCenterText.indexOf(dirText)!=-1)
                loaderAuto.sourceComponent = undefined
        }
    }
    Component{
        id:component_hoodoff
        PagePopup{
            hintTopText:"灶具关闭后，烟机自动延时"+QmlDevState.state.HoodOffLeftTime+"分钟关\n闭，点击(立即关闭)可直接关闭烟机"
            confirmText:"立即关闭"
            onCancel: {
                closeLoaderHoodOff()
            }
            onConfirm:{
                SendFunc.setHoodSpeed(0)
                closeLoaderHoodOff()
            }
        }
    }

    function showLoaderHoodOff(){
        if(loaderAuto.sourceComponent === component_autoPopup)
        {
            if(loaderAuto.item.closeVisible===false)
                return
        }
        loaderAuto.sourceComponent = component_hoodoff
    }
    function closeLoaderHoodOff(){
        if(loaderAuto.sourceComponent === component_hoodoff)
        {
            loaderAuto.sourceComponent = undefined
        }
    }

    Loader{
        //加载弹窗组件
        id:loaderLockScreen
        asynchronous: true
        anchors.fill: parent
        sourceComponent:undefined
    }
    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loader_error
        //                asynchronous: true
        anchors.fill: parent
        sourceComponent:undefined
    }

    function loaderErrorShow(hintTopText,hintBottomText,closeVisible){
        if(sysPower==0xff)
            return
        if(loader_error.source !== "PageErrorPopup.qml")
        {
            loader_error.source = "PageErrorPopup.qml"
        }
        loader_error.item.hintTopText=hintTopText==null?"":hintTopText
        loader_error.item.hintBottomText=hintBottomText==null?"":hintBottomText
        loader_error.item.closeVisible=closeVisible==null?true:closeVisible
        //        loader_error.setSource("PageErrorPopup.qml",{"hintTopText": hintTopText,"hintBottomText": hintBottomText,"closeVisible": closeVisible})
    }
    function loaderErrorHide(){
        if(loader_error.source !== "")
        {
            loader_error.source = ""
        }
    }
    //---------------------------------------------------------------

    MouseArea{
        anchors.fill: parent
        propagateComposedEvents: true

        onPressed: {
            //            console.log("Window onPressed:",JSON.stringify(systemSettings.wifiPasswdArray))
            if(sysPower > 0)
            {
                mouse.accepted = false
                sleepTimerRestart()

                if(sleepState==true)
                {
                    if(productionTestFlag==0 && timer_standby.running==true)
                        timer_standby.stop()

                    sleepState=false
                    Backlight.backlightSet(systemSettings.brightness)
                    mouse.accepted = true
                }
            }
            else
            {
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
            if(productionTestFlag==0 && timer_standby.running==true)
                timer_standby.stop()

            sleepState=false
            Backlight.backlightSet(systemSettings.brightness)
            timer_window.restart()
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
        //            ssid: "456"
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
    //                    model: Backlight.getAllFileName("X50Test")
    //                    Item {
    //                        Image{asynchronous:true
    //                            source: "file:"+modelData }
    //                    }
    //                }
    //            }
    //        }
    //    }

    //    Component {
    //        id: pageGradient
    //        PageGradient {}
    //    }
    Component {
        id: pageHome
        PageHome {}
    }
    Component {
        id: pageWifi
        PageWifi {}
    }
    Component {
        id: pageSteamBakeRun
        PageSteamBakeRun {}
    }
    Component {
        id: pageSteamBakeBase
        PageSteamBakeBase {}
    }
    Component {
        id: pageMultistageSet
        PageMultistageSet {}
    }
    Component {
        id: pageSteamBakeReserve
        PageSteamBakeReserve {}
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
        id: pageCookHistory
        PageCookHistory {}
    }
    Component {
        id: pageCloseHeat
        PageCloseHeat {}
    }
    Component {
        id: pageSet
        PageSet {}
    }
    Component {
        id: pageLocalSettings
        PageLocalSettings {}
    }
    Component {
        id: pageReset
        PageReset {}
    }
    Component {
        id: pageSystemUpdate
        PageSystemUpdate {}
    }
    Component {
        id: pageAboutMachine
        PageAboutMachine {}
    }
    Component {
        id: pageAfterGuide
        PageAfterGuide {}
    }
    Component {
        id: pageReleaseNotes
        PageReleaseNotes {}
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

    function isExistView(pageName) {
        console.log("isExistView:",pageName)
        return stackView.find(function(item,index){
            return item.name === pageName
        })
    }

    function backPrePage() {
        if(stackView.depth>0)
            stackView.pop(StackView.Immediate)
        console.log("stackView depth:"+stackView.depth)
    }

    function backTopPage() {
        if(stackView.depth>0)
            stackView.pop(null,StackView.Immediate)
        console.log("stackView depth:"+stackView.depth)
    }

    function backPage(page) {
        if(stackView.depth>0)
            stackView.pop(page,StackView.Immediate)
        console.log("backPage stackView depth:"+stackView.depth)
    }

    function load_page(page,args) {
        //        console.log("load_page:"+page,"args:"+args)

        switch (page) {
        case "pageHome":
            stackView.push(pageHome,StackView.Immediate)
            break;
        case "pageWifi":
            stackView.push(pageWifi,StackView.Immediate)
            break;
        case "pageSteamBakeBase": //蒸烤设置页面
            stackView.push(pageSteamBakeBase, {"state":args},StackView.Immediate)
            break;
        case "pageMultistageSet":
            stackView.push(pageMultistageSet,StackView.Immediate)
            break;
        case "pageSteamBakeRun": //蒸烤页面
            stackView.push(pageSteamBakeRun, {"state":args},StackView.Immediate)
            break;
        case "pageSteamBakeReserve": //页面
            stackView.push(pageSteamBakeReserve, {"state":args},StackView.Immediate)
            break;
        case "pageSmartRecipes": //页面
            stackView.push(pageSmartRecipes,StackView.Immediate)
            break;
        case "pageCookDetails":
            stackView.push(pageCookDetails, {"state":args},StackView.Immediate)
            break;
        case "pageCookHistory":
            stackView.push(pageCookHistory, {"state":args},StackView.Immediate)
            break;
        case "pageCloseHeat":
            stackView.push(pageCloseHeat,StackView.Immediate)
            break;
        case "pageSet":
            stackView.push(pageSet,StackView.Immediate)
            break;
        case "pageLocalSettings":
            stackView.push(pageLocalSettings,StackView.Immediate)
            break;
        case "pageReset":
            stackView.push(pageReset,StackView.Immediate)
            break;
        case "pageSystemUpdate":
            stackView.push(pageSystemUpdate,StackView.Immediate)
            break;
        case "pageAboutMachine":
            stackView.push(pageAboutMachine,StackView.Immediate)
            break;
        case "pageAfterGuide":
            stackView.push(pageAfterGuide,StackView.Immediate)
            break;
        case "pageReleaseNotes":
            stackView.push(pageReleaseNotes,StackView.Immediate)
            break;
        case "pageTestFront":
            stackView.push(pageTestFront,StackView.Immediate)
            break;
        case "pageIntelligentDetection":
            stackView.push(pageIntelligentDetection,StackView.Immediate)
            break;
        case "pageScreenTest":
            stackView.push(pageScreenTest,StackView.Immediate)
            break;
        case "pageScreenLine":
            stackView.push(pageScreenLine,StackView.Immediate)
            break;
        case "pageScreenClick":
            stackView.push(pageScreenClick,StackView.Immediate)
            break;
        case "pageScreenLCD":
            stackView.push(pageScreenLCD,args,StackView.Immediate)
            break;
        case "pageScreenLight":
            stackView.push(pageScreenLight,args,StackView.Immediate)
            break;
        case "pageScreenTouch":
            stackView.push(pageScreenTouch,args,StackView.Immediate)
            break;
        case "pageAgingTest":
            stackView.push(pageAgingTest,args,StackView.Immediate)
            break;
        case "pageGetQuad":
            stackView.push(pageGetQuad,StackView.Immediate)
            break;
        }

        console.log("stackView depth:"+stackView.depth)
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
            console.log("startCooking:",JSON.stringify(root),JSON.stringify(cookSteps))
            if(cookSteps.length===1 && (undefined === cookSteps[0].number || 0 === cookSteps[0].number))
            {
                SendFunc.setCooking(cookSteps,root.orderTime,root.cookPos)
                //            if(cookWorkPosEnum.LEFT===root.cookPos)
                //            {
                //                QmlDevState.setState("LStOvState",1)
                //                QmlDevState.setState("LStOvMode",cookSteps[0].mode)
                //                QmlDevState.setState("LStOvSetTemp",cookSteps[0].temp)
                //                QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
                //                QmlDevState.setState("LStOvSetTimer",cookSteps[0].time)
                //                QmlDevState.setState("LStOvSetTimerLeft",cookSteps[0].time)
                //                QmlDevState.setState("LStOvOrderTimer",cookSteps[0].time)
                //                QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)
                //            }
                //            else
                //            {
                //                QmlDevState.setState("RStOvState",1)
                //                QmlDevState.setState("RStOvRealTemp",cookSteps[0].temp)
                //                QmlDevState.setState("RStOvSetTimerLeft",cookSteps[0].time)
                //                QmlDevState.setState("RStOvSetTimer",cookSteps[0].time)
                //                QmlDevState.setState("RStOvOrderTimer",cookSteps[0].time)
                //                QmlDevState.setState("RStOvOrderTimerLeft",cookSteps[0].time/2)
                //            }
            }
            else
            {
                if(root.recipeType>0)
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
        var page=isExistView("pageSteamBakeRun")
        if(page!==null)
            backPage(page)
    }

    function loaderErrorCodeShow(value,dir)
    {
        sleepWakeup()
        switch (value) {
        case 1:
            if(dir==null||dir==cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔蒸箱加热异常！","请拨打售后电话 <font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        case 2:
            loaderErrorShow("没有水箱或水箱没有放到位","请重新放置")
            break
        case 3:
            loaderErrorShow("水箱缺水","水箱缺水，请及时加水")
            break
        case 4:
            if(dir==null||dir==cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔蒸箱干烧！","请暂停使用左腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>")
            break
        case 5:
            if(dir==null||dir==cookWorkPosEnum.LEFT)
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
            loaderErrorShow("燃气泄漏","燃气有泄露风险\n请立即关闭灶具旋钮\n关闭总阀并开窗通气",false)
            break
        case 9:
            if(dir==null && productionTestStatus==0)
            {
                loaderErrorShow("电源板串口故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员",false);
                standbyWakeup()
            }
            break
        case 10:
            if(dir==null||dir==cookWorkPosEnum.LEFT)
                loaderErrorShow("左腔烤箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
            break
        case 12:
            if(dir==null||dir==cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔蒸箱加热异常！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
            break
        case 13:
            if(dir==null||dir==cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔蒸箱干烧","请暂停使用右腔蒸箱并<br/>拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font>");
            break
        case 14:
            if(dir==null||dir==cookWorkPosEnum.RIGHT)
                loaderErrorShow("右腔干烧检测电路故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员")
            break
        case 15:
            if(dir==null)
                loaderErrorShow("手势板故障！","请拨打售后电话<font color='"+themesTextColor+"'>400-888-8490</font><br/>咨询售后人员");
            break
        default:
            break
        }
    }
}

