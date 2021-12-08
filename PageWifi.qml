import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2


Item {
    id:root
    enabled: loader_main.status == Loader.Null && loader_wifiInput.status == Loader.Null
    property bool isHidePwd: false
    property int scan_count: 0

    function signalLevel(rssi)
    {
        if (rssi <= -100)
        {
            return 0
        }
        else if (rssi < -75)
        {
            return 1
        }
        else if (rssi < -55)
        {
            return 2
        }
        else
        {
            return 3
        }
    }

    function encrypType(flags)
    {
        if (flags.indexOf("WPA") !== -1)
        {
            return 1
        }
        else if (flags.indexOf("WEP") !== -1)
        {
            return 2
        }
        else
        {
            return 0
        }
    }


    function setWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        //        console.log("setWifiList:" ,sanR,root.length)
        root.sort(function(a, b){return b.rssi - a.rssi})
        wifiModel.clear()
        var result={}
        for(var i = 0; i < root.length; ++i) {
            if(root[i].ssid==="")
                continue
            result.connected=0

            result.ssid=root[i].ssid
            result.level=signalLevel(root[i].rssi)
            result.flags=encrypType(root[i].flags)

            if(root[i].bssid===QmlDevState.state.bssid)
            {
                result.connected=1
                wifiModel.insert(0,result)
            }
            else
                wifiModel.append(result)
            console.log("result:",QmlDevState.state.bssid,root[i].bssid,root[i].rssi,result.connected,result.ssid,result.level,result.flags)
        }
    }

    function enableWifi(enable)
    {
        systemSettings.wifiEnable=enable
        var Data={}
        Data.WifiEnable = enable
        setToServer(Data)
    }
    function scanWifi()
    {
        var Data={}
        Data.WifiScan = null
        setToServer(Data)
    }
    function scanRWifi()
    {
        var Data={}
        Data.WifiScanR = null
        getToServer(Data)
    }

    function getCurWifi()
    {
        var Data={}
        Data.WifiCurConnected = null
        getToServer(Data)
    }

    function connectWiFi(ssid,psk,encryp)
    {
        var Data={}
        var WifiConnect={}
        WifiConnect.ssid = ssid
        WifiConnect.psk = psk
        WifiConnect.encryp = encryp

        Data.WifiConnect=WifiConnect
        wifiConnecting=true
        setToServer(Data)
    }
    function wifi_scan_timer_reset()
    {
        console.log("wifi_scan_timer_reset")
        scan_count=0
        timer_wifi_scan.interval=1000
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page wifi onStateChanged:",key)

            if("WifiScanR"==key)
            {
                setWifiList(value)
            }
            else if(("WifiState"==key))
            {
                if(value > 1)
                {
                    if(value==2||value==3)
                    {
                        showWifiError(wifiModel.get(0).ssid)
                    }
                    wifi_scan_timer_reset()
                }
                else
                {
                    scanWifi()
                }

            }
        }
    }

    Component.onCompleted: {
        //        VirtualKeyboardSettings.styleName = "retro"
        //        VirtualKeyboardSettings.fullScreenMode=true
        //        console.info("VirtualKeyboardSettings",VirtualKeyboardSettings.availableLocales)
        if(systemSettings.wifiEnable)
        {
            if(wifiConnecting==false)
            {
                scanWifi()
                scanRWifi()
            }
        }
        listView.positionViewAtBeginning()
        console.log("PageWifi onCompleted WifiState:",QmlDevState.state.WifiState,systemSettings.wifiEnable,scan_count)
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
                backPrePage()
            }
        }

        Text{
            width:50
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("网络")
        }

    }
    Timer{

        id:timer_wifi_scan
        repeat: true
        running: systemSettings.wifiEnable
        interval: 1000
        triggeredOnStart: true
        onTriggered: {
            console.log("timer_wifi_scan")
            if(scan_count < 3)
            {
                ++scan_count
                if(scan_count==3)
                {
                    timer_wifi_scan.interval=10000
                }
                if(wifiConnecting==false)
                {
                    getCurWifi()
                    scanRWifi()
                }
            }
            else
            {
                if(wifiConnecting==false && loader_wifiInput.sourceComponent === null)
                {
                    scanWifi()
                    getCurWifi()
                    scanRWifi()
                }
            }
        }
    }

    Component {
        id: headerView

        Item{
            id: headerViewItem
            width: parent.width
            height: 150

            Image {
                id:divider
                anchors.top: wifi_switch.bottom
                anchors.topMargin: 0
                source: "/images/bg/bg_setting_divide_line.png"
            }
            Text {
                text: qsTr("WiFi")
                color: "white"
                font.pixelSize: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: wifi_switch.verticalCenter
            }
            Switch {
                id: wifi_switch
                width: 160
                height:80
                checked:systemSettings.wifiEnable
                anchors.right: parent.right
                anchors.rightMargin: 40

                indicator: Item {
                    implicitWidth: parent.width
                    implicitHeight: parent.height

                    Image{
                        anchors.centerIn: parent
                        source: wifi_switch.checked ?"/images/bg/bg_setting_switch_open.png":"/images/bg/bg_setting_switch_close.png"
                    }
                }
                onCheckedChanged: {
                    console.log("wifi_switch:" + wifi_switch.checked)
                    if(systemSettings.wifiEnable!=wifi_switch.checked)
                        enableWifi(wifi_switch.checked)

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

    // 定义delegate
    Component {
        id: wifiDelegate

        Rectangle {
            id: wrapper
            width: parent.width
            height: 80
            color:"transparent"

            PageBusyIndicator{
                id:busy
                visible: connected==2
                width: 40
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                running: visible
            }
            Text {
                id: wifi_name
                text: qsTr(ssid)

                font.pixelSize: 40
                color:connected==1? "aqua":"#E7E7E7"

                //                elide: Text.ElideRight
                anchors.left: busy.right
                anchors.leftMargin: 20
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
                    visible: flags > 0
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
                            connectWiFi(ssid,"",flags)
                            connected=2
                            wifiModel.setProperty(0,"connected",0)
                            wifiModel.move(index,0,1)
                            //                            wifiModel.setProperty(0,"connected",2)
                            listView.positionViewAtBeginning()
                        }
                        else
                            showWifiInput(index,listView.model.get(index))
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
            clip: true
            highlightRangeMode: ListView.ApplyRange

            //            snapMode: ListView.SnapToItem
            //            boundsBehavior:Flickable.StopAtBounds

            // 连接信号槽
            //            Component.onCompleted: {

            //            }
            onFlickStarted:{
                console.info("ListView flickStarted")
            }

        }
    }
    Component{
        id:component_wifiInput

        Rectangle{
            id:wifiInput
            anchors.fill: parent
            property string wifi_ssid
            property int wifi_flags
            property int index
            property bool permit_connect:false

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //                    textField.focus=false
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
                    anchors.leftMargin: 20
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
                    font.pixelSize: 40
                    anchors.left:goBack.right
                    anchors.verticalCenter: parent.verticalCenter
                    text:"密码"
                }
                Text{
                    id:wifiName
                    width:300
                    color:"#9AABC2"
                    font.pixelSize: 40
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
                    checked:false
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
                        color:permit_connect?"#9AABC2":"white"
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
                        if(permit_connect)
                        {
                            connectWiFi(wifi_ssid,textField.text,wifi_flags)
                            //                        sleep(100)
                            wifiModel.setProperty(0,"connected",0)
                            wifiModel.setProperty(index,"connected",2)
                            wifiModel.move(index,0,1)

                            listView.positionViewAtBeginning()
                            dismissWifiInput()
                        }
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
                        anchors.top: parent.bottom
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

                            activeFocusOnPress:true
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
                                //                                vkb.visible = true //当选择输入框的时候才显示键盘
                            }
                            onTextEdited:{
                                console.log("onTextEdited len:",length)
                                if(length>=8)
                                {
                                    permit_connect=true
                                }
                                else
                                {
                                    permit_connect=false
                                }
                            }
                            //                            onTextChanged: {//text属性信号处理
                            //                                   console.log("TonTextChanged len:", length)
                            //                            }
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
                visible: true
                active:true
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                //这种集成方式下点击隐藏键盘的按钮是没有效果的，
                //只会改变active，因此我们自己处理一下
                onActiveChanged: {
                    //                    if(!active) { visible = false }
                }
            }
            Component.onCompleted: {

                textField.forceActiveFocus()
                console.log("textField",textField.activeFocus,wifiInput.activeFocus,vkb.activeFocus)
            }
        }
    }
    function showWifiInput(index,wifiInfo){
        loader_wifiInput.sourceComponent = component_wifiInput
        console.log("showWifiInput:" , wifiInfo.ssid,wifiInfo.flags)
        loader_wifiInput.item.wifi_ssid=wifiInfo.ssid
        loader_wifiInput.item.wifi_flags=wifiInfo.flags
        loader_wifiInput.item.index=index
    }
    function dismissWifiInput(){
        loader_wifiInput.sourceComponent = null
    }
    Component{
        id:component_wifiError
        PageDialog{
            hint_text:"密码不正确"
            confirm_text:"好"
            checkbox_visible:false
            onCancel:{
                console.info("onCancel")
                closeWifiError()
            }
            onConfirm:{
                console.info("onConfirm")
                closeWifiError()
            }
        }
    }
    function showWifiError(ssid){
        loader_main.sourceComponent = component_wifiError
        loader_main.item.hint_text=ssid+"\n密码不正确"
    }

    function closeWifiError(){
        loader_main.sourceComponent = null
    }
    Loader{
        //加载弹窗组件
        id:loader_wifiInput
        anchors.fill: parent

    }

}
