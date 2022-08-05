import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
//import QtQuick.VirtualKeyboard.Settings 2.2

import "qrc:/WifiFunc.js" as WifiFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    id:root
    property int scan_count: 0
    property bool wifiInputConnecting:false
    property int qrcode_display: 0

    function wifi_scan_timer_reset()
    {
        SendFunc.getCurWifi()
        SendFunc.scanRWifi()
        scan_count=0
        timer_wifi_scan.interval=2500
        timer_wifi_scan.restart()
    }
    function getWifiInfo()
    {
        if(wifiConnected==false)
            SendFunc.getWifiState()
        else
            SendFunc.getCurWifi()
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: window
        enabled:root.visible
        onWifiConnectingChanged:{
            if(wifiConnecting==true)
                timer_wifi_connecting.restart()
            else
            {
                if(timer_wifi_connecting.running)
                    timer_wifi_connecting.stop()
                else
                {
                    if(systemSettings.wifiEnable && wifiConnected==false && wifiConnectInfo.ssid!=="")
                    {
                        wifiConnectInfo.ssid=""
                        loaderWarnPopupShow("网络连接失败，请重试")
                    }
                }
                wifi_scan_timer_reset()
                wifiInputConnecting=false
            }
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        enabled:root.visible
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page wifi onStateChanged:",key)

            if("WifiState"==key)
            {
                console.log("page wifi WifiState:",value,wifiConnected,wifiConnectInfo.ssid)
                if(value > 1)
                {
                    if(value==2|| value==5)
                    {
                        if(systemSettings.wifiEnable && wifiConnected==false && wifiConnectInfo.ssid!=="")
                        {
                            wifiConnectInfo.ssid=""
                            loaderWarnPopupShow("网络连接失败，请重试")
                        }
                    }
                    else if(value==3)
                    {
                        if(systemSettings.wifiEnable && wifiConnected==false && wifiConnectInfo.ssid!=="")
                        {
                            wifiConnectInfo.ssid=""
                            loaderWarnPopupShow("密码错误，连接失败")
                        }
                    }
                    else if(value==4)
                    {
                        if(scan_count>=3)
                            wifi_scan_timer_reset()
                    }
                }
            }
            else if("ssid"==key)
            {
                if(wifiConnected==true && wifiConnectInfo.ssid!=="")
                {
                    var real_ssid
                    if(pattern.test(wifiConnectInfo.ssid))
                    {
                        real_ssid=decodeURI(value.replace(/\\x/g,'%'))
                        console.log("real_ssid",real_ssid,wifiConnectInfo.ssid)
                    }
                    else
                    {
                        real_ssid=value
                    }
                    if(real_ssid===wifiConnectInfo.ssid)
                    {
                        qrcode_display=20
                        wifiConnectInfo.ssid=""
                        loaderQrcodeShow("连接成功！")
                    }
                }
            }
            else if("WifiEnable"==key)
            {
                if(value==1)
                    wifi_scan_timer_reset()
            }
        }
    }

    Component.onDestruction: {
        if(wifiConnecting==false)
        {
            QmlDevState.executeShell("(wpa_cli enable_network all) &")
        }
        if(loader_main.sourceComponent===component_wifiInput)
            loader_main.sourceComponent = null
    }
    Component.onCompleted: {
        //        VirtualKeyboardSettings.styleName = "retro"
        //        VirtualKeyboardSettings.fullScreenMode=true
        //        console.info("VirtualKeyboardSettings",VirtualKeyboardSettings.availableLocales)
        if(systemSettings.wifiEnable && wifiConnecting==false)
        {
            if(wifiConnected==true)
                QmlDevState.executeShell("(wpa_cli list_networks | tail -n +3 | grep -v 'CURRENT' | awk '{system(\"wpa_cli disable_network \" $1)}') &")
            getWifiInfo()
            SendFunc.scanRWifi()
        }
    }

    Timer{
        id:timer_wifi_scan
        repeat: true
        running: (systemSettings.wifiEnable && sleepState==false && root.visible)
        interval: 2500
        triggeredOnStart: false
        onTriggered: {
            ++scan_count
            if(scan_count <= 3)
            {
                if(scan_count==1)
                {
                    if(wifiConnecting==false)
                    {
                        getWifiInfo()
                        SendFunc.scanWifi()
                    }
                }
                else if(scan_count==3)
                {
                    timer_wifi_scan.interval=7000
                }
                if(wifiConnecting==false)
                {
                    SendFunc.scanRWifi()
                }
            }
            else
            {
                if(wifiConnecting==false)
                {
                    getWifiInfo()

                    if(scan_count%2==0)
                        SendFunc.scanWifi()
                    else
                        SendFunc.scanRWifi()
                }
                if(qrcode_display>0)
                {
                    --qrcode_display
                    if(qrcode_display==0)
                    {
                        loaderQrcodeHide()
                    }
                }
            }
        }
    }
    Component {
        id: headerView
        Item{
            width: parent.width
            height: 120

            PageDivider{
                id:divider
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 45
            }

            Text {
                text: qsTr("WiFi")
                color: "#fff"
                font.pixelSize: 30
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: wifi_switch.verticalCenter
            }
            PageSwitch {
                id: wifi_switch
                checked:systemSettings.wifiEnable
                width:implicitWidth+20
                height:implicitHeight+10
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.bottom: divider.top

                onCheckedChanged: {
                    console.log("wifi_switch:", checked,wifi_switch.width)
                    if(systemSettings.wifiEnable!=checked)
                        SendFunc.enableWifi(checked)
                }
            }
            Text {
                visible: systemSettings.wifiEnable
                text: qsTr("可用WiFi列表")
                color: Qt.rgba(255,255,255,0.45)
                font.pixelSize: 24
                anchors.top: divider.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 30
            }
        }
    }

    // 定义delegate
    Component {
        id: wifiDelegate

        Item {
            width: parent.width
            height: 76

            Item {
                id:indicator
                width: 40
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16

                PageRotationImg {
                    visible: connected==2
                    anchors.centerIn: parent
                    source: themesPicturesPath+"icon_loading_small.png"
                }
                Image{
                    asynchronous:true
                    smooth:false
                    visible: connected==1
                    anchors.centerIn: parent
                    source: themesPicturesPath+"wifi/"+"icon_selected.png"
                }
            }
            Text {
                id: wifi_name
                width:500
                text: ssid

                font.pixelSize: 30
                color:connected>0? themesTextColor:"#FFF"
                elide: Text.ElideRight
                anchors.left: indicator.right
                anchors.leftMargin: 20
                anchors.verticalCenter: indicator.verticalCenter
                //                horizontalAlignment:Text.AlignHCenter
                //                verticalAlignment:Text.AlignVCenter
            }
            PageDivider{
                anchors.bottom: parent.bottom
            }
            Image {
                id: wifi_level
                asynchronous:true
                smooth:false
                anchors.right: parent.right
                anchors.rightMargin:  53
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                source: {
                    if(level === 0){
                        return themesPicturesPath+"wifi/"+"wifi1.png"
                    }else if(level === 1){
                        return themesPicturesPath+"wifi/"+"wifi2.png"
                    }else if(level === 2){
                        return themesPicturesPath+"wifi/"+"wifi3.png"
                    }else if(level >= 3){
                        return themesPicturesPath+"wifi/"+"wifi4.png"
                    }
                }
                Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    anchors.centerIn: parent
                    visible: flags > 0
                    source: themesPicturesPath+"wifi/"+"wifi_lock.png"
                }

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("WiFi name:" + wifi_name.text)
                    if(connected==0)
                    {
                        if(flags==0)
                        {
                            //                            console.log("open connect:" , ssid,flags)
                            SendFunc.connectWiFi(ssid,"",flags)
                            connected=2
                            if(index>0)
                            {
                                wifiModel.setProperty(0,"connected",0)
                                wifiModel.move(index,0,1)
                            }
                            listView.positionViewAtBeginning()
                        }
                        else
                        {
                            var wifiInfo=WifiFunc.getWifiInfo(ssid)
                            if(wifiInfo==null)
                            {
                                loaderWifiInputShow(index,listView.model.get(index))
                            }
                            else
                            {
                                SendFunc.connectWiFi(wifiInfo.ssid,wifiInfo.psk,wifiInfo.encryp)
                                connected=2
                                if(index>0)
                                {
                                    wifiModel.setProperty(0,"connected",0)
                                    wifiModel.move(index,0,1)
                                }
                                listView.positionViewAtBeginning()
                            }
                            wifiInfo=null
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
            height: 80
            visible: systemSettings.wifiEnable && listView.count<=1

            anchors.left: parent.left
            anchors.leftMargin: 30

            PageRotationImg {
                anchors.centerIn: parent
                source: themesPicturesPath+"icon_loading_small.png"
            }
        }
    }
    //内容
    Item{
        width:parent.width
        height: parent.height

        ListView {
            id: listView
            width:parent.width - 80
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: true
            delegate: wifiDelegate
            model: wifiModel
            cacheBuffer:10
            header: headerView
            clip: true
            //            highlightRangeMode: ListView.ApplyRange
            snapMode: ListView.SnapToItem
            boundsBehavior:Flickable.StopAtBounds
            highlightMoveDuration:40
            highlightMoveVelocity:-1
            footer: footerView

            ScrollBar.vertical: ScrollBar {
                parent: listView.parent
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.left: listView.right
                anchors.leftMargin: 10

                background:Rectangle{
                    implicitWidth: 4
                    color:"#313131"
                    radius: implicitWidth / 2
                }
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: implicitWidth / 2
                    color: themesTextColor
                }
            }
        }
    }
    Component{
        id:component_wifiInput

        Rectangle{
            anchors.fill: parent
            property string wifi_ssid
            property int wifi_flags
            property int index
            property bool permit_connect:false
            color:themesWindowBackgroundColor

            Item{
                id:bar
                width:parent.width
                height:65
                anchors.top: parent.top
                Button {
                    width:80
                    height:parent.height
                    anchors.left:parent.left
                    anchors.leftMargin: 40
                    background: null
                    Text{
                        anchors.centerIn: parent
                        color:themesTextColor2
                        font.pixelSize: 30
                        text: qsTr("取消")
                    }
                    onClicked: {
                        loaderWifiInputHide()
                    }
                }
                Text{
                    width: parent.width/2
                    anchors.centerIn: parent
                    color:"#fff"
                    font.pixelSize: 30
                    elide: Text.ElideRight
                    horizontalAlignment:Text.AlignHCenter
                    text: wifi_ssid
                }
                PageRotationImg {
                    id: connectBusy
                    visible: wifiInputConnecting==true?true:false
                    anchors.right:connectBtn.left
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    source: themesPicturesPath+"icon_loading_small.png"
                }
                Button {
                    id:connectBtn
                    width:120
                    height:parent.height
                    anchors.right:parent.right
                    anchors.rightMargin: 40

                    Text{
                        id:connectText
                        color:permit_connect?themesTextColor:"white"
                        font.pixelSize: 30
                        anchors.centerIn:parent
                        text: qsTr(wifiInputConnecting==true?"正在连接":"连接")
                    }
                    background: null
                    onClicked: {
                        console.log("connectBtn:" , wifi_ssid,textField.text,wifi_flags)
                        if(permit_connect)
                        {
                            SendFunc.connectWiFi(wifi_ssid,textField.text,wifi_flags)
                            wifiModel.setProperty(index,"connected",2)
                            if(index>0)
                            {
                                wifiModel.setProperty(0,"connected",0)
                                wifiModel.move(index,0,1)
                            }
                            wifiInputConnecting=true
                        }
                    }
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }

            TextField {
                id:textField
                height: 35*5
                anchors.left: parent.left
                anchors.right: vkb.left
                anchors.top: bar.bottom

                padding: 20
                leftPadding: 40
                font.pixelSize: 35
                color: "#ECF4FC"
                echoMode: TextInput.Normal//TextInput.Password:TextInput.Normal
                placeholderText: qsTr("请输入密码")
                //                    overwriteMode: false
                inputMethodHints:Qt.ImhNoAutoUppercase //Qt.ImhNoAutoUppercase Qt.ImhMultiLine
                //                    onAccepted: {
                //                        console.log("onAccepted")
                //                            textField.focus = true    /* 结束输入操作行为 */
                //                    }
                maximumLength:36
                wrapMode:TextInput.WrapAnywhere
                verticalAlignment:Text.AlignTop
                //                text: "123456789012345678901234567890123456"
                background: null
                //                onPressed: {
                //                    vkb.visible = true //当选择输入框的时候才显示键盘
                //                }
                onTextEdited:{
                    if(length>=8 && length<=36)
                    {
                        permit_connect=true
                    }
                    else
                    {
                        permit_connect=false
                    }
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }

            InputPanel {
                id: vkb
                visible: true
                width: 790
                anchors.top: bar.bottom
                anchors.bottom: parent.bottom
                anchors.right:parent.right
                //这种集成方式下点击隐藏键盘的按钮是没有效果的，
                //只会改变active，因此我们自己处理一下
                //                onActiveChanged: {
                //                    if(!active) { visible = false }
                //                }
            }
            Component.onCompleted: {
                textField.forceActiveFocus()
            }
            Component.onDestruction: {
                wifiInputConnecting=false
            }
        }
    }

    function loaderWifiInputShow(index,wifiInfo){
        loaderStackView.sourceComponent = component_wifiInput
        loaderStackView.item.wifi_ssid=wifiInfo.ssid
        loaderStackView.item.wifi_flags=wifiInfo.flags
        loaderStackView.item.index=index
        timer_wifi_scan.stop()
    }
    function loaderWifiInputHide(){
        if(loaderStackView.sourceComponent===component_wifiInput)
            loaderStackView.sourceComponent = undefined
        timer_wifi_scan.start()
        listView.positionViewAtBeginning()
    }
}
