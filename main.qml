import QtQuick 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

import "pageSteamAndBake"
import "pageSet"
ApplicationWindow {
    property int leftDevice:0
    property int rightDevice:1

    property var leftWorkMode: ["未设定", "经典蒸", "快速蒸", "热风烧烤", "上下加热", "立体热风", "蒸汽烤", "空气炸", "保温烘干"]
    property var leftWorkModeNumber:[0,1,2,35,36,38,40,42,72]
    property string rightWorkMode:"小腔速蒸"

    property var leftModel:[{"modelData":"经典蒸","temp":100,"time":30},{"modelData":"快速蒸","temp":120,"time":20},{"modelData":"热风烧烤","temp":200,"time":60}
        ,{"modelData":"上下加热","temp":180,"time":120},{"modelData":"立体热风","temp":180,"time":120},{"modelData":"蒸汽烤","temp":150,"time":60}
        ,{"modelData":"空气炸","temp":220,"time":30},{"modelData":"保温烘干","temp":60,"time":30}]
    property var rightModel:{"modelData":"便捷蒸","temp":100,"time":30}

    property var workStateEnum:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5}
    property var workStateArray:["停止","预约中","预热中","运行中","烹饪完成","暂停"]

    property var workOperationEnum:{"START":0,"PAUSE":1,"CANCEL":2,"CONFIRM":3,"RUN_NOW":4}

    property bool wifiConnecting: false
    property bool wifiConnected:false

    Settings {
        id: systemSettings
        category: "system"

        //设置-休眠时间(范围:1-5,单位:分钟 )
        property int standbyTime: 3

        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 255
        //首次开机引导
        property bool firstOpenGuide: true

        property bool wifiEnable: true

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false
    }

    function leftWorkModeFun(n)
    {
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

    function setCooking(list)
    {
        console.log("setCooking")
        var Data={}
        if(list[0].device===leftDevice)
        {
            Data.LStOvMode=list[0].mode
            Data.LStOvSetTimer=list[0].time
            Data.LStOvSetTemp=list[0].temp
            if(undefined === list[0].orderTime)
            {
                Data.LStOvOperation=workOperationEnum.START
            }
            else
            {
                Data.LStOvOrderTimer=list[0].orderTime
            }
        }
        else
        {
            Data.RStOvMode=list[0].mode
            Data.RStOvSetTimer=list[0].time
            Data.RStOvSetTemp=list[0].temp
            if(undefined === list[0].orderTime)
            {
                Data.RStOvOperation=workOperationEnum.START
            }
            else
            {
                Data.RStOvOrderTimer=list[0].orderTime
            }
        }
        setToServer(Data)
    }

    function setMultiCooking(list)
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
        if(undefined === list[0].orderTime)
        {
            Data.LStOvOperation=workOperationEnum.START
        }
        else
        {
            Data.LStOvOrderTimer=list[0].orderTime
        }
        Data.MultiStageContent=MultiStageContent
        setToServer(Data)
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
    id: window
    width: 800
    height: 480
    visible: true

    StackView {
        id: stackView
        initialItem: pageHome
        anchors.fill: parent

    }

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
            ssid: "234556"
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


                Item {Image{source: "/test/x5/上下排版/1.png" }}

                Item {Image{source: "/test/x5/粗体字/1.png" }}
                Item {Image{source: "/test/x5/D1左空右腔体.png" }}
                Item {Image{source: "/test/x5/粗体字/2.png" }}
                Item {Image{source: "/test/x5/粗体字/3.png" }}
                Item {Image{source: "/test/x5/粗体字/4.png" }}
                Item {Image{source: "/test/x5/粗体字/5.png" }}

                Item {Image{source: "/test/x5/细体字/1.png" }}
                Item {Image{source: "/test/x5/细体字/2.png" }}
                Item {Image{source: "/test/x5/细体字/3.png" }}

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
            stackView.push(pageCookHistory)
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
