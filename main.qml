import QtQuick 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

import "pageSteamAndBake"

ApplicationWindow {
    property var leftWorkModeArr:["左腔","经典蒸","快速蒸","热风烧烤","上下加热","立体热风","蒸汽烤","空气炸","保温烘干"]
    property string rightWorkMode:"小腔速蒸"
    property var leftModel:[{"modelData":"经典蒸","temp":100,"time":30},{"modelData":"快速蒸","temp":120,"time":20},{"modelData":"热风烧烤","temp":200,"time":60}
        ,{"modelData":"上下加热","temp":180,"time":120},{"modelData":"立体热风","temp":180,"time":120},{"modelData":"蒸汽烤","temp":150,"time":60}
        ,{"modelData":"空气炸","temp":220,"time":30},{"modelData":"保温烘干","temp":60,"time":30}]
    property var rightModel:{"modelData":"便捷蒸","temp":100,"time":30}
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

        property bool wifiSwitch: true

        //判断儿童锁(true表示锁定，false表示未锁定)
        property bool childLock:false
    }

    function getDefHistory()
    {
        var param = {};
        param.id=0
        param.dishCook=0
        param.dishName=""
        param.dishCookTime=0
        param.imgSource=""
        param.details=""
        param.cookSteps=""
        param.collection=false
        param.time=0
        return param
    }

    function getDishName(root)
    {
        var dishName=""
        for(let i = 0; i < root.length; i++)
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
    id: window
    visible: true
    width: 800
    height: 480
    title: qsTr("X5")

    StackView {
        id: stackView
        initialItem: pageHome
        anchors.fill: parent

    }
    Component {
        id: pagepathview
        DataPathView {

            width: 100
            height:480
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
        }

        console.log("stackView depth:"+stackView.depth)
    }
    //获取当前时间方法
    function getCurtime()
    {
        return Qt.formatDateTime(new Date(),"hh:mm")
    }
}
