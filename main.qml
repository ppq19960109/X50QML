import QtQuick 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

import "pageSteamAndBake"
import "pageSet"
ApplicationWindow {
    property var leftWorkModeArr:["左腔","经典蒸","快速蒸","热风烧烤","上下加热","立体热风","蒸汽烤","空气炸","保温烘干"]
    property string rightWorkMode:"小腔速蒸"
    property var leftModel:[{"modelData":"经典蒸","temp":100,"time":30},{"modelData":"快速蒸","temp":120,"time":20},{"modelData":"热风烧烤","temp":200,"time":60}
        ,{"modelData":"上下加热","temp":180,"time":120},{"modelData":"立体热风","temp":180,"time":120},{"modelData":"蒸汽烤","temp":150,"time":60}
        ,{"modelData":"空气炸","temp":220,"time":30},{"modelData":"保温烘干","temp":60,"time":30}]
    property var rightModel:{"modelData":"便捷蒸","temp":100,"time":30}
    property var devWorkState:{"WORKSTATE_STOP":0,"WORKSTATE_RESERVE":1,"WORKSTATE_PREHEAT":2,"WORKSTATE_RUN":3,"WORKSTATE_FINISH":4,"WORKSTATE_PAUSE":5}

    property bool wifi_connecting: false
    property bool wifiConnected:false
    Settings {
        id: systemSettings
        category: "system"
        //协议
        property bool steamAgreement: false
        property bool ovenAgreement: false

        //设置-休眠时间(范围:1-5,单位:分钟 )
        property int standbyTime: 3
        //待机显示样式类型(clock\digital\none)
        property string standbyType: "none"
        //设置-日期和时间-自动设置开关状态
        property bool dateSettingAuto:true
        //运行期间临时保存设置的亮度值，在收到开机状态是把该值重新设置回去 设置-屏幕亮度
        property int brightness: 255
        //首次开机引导
        property bool firstOpenGuide: true

        property bool wifiEnable: true

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false
    }

    function getDefHistory()
    {
        var param = {};

        param.dishName=""
        param.imgUrl=""
        param.details=""
        param.cookSteps=""
        param.timestamp=0
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
            console.log(root[i].mode,root[i].temp,root[i].time,leftWorkModeArr[root[i].mode])
            //            console.log("getDishName dishName",root[i].dishName==null)
            if(root[i].dishName!=null)
            {
                console.log("dishName",root[i].dishName)
                dishName=root[i].dishName
                break
            }

            if(root.length===1)
            {
                if(0===root[i].device)
                    dishName=leftWorkModeArr[root[i].mode]+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
                else
                    dishName=rightWorkMode+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
            }
            else
            {
                dishName+=leftWorkModeArr[root[i].mode]
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

                Item {Image{source: "file:x5/方案一/1.png" }}
                Item {Image{source: Qt.resolvedUrl("/test/images/x5/方案一/2.png")}}
                //                Item {Image{source: "/test/images/x5/方案一/3.png" }}
                //                Item {Image{source: "/test/images/x5/方案一/4.png" }}
                //                Item {Image{source: "/test/images/x5/方案一/5.png" }}

                //                Item {Image{source: "/test/images/x5/方案二/A1.png" }}
                //                Item {Image{source: "/test/images/x5/方案二/A2.png" }}
                //                Item {Image{source: "/test/images/x5/方案二/A3.png" }}
                //                Item {Image{source: "/test/images/x5/方案二/A4.png" }}
                //                Item {Image{source: "/test/images/x5/方案二/A4 拷贝.png" }}
                //                Item {Image{source: "/test/images/x5/方案二/A4 拷贝 2.png" }}

                //                Item {Image{source: "/test/images/x5/方案三/B1.png" }}
                //                Item {Image{source: "/test/images/x5/方案三/B2.png" }}
                //                Item {Image{source: "/test/images/x5/方案三/B3.png" }}
                //                Item {Image{source: "/test/images/x5/方案三/B4.png" }}
                //                Item {Image{source: "/test/images/x5/方案三/B5.png" }}

                //                Item {Image{source: "/test/images/x5/方案四.png" }}

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
            stackView.pop();
        console.log("stackView depth:"+stackView.depth)
    }

    function backTopPage() {
        if(stackView.depth>0)
            stackView.pop(null);
        console.log("stackView depth:"+stackView.depth)
    }

    function backPage(page) {
        if(stackView.depth>0)
            stackView.pop(page);
        console.log("stackView depth:"+stackView.depth)
    }

    function load_page(page,args) {
        console.log("load_page:"+page,"args:"+args)

        switch (page) {
        case "pageHome":
            stackView.pop(null);
            break;
        case "pageWifi":
            stackView.push(pageWifi);
            break;
        case "pageSteamBakeBase": //蒸烤设置页面
            stackView.push(pageSteamBakeBase, {"state":args});
            break;
        case "pageSteamBakeMultistage":
            stackView.push(pageSteamBakeMultistage);
            break;
        case "pageMultistageSet":
            stackView.push(pageMultistageSet);
            break;
        case "pageSteamBakeRun": //蒸烤页面
            stackView.push(pageSteamBakeRun, {"state":args});
            break;
        case "pageSteamBakeReserve": //页面
            stackView.push(pageSteamBakeReserve, {"state":args});
            break;
        case "pageSmartRecipes": //页面
            stackView.push(pageSmartRecipes);
            break;
        case "pageCookDetails":
            stackView.push(pageCookDetails, {"state":args});
            break;
        case "pageCookHistory":
            stackView.push(pageCookHistory);
            break;
        case "pageCloseHeat":
            stackView.push(pageCloseHeat);
            break;
        case "pageSet":
            stackView.push(pageSet);
            break;
        case "pageLocalSettings":
            stackView.push(pageLocalSettings);
            break;
        case "pageReset":
            stackView.push(pageReset);
            break;
        case "pageSystemUpdate":
            stackView.push(pageSystemUpdate);
            break;
        case "pageAboutMachine":
            stackView.push(pageAboutMachine);
            break;
        case "pageAfterGuide":
            stackView.push(pageAfterGuide);
            break;
        case "pageReleaseNotes":
            stackView.push(pageReleaseNotes);
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
