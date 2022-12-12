import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property int step: 0
    property int rssi: 0
    property bool quadState: false
    Timer{
        id:timer_wifi
        repeat: false
        running: false
        interval: 4000
        triggeredOnStart: false
        onTriggered: {
            if(step==0)
            {
                versionText.visible=true
                version.color="red"
                versionText.text="电源串口通讯异常"
                step=0xff
            }
            else if(step>0 && step<=3)
            {
                SendFunc.scanRWifi()
            }
            else if(step==6||step==7)
            {
                factoryRequest(rssi,quadState)
            }
        }
    }

    Component.onCompleted: {
        SendFunc.scanWifi()
        SendFunc.getAllToServer(1)

        timer_wifi.restart()
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: window
        onWifiConnectingChanged:{
            console.log("onWifiConnectingChanged:",wifiConnecting,wifiConnected,timer_wifi_connecting.running)
            if(wifiConnecting==true)
                timer_wifi_connecting.restart()
            else
            {
                if(timer_wifi_connecting.running)
                {
                    timer_wifi_connecting.stop()
                }
                else
                {
                    wifiConnect.color="red"
                    wifiConnectText.text="失败"
                    step=0xff
                }
            }
        }
    }
    function setTimeout(callback,timeout){
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {}", window)
        timer.interval = timeout
        timer.repeat = false
        timer.triggered.connect(callback)
        timer.restart()
    }
    function factoryRequest(signalStrength,quadruple)
    {
        var doc = new XMLHttpRequest();

        doc.onreadystatechange = function() {
            console.log("onreadystatechange:",doc.readyState);
            switch(doc.readyState){
            case XMLHttpRequest.UNSENT://UNSENT
                //do something
                break;
            case XMLHttpRequest.OPENED://OPENED
                //do something
                break;
            case XMLHttpRequest.HEADERS_RECEIVED://HEADERS_RECEIVED
                console.log("HEADERS_RECEIVED:",doc.status,doc.statusText);
                break;
            case XMLHttpRequest.DOLOADINGNE://LOADING
                //do something
                break;
            case XMLHttpRequest.DONE://DONE
                console.log("DONE:",doc.status,doc.statusText);
                console.log("getAllResponseHeaders:",doc.getAllResponseHeaders ());
                console.log("responseText:",doc.responseText)
                do{
                    if(doc.responseText=="")
                    {
                        sequence.color="red"
                        sequenceText.text="产测上报异常"
                        break
                    }
                    var dataJson=JSON.parse(doc.responseText.toString())
                    if(dataJson.code!==0)
                    {
                        sequence.color="red"
                        sequenceText.text="产测上报异常"
                        break
                    }
                    sequence.color="green"
                    sequenceText.text=dataJson.data
                }while(0)
                step=7
                resetText.visible=true
                systemSetReset()
                break;
            }
        }
        doc.ontimeout = function() {
            console.log("ontimeout");
        }
        doc.onerror = function() {
            console.log("onerror",doc.status);
        }
        doc.onabort = function() {
            console.log("onabort");
        }
        doc.open("POST", "http://192.168.101.199:63036/iot/push/testing/result",true)
        doc.timeout=5000
        doc.setRequestHeader("Content-Type", "application/json")

        var pk=QmlDevState.state.ProductKey
        doc.setRequestHeader("pk", pk)
        var mac=QmlDevState.getNetworkMac().replace(/:/g,"").toLowerCase()
        doc.setRequestHeader("mac", mac)
        var sign="1643338882000."+Qt.md5("1643338882000"+pk+mac+"mars")
        doc.setRequestHeader("sign", sign)

        console.log("Header:",pk,mac,sign)
        var obj={}
        obj.signalStrength=signalStrength
        obj.quadruple=quadruple
        obj.versionSmartScreen=QmlDevState.state.ComSWVersion
        obj.versionPowerPanel=QmlDevState.state.PwrSWVersion.replace(/\./g,"")
        obj.deviceName=QmlDevState.state.DeviceName
        obj.deviceSecret=QmlDevState.state.DeviceSecret
        obj.mqVerify=Qt.md5(obj.deviceName+obj.deviceSecret+pk+QmlDevState.state.ProductSecret)
        var body=JSON.stringify(obj)
        console.log("body:",body)
        setTimeout(function(){
            console.log("timer abort...")
            if(doc!=null)
                doc.abort();//请求中止
        },6000)
        doc.send(body)
    }
    function parseWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        //        console.log("setWifiList:" ,sanR,root.length)
        var i,element
        for( i = 0; i < root.length; ++i) {
            element=root[i]
            if(element.ssid===productionTestWIFISSID)
            {
                if(rssi==0 || rssi < element.rssi)
                    rssi=element.rssi
            }
        }
        if(rssi == 0)
        {
            if(step < 3)
            {
                ++step
                SendFunc.scanWifi()
                timer_wifi.restart()
                return
            }
            wifiSignal.color="red"
            wifiSignalText.text="WIFI "+productionTestWIFISSID+"不存在"
            step=0xff
            return
        }
        wifiSignalText.visible=true
        if(rssi < -75)
        {
            wifiSignal.color="red"
        }
        else
        {
            wifiSignal.color="green"
        }
        wifiSignalText.text=element.rssi+"db"

        step=4
        wifiConnectText.visible=true
        //            SendFunc.connectWiFi("IoT-Test","12345678",1)
        SendFunc.connectWiFi(productionTestWIFISSID,productionTestWIFIPWD,1)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            //            console.log("page PageIntelligentDetection:",key,value,step)
            if("PwrSWVersion"==key && step==0)
            {
                step=1
                versionText.text="电源板软件版本号:"+QmlDevState.state.PwrSWVersion+" 屏幕模组软件版本号:"+QmlDevState.state.ComSWVersion
                version.color="green"
                SendFunc.scanWifi()
                timer_wifi.restart()
                wifiSignalText.visible=true
            }
            else if("WifiScanR"==key && step>0 && step<=3)
            {
                parseWifiList(value)
            }
            else if("WifiState"==key && step==4)
            {

                if(value==2 || value==3|| value==5)
                {
                    wifiConnect.color="red"
                    wifiConnectText.text="失败"
                    step=0xff
                }
                else if(value==4)
                {
                    step=5
                }
            }
            else if("Wifissid"==key && step==5)
            {
                step=6
                wifiConnect.color="green"
                wifiConnectText.text="成功"

                quadText.visible=true
                if(QmlDevState.state.ProductKey=="" || QmlDevState.state.DeviceName==""|| QmlDevState.state.ProductSecret==""|| QmlDevState.state.DeviceSecret=="")
                {
                    step=0xff
                    quad.color="red"
                    quadText.text="四元组缺失"
                    quadState=false
                }
                else
                {
                    quad.color="green"
                    quadText.text="四元组正常"
                    quadState=true
                }
                sequenceText.visible=true
                timer_wifi.restart()
            }
            else if("Reset"==key && step==7)
            {
                step=0xff

                if(value==0)
                {
                    reset.color="red"
                    resetText.text="失败"
                }
                else
                {
                    reset.color="green"
                    resetText.text="成功"
                }
            }
            key=null
            value=null
        }
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("智能模块检测")
    }
    Item{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        GridLayout{
            width:parent.width - 100
            height: parent.height
            anchors.centerIn: parent
            rows: 6
            columns: 2
            rowSpacing: 2
            columnSpacing: 10

            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50
                text:"通讯及版本检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:version
                Layout.preferredWidth: 600
                Layout.preferredHeight:50
                radius: 8
                color:"transparent"

                Text{
                    id:versionText
                    visible: true
                    text:"检测中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50

                text:"wifi信号检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiSignal

                Layout.preferredWidth: 600
                Layout.preferredHeight:50
                radius: 8
                color:"transparent"

                Text{
                    id:wifiSignalText
                    visible: false
                    text:"检测中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50

                text:"wifi连接:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiConnect
                Layout.preferredWidth: 600
                Layout.preferredHeight:50

                radius: 8
                color:"transparent"
                Text{
                    visible: false
                    id:wifiConnectText
                    text:"连接中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50

                text:"四元组检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:quad
                Layout.preferredWidth: 600
                Layout.preferredHeight:50
                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:quadText
                    text:"检测中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }
            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50

                text:"产测序号:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:sequence
                Layout.preferredWidth: 600
                Layout.preferredHeight:50
                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:sequenceText
                    text:"检测中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }
            Text{
                Layout.preferredWidth: 300
                Layout.preferredHeight:50

                text:"恢复出厂设置:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:reset
                Layout.preferredWidth: 600
                Layout.preferredHeight:50
                radius: 8
                color:"transparent"
                Text{
                    visible: false
                    id:resetText
                    text:"恢复出厂设置中..."
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }
        }
    }
}
