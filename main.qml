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
    visible: true
    property int sysPowerPressCount:0
    readonly property string uiVersion:"1.0"
    readonly property string productionTestWIFISSID:"moduletest"
    readonly property string productionTestWIFIPWD:"12345678"
    readonly property int leftDevice:0
    readonly property int rightDevice:1
    readonly property int allDevice:2

    readonly property var leftWorkMode: ["未设定", "经典蒸", "高温蒸", "热风烧烤", "上下加热", "立体热风", "蒸汽烤", "空气炸", "保温烘干"]
    readonly property var leftWorkModeNumber:[0,1,2,35,36,38,40,42,72]
    readonly property string rightWorkMode:"便捷蒸"

    readonly property var leftModel:[{"modelData":1,"temp":100,"time":30,"minTemp":40,"maxTemp":100},{"modelData":2,"temp":120,"time":20,"minTemp":101,"maxTemp":120},{"modelData":3,"temp":200,"time":60,"minTemp":50,"maxTemp":230}
        ,{"modelData":4,"temp":180,"time":120,"minTemp":50,"maxTemp":230},{"modelData":5,"temp":180,"time":120,"minTemp":50,"maxTemp":230},{"modelData":6,"temp":150,"time":60,"minTemp":50,"maxTemp":200}
        ,{"modelData":7,"temp":220,"time":15,"minTemp":200,"maxTemp":230},{"modelData":8,"temp":60,"time":30,"minTemp":50,"maxTemp":120}]
    readonly property var rightModel:{"modelData":0,"temp":100,"time":30,"minTemp":40,"maxTemp":100}

    readonly property var workStateEnum:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5}
    readonly property var workStateArray:["停止","预约中","预热中","运行中","烹饪完成","暂停"]

    readonly property var workOperationEnum:{"START":0,"PAUSE":1,"CANCEL":2,"CONFIRM":3,"RUN_NOW":4}

    readonly property var timingStateEnum:{"STOP":0,"RUN":1,"PAUSE":2,"CONFIRM":3}
    readonly property var timingOperationEnum:{"START":1,"CANCEL":2}
    property bool wifiConnecting: false
    property bool wifiConnected:false
    property bool sleepState: false
    property var wifiConnectInfo:{"ssid":"","psk":"","encryp":0}
    //    property var multiModeEnum:{"NONE":0,"RECIPE":1,"MULTISTAGE":2}

    property string themesImagesPath:"file:themes/default/"
    readonly property string themesWindowBackgroundColor:"#1A1A1A"
    readonly property string themesPopupWindowColor:"#333333"
    readonly property string themesTextColor:"#E68855"
    readonly property string themesTextColor2:"#A2A2A2"
    /*
    readonly  property ListModel systemthemes:ListModel {

        ListElement {
            name: qsTr("默认")
            titleBackground: "#c62f2f"
            background: "#f6f6f6"
            textColor: "#5c5c5c"
            imagesPath:"file:themes/default/"
        }
        ListElement {
            name: qsTr("淑女粉")
            titleBackground: "#191b1f"
            background: "#222225"
            textColor: "#adafb2"
            imagesPath:"file:themes/light/"
        }
    }

    function themeChange(current)
    {
        var themes=systemthemes.get(current)
        themesImagesPath=themes.imagesPath
    }
*/
    Settings {
        id: systemSettings
        category: "system"
        //        property int currentTheme: 0
        //        onCurrentThemeChanged: {
        //            console.log("onCurrentThemeChanged",systemSettings.currentTheme)
        //            themeChange(systemSettings.currentTheme)
        //        }
        //设置-休眠时间(范围:1-5,单位:分钟 )
        property int sleepTime: 4

        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 250

        property bool wifiEnable: true

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false

        property bool leftCookDialog:true
        property bool rightCookDialog:true
        property bool multistageRemind:true
        property bool multistageDialog:true
        property var wifiPasswdArray:[]

        property int productionTestAging:0

        onSleepTimeChanged: {
            console.log("onSleepTimeChanged")
            timer_window.interval=systemSettings.sleepTime*60000
        }
    }

    function systemReset()
    {
        var Data={}
        Data.reset = null
        SendFunc.setToServer(Data)

        systemSettings.sleepTime=4
        systemSettings.brightness=250
        Backlight.backlightSet(systemSettings.brightness)
        if(systemSettings.wifiEnable!=true)
        {
            systemSettings.wifiEnable=true
            SendFunc.enableWifi(true)
        }
        systemSettings.childLock=false
        systemSettings.leftCookDialog=true
        systemSettings.rightCookDialog=true
        systemSettings.multistageRemind=true
        systemSettings.wifiPasswdArray=[]
        systemSettings.productionTestAging=0
    }

    function systemPower(power){
        if(power)
        {
            Backlight.backlightSet(systemSettings.brightness)
            timer_window.restart()
        }
        else
        {
            Backlight.backlightSet(0)
            timer_window.stop()
            backTopPage()
        }
        if(window.visible===false)
            window.visible=true
        //        timer_sysPower.stop()
    }

    Component.onCompleted: {
        console.warn("Window onCompleted: ",Qt.fontFamilies())

        //        if(systemSettings.currentTheme===0)
        //            themeChange(systemSettings.currentTheme)


        //        Backlight.backlightEnable()
        //        Backlight.backlightSet(systemSettings.brightness)
        load_page("pageHome")
        if(systemSettings.wifiPasswdArray!=null)
        {
            var i
            console.log("systemSettings.wifiPasswdArray",systemSettings.wifiPasswdArray.length)
            for( i = 0; i < systemSettings.wifiPasswdArray.length; i++)
            {
                console.log("ssid:",systemSettings.wifiPasswdArray[i].ssid)
                console.log("psk:",systemSettings.wifiPasswdArray[i].psk)
                console.log("encryp:",systemSettings.wifiPasswdArray[i].encryp)
            }
        }
        systemSettings.childLock=false

    }
    background:Rectangle {
        color: themesWindowBackgroundColor
    }

    Timer{
        id:timer_window
        repeat: false
        running: true
        interval: systemSettings.sleepTime*60000//
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_window sleep...")
            if(sleepState==false && QmlDevState.state.SysPower>0 && QmlDevState.state.HoodSpeed == 0 &&QmlDevState.state.LStoveStatus == 0 && QmlDevState.state.RStoveStatus == 0 &&QmlDevState.state.RStOvState == 0 && QmlDevState.state.LStOvState == 0 && QmlDevState.state.OTAState == 0 && QmlDevState.state.ErrorCodeShow == 0 && QmlDevState.localConnected == 1 && isExistView("PageTestFront")==null)
            {
                //                Backlight.backlightDisable()
                sleepState=true
                Backlight.backlightSet(0)
            }
            else
            {
                timer_window.restart()
            }
        }
    }

    //    Timer{
    //        id:timer_sysPower
    //        repeat: QmlDevState.state.SysPower==0
    //        running: false
    //        interval: 1000
    //        triggeredOnStart: false
    //        onTriggered: {
    //            console.log("timer_syspower",sysPowerPressCount)
    //            if(sysPowerPressCount<2)
    //            {
    //                ++sysPowerPressCount
    //                if(sysPowerPressCount==2)
    //                {
    //                    if(QmlDevState.state.SysPower==0)
    //                    {
    //                        SendFunc.setSysPower(1)
    //                    }
    //                }
    //            }
    //        }
    //    }

    StackView {
        id: stackView
//                initialItem: pageTestFront // pageHome pageTestFront pageTest pageGetQuad
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
    function closeLoaderMain(){
        loader_main.sourceComponent = undefined
    }

    Component{
        id:component_bind
        PageDialogQrcode{
            onCancel: {
                closeLoaderMain()
            }
        }
    }
    function showQrcodeBind(title){
        loader_main.sourceComponent = component_bind
        loader_main.item.hintTopText=title
    }
    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loader_error
        //        asynchronous: true
        anchors.fill: parent
        sourceComponent:null
    }
    Component{
        id:component_fault
        PageFaultPopup {
            hintTopText:""
            hintTopImgSrc:""
            hintCenterText:""
            hintBottomText:""
            hintHeight:292

            onCancel:{
                closeLoaderFault()
            }
        }
    }
    function showLoaderFault(hintTopText,hintBottomText,closeVisible){
        loader_error.sourceComponent = component_fault
        loader_error.item.hintTopText=hintTopText
        loader_error.item.hintBottomText=hintBottomText
        if(closeVisible!=null)
            loader_error.item.closeVisible=closeVisible
    }
    function showLoaderFaultCenter(hintCenterText,hintHeight){
        loader_error.sourceComponent = component_fault
        loader_error.item.hintCenterText=hintCenterText
        loader_error.item.hintHeight=hintHeight
    }
    function showLoaderFaultImg(imageUrl,hintBottomText){
        loader_error.sourceComponent = component_fault
        loader_error.item.hintTopImgSrc=imageUrl
        loader_error.item.hintBottomText=hintBottomText
    }
    function closeLoaderFault(){
        if(loader_error.sourceComponent === component_fault)
            loader_error.sourceComponent = undefined
    }

    //---------------------------------------------------------------
    Loader{
        //加载弹窗组件
        id:loader_lock_screen
        asynchronous: true
        anchors.fill: parent
        sourceComponent:null
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled:true
        propagateComposedEvents: true

        onPressed: {
            console.log("Window onPressed")
            if(QmlDevState.state.SysPower>0)
            {
                if(sleepState==true)
                {
                    sleepState=false
                    Backlight.backlightSet(systemSettings.brightness)
                    mouse.accepted = true
                }
                else
                {
                    mouse.accepted = false
                }
                timer_window.restart()
            }
            else
            {
                mouse.accepted = true //
                //                sysPowerPressCount=0
                //                timer_sysPower.restart()
            }
//            mouse.accepted=false
        }
        //        onReleased: {
        //            console.warn("Window onReleased")
        //            if(QmlDevState.state.SysPower==0)
        //            {
        //                timer_sysPower.stop()
        //                mouse.accepted = true
        //            }
        //            else
        //            {
        //                mouse.accepted = false
        //            }
        //        }

    }
    ListModel {
        id: wifiModel
//                ListElement {
//                    connected: 1
//                    ssid: "qwertyuio"
//                    level:2
//                    flags:2
//                }
//                ListElement {
//                    connected: 0
//                    ssid: "123"
//                    level:2
//                    flags:1
//                }
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
//    Component {
//        id: pageThemes
//        PageThemes {}
//    }
    function isExistView(pageName) {
        console.log("isExistView:",pageName)
        //        return stackView.currentItem.name===PageName
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
        console.log("load_page:"+page,"args:"+args)

        switch (page) {
        case "pageHome":
            stackView.push(pageHome,StackView.Immediate)
            break;
        case "pageWifi":
            if(systemSettings.wifiEnable)
            {
                if(wifiConnecting==false)
                {
                    SendFunc.scanWifi()
                }
            }
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
            stackView.push(pageScreenLCD,StackView.Immediate)
            break;
        case "pageScreenLight":
            stackView.push(pageScreenLight,StackView.Immediate)
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
//        case "pageThemes":
//            stackView.push(pageThemes,StackView.Immediate)
//            break;
        }

        console.log("stackView depth:"+stackView.depth)
    }
    //获取当前时间方法
    //    function getCurtime()
    //    {
    //        return Qt.formatDateTime(new Date(),"hh:mm")
    //    }

    function startCooking(root,cookSteps,orderTime)
    {
        console.log("startCooking:",JSON.stringify(root),JSON.stringify(cookSteps))
        if(cookSteps.length===1 && (undefined === cookSteps[0].number || 0 === cookSteps[0].number))
        {
            SendFunc.setCooking(cookSteps,orderTime,root.cookPos)
            //            if(leftDevice===root.cookPos)
            //            {
            //                QmlDevState.setState("LStOvState",2)
            //                QmlDevState.setState("LStOvMode",cookSteps[0].mode)
            //                QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
            //                QmlDevState.setState("LStOvSetTimer",cookSteps[0].time)
            //                QmlDevState.setState("LStOvSetTimerLeft",cookSteps[0].time)
            //                QmlDevState.setState("LStOvOrderTimer",cookSteps[0].time)
            //                QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time/2)
            //            }
            //            else
            //            {
            //                QmlDevState.setState("RStOvState",3)
            //                QmlDevState.setState("RStOvRealTemp",cookSteps[0].temp)
            //                QmlDevState.setState("RStOvSetTimerLeft",cookSteps[0].time)
            //                QmlDevState.setState("RStOvSetTimer",cookSteps[0].time)
            //                QmlDevState.setState("RStOvOrderTimer",cookSteps[0].time)
            //                QmlDevState.setState("RStOvOrderTimerLeft",cookSteps[0].time/2)
            //            }
        }
        else
        {
            if(root.imgUrl!=="")
            {
                SendFunc.setMultiCooking(cookSteps,orderTime,root.dishName,root.seqid)
            }
            else
            {
                SendFunc.setMultiCooking(cookSteps,orderTime)
            }
            //            QmlDevState.setState("LStOvState",1)
            //            QmlDevState.setState("LStOvMode",cookSteps[0].mode)
            //            QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
            //            QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)

            //            QmlDevState.setState("cnt",cookSteps.length)
            //            QmlDevState.setState("current",2)
        }
        var page=isExistView("pageSteamBakeRun")
        if(page!==null)
            backPage(page)
//        else
//            backTopPage()
    }

}
