import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtTest 1.1
Rectangle {

    color: "#000"
    Timer{
        id:timer_wifi
        repeat: false
        running: false
        interval: 2000
        triggeredOnStart: false
        onTriggered: {
            scanRWifi()
            wifiSignalText.visible=true
        }
    }

    Component.onCompleted: {
        scanWifi()
        if(QmlDevState.state.ComSWVersion==null)
        {
            version.color="red"
            versionText.text="通讯异常"
        }
        else
        {
            version.color="blue"
            timer_wifi.restart()
        }
    }

    function parseWifiList(sanR)
    {
        var root=JSON.parse(sanR)
        //        console.log("setWifiList:" ,sanR,root.length)
        var i
        for( i = 0; i < root.length; ++i) {
            if(root[i].ssid==="moduletest")
            {
                if(root[i].rssi < -75)
                {
                    wifiSignal.color="red"
                }
                else
                {
                    wifiSignal.color="green"
                }

                wifiSignalText.text=root[i].rssi+"db"
                break
            }
        }
        if(i == root.length)
        {
            wifiSignal.color="red"
            wifiSignalText.text="获取信号值失败"
            return
        }
        if(root[i].rssi > -75)
        {
            connectWiFi("IoT-Test","12345678",1)
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page PageIntelligentDetection:",key)

            if("WifiScanR"==key)
            {
                parseWifiList(value)
            }
            else if(("WifiState"==key))
            {
                if(value>1)
                {
                    wifiConnectText.visible=true
                    wifiConnect.color="green"
                    if(value==4)
                    {
                        wifiConnect.color="green"
                        wifiConnectText.text="成功"

                        quadText.visible=true
                        if(QmlDevState.state.ProductKey==null || QmlDevState.state.DeviceName==null|| QmlDevState.state.ProductSecret==null|| QmlDevState.state.DeviceSecret==null)
                        {
                            quad.color="red"
                            quadText.text="四元组缺失"
                        }
                        else
                        {
                            quad.color="green"
                            quadText.text="四元组正常"
                            systemReset()
                        }
                    }
                    else if(value==5)
                    {

                    }
                    else
                    {
                        wifiConnect.color="red"
                        wifiConnectText.text="失败"
                    }
                }
            }
            else if("Reset"==key)
            {
                resetText.visible=true
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
        }
    }
    Rectangle{
        id:topBar
        width:parent.width
        height:80
        anchors.top: parent.top
        color:"transparent"
        Text {
            anchors.centerIn: parent
            color:"green"
            font.pixelSize: 40
            font.bold : true
            text: qsTr("智能模块检测")
        }
    }
    Rectangle{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        color:"transparent"

        GridLayout{
            width:parent.width -100
            height: parent.height -40
            anchors.left: parent.left
            anchors.leftMargin: 20
            rows: 5
            columns: 2
            rowSpacing: 5
            columnSpacing: 5

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                text:"通讯及版本检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:version
                Layout.preferredWidth: 450
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignVCenter

                radius: 8
                color:"transparent"

                Text{
                    id:versionText
                    text:"电控板软件版本号:"+QmlDevState.state.ElcSWVersion+"\n通讯板软件版本号:"+QmlDevState.state.ComSWVersion+"\n屏幕模组软件版本号:"+uiVersion
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                text:"wifi信号检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiSignal

                Layout.preferredWidth: 400
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                radius: 8
                color:"transparent"

                Text{
                    id:wifiSignalText
                    visible: false
                    text:"db"
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                text:"wifi连接:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiConnect

                Layout.preferredWidth: 400
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:wifiConnectText
                    text:"成功"
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                text:"四元组检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:quad

                Layout.preferredWidth: 400
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:quadText
                    text:"四元组正常"
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                text:"恢复出厂设置:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:reset

                Layout.preferredWidth: 300
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:resetText
                    text:"成功"
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }
        }
        Button{
            width:100+40
            height:50+40
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:100
                height:50
                anchors.centerIn: parent
                radius: 8
                color:"green"
            }
            Text{
                text:"退出"
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                backPrePage()
            }
        }
    }
}
