import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import QmlWifi 1.0

Item {
    id:root
    property bool isHidePwd: false

    Component.onCompleted: {
        if(systemSettings.wifiSwitch)
            getWifiList()
        VirtualKeyboardSettings.styleName = "retro"
    }

    function getWifiList()
    {
        var sanResArr = qmlWifi.getWiFiScanResult();
        console.log("init WiFi ScanResult:" ,sanResArr.length)
        wifiModel.clear()
        for(var i = 0; i < sanResArr.length; ++i) {
            //            console.log(sanResArr[i].ssid)
            wifiModel.append(sanResArr[i])
        }
    }

    QmlWifi{
        id:qmlWifi
        onWifiEvent:{
            console.log("WiFi status:" ,event)
        }
    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }

        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage();
            }
        }

        Text{
            width:50
            color:"#9AABC2"
            font.pixelSize: fontSize
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("网络")
        }

    }
    Timer{
        property bool scan_wifi: false
        id:timer_wifi_scan
        repeat: true
        running: systemSettings.wifiSwitch
        interval: 5000
        triggeredOnStart: true
        onTriggered: {
            console.log("timer_wifi_scan")
            if(scan_wifi)
            {
                getWifiList()
            }
            else
            {
                qmlWifi.scanWiFi()
            }
            scan_wifi=!scan_wifi
        }
    }

    Component {
        id: headerView

        Item{
            id: headerViewItem
            width: parent.width
            height: 120

            Image {
                id:divider
                anchors.top: parent.top
                anchors.topMargin: 85
                source: "/images/bg/bg_setting_divide_line.png"
            }
            Text {
                text: qsTr("WiFi")
                color: "white"
                font.pixelSize: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
            }
            Switch {
                id: wifi_switch
                width: 160
                height:85
                checked:systemSettings.wifiSwitch
                anchors.right: parent.right
                anchors.rightMargin: 40

                indicator: Item {
                    implicitWidth: 160
                    implicitHeight: 85

                    Image{
                        anchors.centerIn: parent
                        source: wifi_switch.checked ?"/images/bg/bg_setting_switch_open.png":"/images/bg/bg_setting_switch_close.png"
                    }
                }
                onCheckedChanged: {
                    console.log("WiFi开关:" + wifi_switch.checked)
                    systemSettings.wifiSwitch=wifi_switch.checked
                    qmlWifi.enableWiFi(wifi_switch.checked)
                    if(wifi_switch.checked)
                    {
                    }
                    else
                    {
                        wifiModel.clear()
                    }
                }

            }
            Text {
                text: qsTr("可用WiFi列表")
                color: "#7286A3"
                font.pixelSize: 32
                anchors.top: divider.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 40
            }
        }
    }
    ListModel {
        id: wifiModel

        ListElement {
            connected: true
            ssid: "qwertyuio"
            level:2
            flags:2
        }
        ListElement {
            connected: false
            ssid: "asdfghjklaaa"
            level:2
            flags:2
        }
    }
    // 定义delegate
    Component {
        id: wifiDelegate

        Rectangle {
            id: wrapper
            width: parent.width
            height: 80
            color:"transparent"

            Text {
                id: wifi_name
                text: qsTr(ssid)

                font.pixelSize: 40
                color:connected? "aqua":"#E7E7E7"

                elide: Text.ElideRight
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onWidthChanged: {

                }
            }
            Image{
                width: parent.width
                source: "/images/bg/bg_setting_divide_line.png"
                anchors.bottom: parent.bottom
            }
            Image {
                id: wifi_level
                width: 40
                height: 32
                anchors.right: parent.right
                anchors.rightMargin:  30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 13
                source: {
                    var res

                    if(level === 0){
                        res = "images/wifi/icon_wifi_signal_01.png"
                    }else if(level === 1){
                        res = "images/wifi/icon_wifi_signal_02.png"
                    }else if(level === 2){
                        res = "images/wifi/icon_wifi_signal_03.png"
                    }else if(level >= 3){
                        res = "images/wifi/icon_wifi_signal_04.png"
                    }
                    return res
                }
                Image{
                    anchors.fill: parent
                    anchors.centerIn: parent
                    visible: flags>QmlWifi.NONE
                    source: "images/wifi/icon_wifi_signal_lock.png"
                }

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("WiFi name:" + wifi_name.text)
                    if(connected==false)
                    {
                        if(flags==0)
                        {
                            console.log("open connect:" , ssid,flags)
                            var connect_ret=qmlWifi.connectWiFi(ssid,"",flags)
                            console.log("open connectWiFi ret:" ,connect_ret)
                            if(connect_ret===0)
                            {
                                getWifiList()
                                listView.currentIndex = 0
                            }
                        }
                        else
                            showWifiInput(listView.model.get(index));
                    }
                }
            }
        }
    }
    //内容
    Rectangle{
        id:wrapper
        width:parent.width
        height:parent.height-topBar.height
        anchors.top:topBar.bottom
        color:"#000"
        Image {
            source: "/images/main_menu/dibuyuans.png"
            anchors.bottom:parent.bottom
        }

        ListView {
            id: listView
            anchors.fill: parent
            interactive: true
            delegate: wifiDelegate
            model: wifiModel

            header: headerView
            focus: true
            //            highlightRangeMode: ListView.StrictlyEnforceRange
            //            highlightFollowsCurrentItem: true
            //            snapMode: ListView.SnapToItem

            // 连接信号槽
            //            Component.onCompleted: {

            //            }

        }
    }
    Component{
        id:component_wifiInput

        Rectangle{
            id:wifiInput
            anchors.fill: parent
            property string wifi_ssid
            property int wifi_flags
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    textField.focus=false
                }
            }
            ToolBar {
                id:topBar
                width:parent.width
                anchors.top:parent.top
                height:96
                Image {
                    anchors.fill: parent
                    source: "/images/main_menu/zhuangtai_bj.png"
                }

                //back图标
                TabButton {
                    id:goBack
                    width:40
                    height:parent.height
                    anchors.left:parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        anchors.centerIn: parent
                        source: "/images/fanhui.png"
                    }
                    background: Rectangle {
                        opacity: 0
                    }
                    onClicked: {
                        dismissWifiInput()
                    }
                }
                Text{
                    width:40
                    color:"#9AABC2"
                    font.pixelSize: fontSize
                    anchors.left:goBack.right
                    anchors.verticalCenter: parent.verticalCenter
                    text:"密码"
                }
                Text{
                    id:wifiName
                    width:300
                    color:"#9AABC2"
                    font.pixelSize: fontSize
                    elide: Text.ElideRight

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:wifi_ssid
                }
                TabButton {
                    id:connect
                    width:120
                    height:parent.height
                    anchors.right:parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    //                    text: qsTr("连接")
                    //                    font.pixelSize: 40

                    //                    contentItem: Text{
                    //                        color:"#9AABC2"
                    //                        font.pixelSize: 40
                    //                        text:connect.text
                    //                        elide: Text.ElideRight
                    //                        horizontalAlignment: Text.AlignHCenter
                    //                        verticalAlignment: Text.AlignVCenter
                    //                    }
                    Text{
                        id:stepName
                        color:"#9AABC2"
                        font.pixelSize: 40
                        anchors.centerIn:parent
                        text: qsTr("连接")
                    }
                    background: Rectangle {
                        opacity: 0
                        //                        color:"transparent"
                    }
                    onClicked: {
                        console.log("Button connect:" , wifi_ssid,textField.text,wifi_flags)
                        var connect_ret=qmlWifi.connectWiFi(wifi_ssid,textField.text,wifi_flags)
                        console.log("connectWiFi ret:" ,connect_ret)
                        if(connect_ret===0)
                        {
                            getWifiList()
                            listView.currentIndex = 0
                        }
                        dismissWifiInput()
                    }
                }
            }

            Rectangle{
                width:parent.width
                anchors.left: parent.left
                anchors.top:topBar.bottom
                anchors.bottom: parent.bottom
                color:"#000"
                Image {
                    id:botImg
                    width:parent.width
                    anchors.bottom:parent.bottom
                    source: "/images/main_menu/dibuyuans.png"
                }

                Frame{
                    id:frame
                    //                    width:parent.width
                    height: 90
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    background: Rectangle{
                        anchors.fill: parent
                        color:"transparent"
                    }
                    Image {
                        anchors.top: rowLayout.bottom
                        source: "/images/bg/bg_setting_divide_line.png"
                    }
                    RowLayout{
                        id:rowLayout
                        anchors.fill: parent
                        TextField {
                            id:textField
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            leftPadding: 20
                            rightPadding: 20
                            font.pixelSize: 40
                            color: "#ECF4FC"
                            echoMode: root.isHidePwd?TextInput.Password:TextInput.Normal
                            passwordCharacter: "*"
                            passwordMaskDelay: 1
                            placeholderText: qsTr("请输入密码")

                            overwriteMode: false
                            inputMethodHints:Qt.ImhNoAutoUppercase

                            maximumLength: 30
                            focus: true
                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                                //                                opacity: 0
                            }
                            onPressed: {
                                vkb.visible = true; //当选择输入框的时候才显示键盘
                            }
                        }
                        Item{
                            width: 60
                            height: parent.height
                            Image{
                                anchors.centerIn: parent
                                source: root.isHidePwd?"/images/icon_pwd_invisible.png":"/images/icon_pwd_visible.png"
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    root.isHidePwd = !root.isHidePwd
                                }
                            }
                        }
                    }
                }
            }
            InputPanel {
                id: vkb
                visible: false
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                //这种集成方式下点击隐藏键盘的按钮是没有效果的，
                //只会改变active，因此我们自己处理一下
                onActiveChanged: {
                    if(!active) { visible = false; }
                }
            }
        }
    }
    function showWifiInput(wifiInfo){
        loader_wifiInput.sourceComponent = component_wifiInput
        console.log("showWifiInput:" , wifiInfo.ssid,wifiInfo.flags)
        loader_wifiInput.item.wifi_ssid=wifiInfo.ssid
        loader_wifiInput.item.wifi_flags=wifiInfo.flags
    }
    function dismissWifiInput(){
        loader_wifiInput.sourceComponent = null
    }
    Loader{
        //加载弹窗组件
        id:loader_wifiInput
        anchors.fill: parent

    }
}
