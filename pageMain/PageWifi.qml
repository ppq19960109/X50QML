import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
//import QtQuick.VirtualKeyboard.Settings 2.2

import "qrc:/WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
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
                if(wifiConnected==false)
                    wifiConnected=true
                result.connected=1
                wifiModel.insert(0,result)
            }
            else
                wifiModel.append(result)
            console.log("result:",QmlDevState.state.bssid,root[i].bssid,root[i].rssi,result.connected,result.ssid,result.level,result.flags)
        }
        if(QmlDevState.state.bssid=="")
        {
            wifiConnected=false
        }
    }

    function getCurWifi()
    {
        var Data={}
        Data.WifiCurConnected = null
        SendFunc.getToServer(Data)
    }

    function wifi_scan_timer_reset()
    {
        console.log("wifi_scan_timer_reset")
        SendFunc.scanWifi()
        scan_count=0
        timer_wifi_scan.interval=1000
        timer_wifi_scan.restart()
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page wifi onStateChanged:",key)

            if("WifiScanR"==key)
            {
                setWifiList(value)
            }
            else if("WifiState"==key)
            {
                console.log("page wifi WifiState:",value)
                if(value > 1)
                {
                    if(value==2||value==3|| value==5)
                    {
                        showLoaderFaultImg("/x50/icon/icon_pop_th.png","联网超时，请重试")
                    }
                    else if(value==4)
                    {
                        dismissWifiInput()
                        //                        showQrcodeBind("连接成功！")
                    }
                    wifi_scan_timer_reset()
                }
                else
                {
                    SendFunc.scanWifi()
                }

            }
            else if("WifiEnable"==key)
            {
                if(value==1)
                    wifi_scan_timer_reset()
            }
        }
    }

    Component.onCompleted: {
        //        VirtualKeyboardSettings.styleName = "retro"
        //        VirtualKeyboardSettings.fullScreenMode=true
        //        console.info("VirtualKeyboardSettings",VirtualKeyboardSettings.availableLocales)

        listView.positionViewAtBeginning()
        console.log("PageWifi onCompleted WifiState:",QmlDevState.state.WifiState,systemSettings.wifiEnable,scan_count)
    }

    Timer{

        id:timer_wifi_scan
        repeat: true
        running: systemSettings.wifiEnable
        interval: 1000
        triggeredOnStart: scan_count < 3?true:false
        onTriggered: {
            console.log("timer_wifi_scan",timer_wifi_scan.interval,scan_count,wifiConnecting)
            if(scan_count < 3)
            {
                ++scan_count
                if(scan_count==1)
                {
                    timer_wifi_scan.interval=2000
                }
                else if(scan_count==3)
                {
                    timer_wifi_scan.interval=15000
                }
                if(wifiConnecting==false && loader_wifiInput.sourceComponent === null)
                {
                    getCurWifi()
                    SendFunc.scanRWifi()
                }
            }
            else
            {
                if(wifiConnecting==false && loader_wifiInput.sourceComponent === null)
                {
                    SendFunc.scanWifi()
                    getCurWifi()
                    SendFunc.scanRWifi()
                }
            }
        }
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("网络")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onLeftClick:{
        }
        onRightClick:{

        }
        onClose:{
            backPrePage()
        }
    }
    Component {
        id: headerView

        Item{
            id: headerViewItem
            width: parent.width
            height: 180

            PageDivider{
                id:divider
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 120
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
                //                width: indicatorImg.width
                //                height:indicatorImg.height
                checked:systemSettings.wifiEnable

                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.top: parent.top
                anchors.topMargin: 65

                indicator: Item {
                    implicitWidth: indicatorImg.width
                    implicitHeight: indicatorImg.height

                    Image{
                        id:indicatorImg
                        asynchronous:true
                        anchors.centerIn: parent
                        source: wifi_switch.checked ?"/x50/wifi/kai.png":"/x50/wifi/guan.png"
                    }
                }
                onCheckedChanged: {
                    console.log("wifi_switch:" + wifi_switch.checked)
                    if(systemSettings.wifiEnable!=wifi_switch.checked)
                        SendFunc.enableWifi(wifi_switch.checked)

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
                visible: systemSettings.wifiEnable
                text: qsTr("可用WiFi列表")
                color: Qt.rgba(255,255,255,0.35)
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

        Item {
            width: parent.width
            height: 90

            Item {
                id:indicator
                width: 40
                height: 40
                //                border.color: "#fff"
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20

                PageRotationImg {
                    visible: connected==2
                    anchors.centerIn: parent
                    source: "/x50/wifi/icon_sx.png"
                }
                Image{
                    asynchronous:true
                    visible: connected==1
                    anchors.centerIn: parent
                    source: "/x50/wifi/icon_selected.png"
                }
            }
            Text {
                id: wifi_name
                text: ssid

                font.pixelSize: 40
                color:connected==1? themesTextColor:"#FFF"
                elide: Text.ElideRight
                anchors.left: indicator.right
                anchors.leftMargin: 20
//                anchors.bottom: parent.bottom
//                anchors.bottomMargin: 15
                anchors.verticalCenter: parent.verticalCenter
//                horizontalAlignment:Text.AlignHCenter
//                verticalAlignment:Text.AlignVCenter
            }
            PageDivider{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
            Image {
                id: wifi_level
                asynchronous:true
                anchors.right: parent.right
                anchors.rightMargin:  53
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                source: {
                    var res
                    if(level === 0){
                        res = "/x50/wifi/yousuowifi 1.png"
                    }else if(level === 1){
                        res = "/x50/wifi/yousuowifi 2.png"
                    }else if(level === 2){
                        res = "/x50/wifi/yousuowifi 3.png"
                    }else if(level >= 3){
                        res = "/x50/wifi/yousuowifi 4.png"
                    }
                    return res
                }
                Image{
                    asynchronous:true
                    anchors.fill: parent
                    anchors.centerIn: parent
                    visible: flags > 0
                    source: "/x50/wifi/yousuowifi 5.png"
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
                            SendFunc.connectWiFi(ssid,"",flags)
                            connected=2
                            wifiModel.setProperty(0,"connected",0)
                            wifiModel.move(index,0,1)
                            //                            wifiModel.setProperty(0,"connected",2)
                            listView.positionViewAtBeginning()
                        }
                        else
                        {
                            var wifiInfo=WifiFunc.getWifiInfo(ssid)
                            console.log("wifiInfo",wifiInfo,typeof wifiInfo)
                            if(wifiInfo==null)
                            {
                                showWifiInput(index,listView.model.get(index))
                            }
                            else
                            {
                                SendFunc.connectWiFi(wifiInfo.ssid,wifiInfo.psk,wifiInfo.encryp)
                                connected=2
                                wifiModel.setProperty(0,"connected",0)
                                wifiModel.move(index,0,1)
                                listView.positionViewAtBeginning()
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: footerView
        Item {
            width: 40
            height: 40
            visible: systemSettings.wifiEnable && listView.count<=1

            anchors.left: parent.left
            anchors.leftMargin: 40

            PageRotationImg {
                anchors.centerIn: parent
                source: "/x50/wifi/icon_sx.png"
            }
        }
    }
    //内容
    Item{

        width:parent.width
        anchors.top:parent.top
        anchors.bottom:topBar.top

        ListView {
            id: listView
            anchors.fill: parent
            interactive: true
            delegate: wifiDelegate
            model: wifiModel

            header: headerView
            clip: true
            highlightRangeMode: ListView.ApplyRange
            //            snapMode: ListView.SnapToItem
            //            boundsBehavior:Flickable.StopAtBounds
            footer: footerView
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
            property int index
            property bool permit_connect:false
            color:themesWindowBackgroundColor

            //            MouseArea{
            //                anchors.fill: parent
            //                onClicked: {
            //                    textField.focus=false
            //                }
            //            }

            PageBackBar{
                id:topBar
                anchors.bottom:parent.bottom
                name:"网络"
                centerText:wifi_ssid
                leftBtnText:qsTr("")
                rightBtnText:qsTr("")
                onClose:{
                    wifiConnecting=false
                    SendFunc.scanRWifi()
                    dismissWifiInput()
                }
            }

            Item{
                id:inputtext
                width:parent.width
                //                anchors.bottom:topBar.top
                height: 100
                anchors.top: parent.top

                PageDivider{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }

                //                    PageBusyIndicator{
                //                        id:connectBusy
                //                        anchors.right:connectBtn.left
                //                        anchors.rightMargin: 15
                //                        anchors.verticalCenter: parent.verticalCenter
                //                        visible: false
                //                        running: visible
                //                    }

                PageRotationImg {
                    id: connectBusy
                    visible: wifiConnecting==true?true:false
                    anchors.right:connectBtn.left
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/x50/wifi/icon_sx.png"
                }
                Button {
                    id:connectBtn
                    width:160
                    height:parent.height
                    anchors.right:parent.right
                    anchors.rightMargin: 40
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
                        id:connectText
                        color:permit_connect?themesTextColor:"white"
                        font.pixelSize: 40
                        anchors.centerIn:parent
                        text: wifiConnecting==true?"正在连接":qsTr("连接")
                    }
                    background: Item {}
                    onClicked: {
                        console.log("Button connect:" , wifi_ssid,textField.text,wifi_flags)
                        if(permit_connect)
                        {
                            SendFunc.connectWiFi(wifi_ssid,textField.text,wifi_flags)
                        }
                    }
                }
                TextField {
                    id:textField
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: connectBtn.left
                    leftPadding: 40
                    rightPadding: 20
                    font.pixelSize: 40
                    color: "#ECF4FC"
                    echoMode: TextInput.Normal//TextInput.Password:TextInput.Normal
                    passwordCharacter: "*"
                    passwordMaskDelay: 1
                    placeholderText: qsTr("密码")

                    activeFocusOnPress:true
                    overwriteMode: false
                    inputMethodHints:Qt.ImhNoAutoUppercase

                    onAccepted: {
                        console.log("onAccepted")
                        //                            textField.focus = true    /* 结束输入操作行为 */
                    }
                    focus: true
                    background: Item {
                    }
                    onPressed: {
                        vkb.visible = true //当选择输入框的时候才显示键盘
                    }
                    onTextEdited:{
                        if(length>=8)
                        {
                            permit_connect=true
                        }
                        else
                        {
                            permit_connect=false
                        }
                    }
                }
            }
            InputPanel {
                id: vkb
                visible: true
                width: parent.width
                height: parent.height
                anchors.bottom: parent.bottom


                //这种集成方式下点击隐藏键盘的按钮是没有效果的，
                //只会改变active，因此我们自己处理一下
                onActiveChanged: {
                    if(!active) { visible = false }
                }
            }
            Component.onCompleted: {

                textField.forceActiveFocus()
            }
        }
    }
    function showWifiInput(index,wifiInfo){
        loader_wifiInput.sourceComponent = component_wifiInput
        console.log("showWifiInput:" , wifiInfo.ssid,wifiInfo.flags)
        loader_wifiInput.item.wifi_ssid=wifiInfo.ssid
        loader_wifiInput.item.wifi_flags=wifiInfo.flags
        loader_wifiInput.item.index=index
        timer_wifi_scan.stop()
    }
    function dismissWifiInput(){
        listView.positionViewAtBeginning()
        loader_wifiInput.sourceComponent = undefined
        timer_wifi_scan.start()
    }

    Loader{
        //加载弹窗组件
        id:loader_wifiInput
        //        asynchronous: true
        anchors.fill: parent
        //        focus: true
        //        onLoaded: {
        //            loader_wifiInput.forceActiveFocus()
        //        }
    }

}
