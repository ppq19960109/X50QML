import QtQuick 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0
import QtQuick.Window 2.2

import "pageSteamAndBake"
import "pageSet"
Window {
    id: window
    width: 800
    height: 480
    visible: true

    property int leftDevice:0
    property int rightDevice:1
    property int allDevice:2

    property string leftDishName:""

    property var leftWorkMode: ["未设定", "经典蒸", "快速蒸", "热风烧烤", "上下加热", "立体热风", "蒸汽烤", "空气炸", "保温烘干"]
    property var leftWorkModeNumber:[0,1,2,35,36,38,40,42,72]
    property string rightWorkMode:"便捷蒸"

    property var leftModel:[{"modelData":1,"temp":100,"time":30},{"modelData":2,"temp":120,"time":20},{"modelData":3,"temp":200,"time":60}
        ,{"modelData":4,"temp":180,"time":120},{"modelData":5,"temp":180,"time":120},{"modelData":6,"temp":150,"time":60}
        ,{"modelData":7,"temp":220,"time":30},{"modelData":8,"temp":60,"time":30}]
    property var rightModel:{"modelData":0,"temp":100,"time":30}

    property var workStateEnum:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5}
    property var workStateArray:["停止","预约中","预热中","运行中","烹饪完成","暂停"]

    property var workOperationEnum:{"START":0,"PAUSE":1,"CANCEL":2,"CONFIRM":3,"RUN_NOW":4}

    property var timingStateEnum:{"STOP":0,"RUN":1,"PAUSE":2,"CONFIRM":3}
    property var timingOperationEnum:{"START":1,"CANCEL":2}
    property bool wifiConnecting: false
    property bool wifiConnected:false
    property bool sleepState: false
    Settings {
        id: systemSettings
        category: "system"

        //设置-休眠时间(范围:1-5,单位:分钟 )
        property int sleepTime: 3

        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 255
        //首次开机引导
        property bool firstOpenGuide: true

        property bool wifiEnable: true

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false

        property bool multistageRemind:true
    }

    function scanWifi()
    {
        var Data={}
        Data.WifiScan = null
        setToServer(Data)
    }
    function leftWorkModeFun(n)
    {
        console.log("leftWorkModeFun",n)
        var mode
        switch(n)
        {
        case 1:
            mode=leftWorkMode[1]
            break
        case 2:
            mode=leftWorkMode[2]
            break
        case 35:
            mode=leftWorkMode[3]
            break
        case 36:
            mode=leftWorkMode[4]
            break
        case 38:
            mode=leftWorkMode[5]
            break
        case 40:
            mode=leftWorkMode[6]
            break
        case 42:
            mode=leftWorkMode[7]
            break
        case 72:
            mode=leftWorkMode[8]
            break
        default:
            mode=leftWorkMode[0]
            break
        }
        return mode
    }

    function getDefHistory()
    {
        var param = {}
        param.dishName=""
        param.imgUrl=""
        param.details=""
        param.cookSteps=""
        param.timestamp=Math.floor(Date.now()/1000) //Date.parse(new Date())//(new Date().getTime())
        param.collect=0
        param.cookType=0
        param.cookTime=0
        param.cookPos=0
        return param
    }

    function getDishName(root)
    {
        var dishName=""

        for(var i = 0; i < root.length; i++)
        {
            console.log(root[i].mode,root[i].temp,root[i].time,leftWorkModeFun(root[i].mode))
            if(root.length===1)
            {
                if(root[0].dishName !== undefined)
                {
                    return root[0].dishName
                }

                if(leftDevice===root[i].device)
                    dishName=leftWorkModeFun(root[i].mode)+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
                else
                    dishName=rightWorkMode+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
            }
            else
            {
                dishName+=leftWorkModeFun(root[i].mode)
                if(i!==root.length-1)
                    dishName+="-"
            }
        }
        return dishName
    }

    function setToServer(Data)
    {
        var root={}
        root.Type="SET"
        root.Data=Data
        var json=JSON.stringify(root)
        console.info("setToServer:",json)
        QmlDevState.sendToServer(json)
    }

    function getToServer(Data)
    {
        var root={}
        root.Type="GET"
        root.Data=Data
        var json=JSON.stringify(root)
        console.info("getToServer:",json)
        QmlDevState.sendToServer(json)
    }
    function setCookOperation(device,operation)
    {
        var Data={}
        if(leftDevice===device)
        {
            Data.LStOvOperation=operation
        }
        else
        {
            Data.RStOvOperation=operation
        }
        setToServer(Data)
    }

    function setCooking(list,orderTime,cookPos)
    {
        console.log("setCooking")
        var Data={}
        if(cookPos===leftDevice)
        {
            Data.LStOvMode=list[0].mode
            Data.LStOvSetTimer=list[0].time
            Data.LStOvSetTemp=list[0].temp
            if(undefined !== orderTime && orderTime > 0)
            {
                Data.LStOvOrderTimer=orderTime
            }
            else
            {
                Data.LStOvOperation=workOperationEnum.START
            }
        }
        else
        {
            Data.RStOvMode=list[0].mode
            Data.RStOvSetTimer=list[0].time
            Data.RStOvSetTemp=list[0].temp
            if(undefined !== orderTime && orderTime > 0)
            {
                Data.RStOvOrderTimer=orderTime
            }
            else
            {
                Data.RStOvOperation=workOperationEnum.START
            }
        }
        setToServer(Data)
    }

    function setMultiCooking(list,orderTime,dishName)
    {
        console.log("setMultiCooking")
        var Data={}
        var MultiStageContent=[]

        for(var i = 0; i < list.length; i++)
        {
            var buf={}
            buf.Mode=list[i].mode
            buf.Temp=list[i].temp
            buf.Timer=list[i].time
            MultiStageContent.push(buf)
        }
        if(undefined !== orderTime && orderTime > 0)
        {
            Data.LStOvOrderTimer=orderTime
        }
        else
        {
            Data.LStOvOperation=workOperationEnum.START
        }

        if(undefined === dishName || null === dishName)
        {
            Data.MultiStageContent=MultiStageContent
        }
        else
        {
            Data.CookbookParam=MultiStageContent
            leftDishName=dishName
        }
        setToServer(Data)
    }

    function startCooking(root,cookSteps,orderTime)
    {
        var page=isExistView("pageSteamBakeRun")
        if(page!==null)
            backPage(page)
        else
            backTopPage()

        if(cookSteps.length===1 && (undefined === cookSteps[0].number || 0 === cookSteps[0].number))
        {
            if(leftDevice===cookSteps[0].device)
            {
                QmlDevState.setState("LStOvState",1)
                QmlDevState.setState("LStOvMode",cookSteps[0].mode)
                QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
                QmlDevState.setState("LStOvSetTimerLeft",cookSteps[0].time)
                QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)
            }
            else
            {
                QmlDevState.setState("RStOvState",1)
                QmlDevState.setState("RStOvRealTemp",cookSteps[0].temp)
                QmlDevState.setState("RStOvSetTimerLeft",cookSteps[0].time)
                QmlDevState.setState("RStOvOrderTimerLeft",cookSteps[0].time)
            }
            setCooking(cookSteps,orderTime,root.cookPos)
        }
        else
        {
            QmlDevState.setState("LStOvState",1)
            QmlDevState.setState("LStOvMode",cookSteps[0].mode)
            QmlDevState.setState("LStOvRealTemp",cookSteps[0].temp)
            QmlDevState.setState("LStOvOrderTimerLeft",cookSteps[0].time)

            QmlDevState.setState("cnt",cookSteps.length)
            QmlDevState.setState("current",1)
            if(root.imgUrl!=="")
            {
                setMultiCooking(cookSteps,orderTime,root.dishName)
            }
            else
            {
                setMultiCooking(cookSteps,orderTime)
            }
        }

        QmlDevState.insertHistory(root)
    }

    function closeLoaderMain(){
        loader_main.sourceComponent = null
    }

    function showLoaderError(){
        if(loader_error.status == Loader.Null)
            loader_error.sourceComponent = component_systemError
    }
    function closeLoaderError(){
        loader_error.sourceComponent = null
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
                closeLoaderError()
            }
        }
    }
    function showLoaderFault(hintTopText,hintBottomText){
        loader_error.sourceComponent = component_fault
        loader_error.item.hintTopText=hintTopText
        loader_error.item.hintBottomText=hintBottomText
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

    Component.onCompleted: {
        console.warn("Window onCompleted sleepTime:",systemSettings.sleepTime)
        Backlight.backlightEnable()
        timer_window.start()

        //        var list=Backlight.getAllFileName("x5")
        //        console.log("getAllFileName",list)
    }
    StackView {
        id: stackView
        initialItem: pageHome
        anchors.fill: parent
        enabled:true
    }
    Timer{
        id:timer_window
        repeat: false
        running: false
        interval: systemSettings.sleepTime*30000
        triggeredOnStart: false
        onTriggered: {
            console.log("timer_window sleep!!!!!!!!!!!!")
            if(stackView.depth==1)
            {
                Backlight.backlightDisable()
                sleepState=true
            }
        }
    }
//    MouseArea{
//        anchors.fill: parent
//        hoverEnabled:true
//        propagateComposedEvents: true

//        onPressed: {
//            //            console.warn("Window onPressed................................",sleepState)
//            if(sleepState==true)
//            {
//                sleepState=false
//                Backlight.backlightEnable()
//                mouse.accepted = true
//            }
//            else
//            {
//                mouse.accepted = false
//            }
//            timer_window.restart()
//        }
//        //                onReleased: {
//        //                    console.warn("Window onReleased................................")
//        //                    mouse.accepted = false
//        //                }
//        //                onPositionChanged:{
//        //                console.warn("Window onPositionChanged................................")
//        //                }
//    }
    Loader{
        //加载弹窗组件
        id:loader_main
        anchors.fill: parent
        sourceComponent:null
    }

    Loader{
        //加载弹窗组件
        id:loader_error
        anchors.fill: parent
        sourceComponent:null
    }

    Component{
        id:component_systemError
        Rectangle {
            anchors.fill: parent
            color: "#000"

            Text{
                width:600
                color:"white"
                font.pixelSize: 60
                anchors.centerIn:parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"系统错误,请重启设备"
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled:false
                propagateComposedEvents: false
            }
        }
    }

    ListModel {
        id: wifiModel

        ListElement {
            connected: 1
            ssid: "qwertyuio"
            level:2
            flags:2
        }
        ListElement {
            connected: 0
            ssid: "asdfghjkl定义aa"
            level:2
            flags:0
        }
        ListElement {
            connected: 0
            ssid: "rrrrq"
            level:2
            flags:2
        }
        ListElement {
            connected: 0
            ssid: "wwsf"
            level:2
            flags:2
        }
        ListElement {
            connected: 0
            ssid: "tty-lll"
            level:2
            flags:2
        }
        ListElement {
            connected: 0
            ssid: "744uuu"
            level:2
            flags:2
        }
    }
    Component {
        id: pageTest
        Item {
            SwipeView {
                id: swipeview
                anchors.fill: parent
                currentIndex:0

                interactive:true //是否可以滑动
                //                Item {Image{source: "file:x5/方案一/1.png" }}
                //                Item {Image{source: Qt.resolvedUrl("/test/images/x5/方案一/2.png")}}
                //                Item {Image{source: "/test/x5/上下排版/1.png" }}
                Repeater {
                    id: repeater
                    model: Backlight.getAllFileName("x5")//["A1首页","A2首页左滑"]

                    Item {Image{source: "file:"+modelData }}
                }
            }
            Component.onCompleted: {
                console.log("pageTest onCompleted")

            }
        }
    }
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
        id: pageSteamBakeMultistage
        PageSteamBakeMultistage {}
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
    function isExistView(pageName) {
        console.log("isExistView:",pageName)
        //        return stackView.currentItem.name===PageName
        return stackView.find(function(item,index){
            return item.name === pageName
        })
    }

    function backPrePage() {
        if(stackView.depth>0)
            stackView.pop()
        console.log("stackView depth:"+stackView.depth)
    }

    function backTopPage() {
        if(stackView.depth>0)
            stackView.pop(null)
        console.log("stackView depth:"+stackView.depth)
    }

    function backPage(page) {
        if(stackView.depth>0)
            stackView.pop(page)
        console.log("backPage stackView depth:"+stackView.depth)
    }

    function load_page(page,args) {
        console.log("load_page:"+page,"args:"+args)

        switch (page) {
        case "pageHome":
            stackView.pop(null)
            break;
        case "pageWifi":
            if(systemSettings.wifiEnable)
            {
                if(wifiConnecting==false)
                {
                    scanWifi()
                }
            }
            stackView.push(pageWifi)
            break;
        case "pageSteamBakeBase": //蒸烤设置页面
            stackView.push(pageSteamBakeBase, {"state":args})
            break;
        case "pageSteamBakeMultistage":
            stackView.push(pageSteamBakeMultistage)
            break;
        case "pageMultistageSet":
            stackView.push(pageMultistageSet)
            break;
        case "pageSteamBakeRun": //蒸烤页面
            stackView.push(pageSteamBakeRun, {"state":args})
            break;
        case "pageSteamBakeReserve": //页面
            stackView.push(pageSteamBakeReserve, {"state":args})
            break;
        case "pageSmartRecipes": //页面
            stackView.push(pageSmartRecipes)
            break;
        case "pageCookDetails":
            stackView.push(pageCookDetails, {"state":args})
            break;
        case "pageCookHistory":
            stackView.push(pageCookHistory, {"state":args})
            break;
        case "pageCloseHeat":
            stackView.push(pageCloseHeat)
            break;
        case "pageSet":
            stackView.push(pageSet)
            break;
        case "pageLocalSettings":
            stackView.push(pageLocalSettings)
            break;
        case "pageReset":
            stackView.push(pageReset)
            break;
        case "pageSystemUpdate":
            stackView.push(pageSystemUpdate)
            break;
        case "pageAboutMachine":
            stackView.push(pageAboutMachine)
            break;
        case "pageAfterGuide":
            stackView.push(pageAfterGuide)
            break;
        case "pageReleaseNotes":
            stackView.push(pageReleaseNotes)
            break;
        }

        console.log("stackView depth:"+stackView.depth)
    }
    //获取当前时间方法
    function getCurtime()
    {
        return Qt.formatDateTime(new Date(),"hh:mm")
    }
}
