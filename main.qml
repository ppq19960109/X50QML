import QtQuick 2.2
import QtQuick.Controls 2.2
import Qt.labs.settings 1.0

import "pageSteamAndBake"

ApplicationWindow {
    property  int  fontSize:40

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
            stackView.push(pageSteamBakeBase);
            break;
        case "pageSteamBakeMultistage": //蒸烤设置页面
            stackView.push(pageSteamBakeMultistage);
            break;
        case "pageMultistageSet": //蒸烤设置页面
            stackView.push(pageMultistageSet);
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
