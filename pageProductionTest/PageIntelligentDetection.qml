import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
//import QtTest 1.1

import "qrc:/SendFunc.js" as SendFunc
Item {
    property int step: 0

    Timer{
        id:timer_wifi
        repeat: false
        running: false
        interval: 3000
        triggeredOnStart: false
        onTriggered: {
            if(step==0)
            {
                versionText.visible=true
                version.color="red"
                versionText.text="通讯异常"
                SendFunc.scanWifi()
            }
            else if(step==1)
            {
                SendFunc.scanRWifi()
            }
        }
    }

    Component.onCompleted: {
        SendFunc.scanWifi()
        SendFunc.getAllToServer()

        timer_wifi.restart()
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
                wifiSignalText.visible=true
                if(element.rssi < -75)
                {
                    wifiSignal.color="red"
                }
                else
                {
                    wifiSignal.color="green"
                }
                wifiSignalText.text=element.rssi+"db"
                break
            }
        }
        if(i == root.length)
        {
            if(wifiSignalText.visible==false)
            {
                SendFunc.scanWifi()
                wifiSignalText.visible=true
                timer_wifi.restart()
                return
            }
            wifiSignalText.visible=true
            wifiSignal.color="red"
            wifiSignalText.text="获取信号值失败"
            return
        }

        if(root[i].rssi > -75)
        {
            step=2
            SendFunc.connectWiFi(productionTestWIFISSID,productionTestWIFIPWD,1)
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page PageIntelligentDetection:",key,value,step)
            if("ElcSWVersion"==key && step==0)
            {
                step=1
                versionText.visible=true
                versionText.text="电源板软件版本号:"+QmlDevState.state.ElcSWVersion+"\n屏幕模组软件版本号:"+QmlDevState.state.ComSWVersion
                version.color="green"
                timer_wifi.restart()
            }
            else if("WifiScanR"==key && step==1)
            {
                parseWifiList(value)
            }
            else if("WifiState"==key && step==2)
            {
                wifiConnectText.visible=true
                if(value==2 || value==3|| value==5)
                {
                    wifiConnect.color="red"
                    wifiConnectText.text="失败"
                }
                else if(value==4)
                {
                    step=3
                    wifiConnect.color="green"
                    wifiConnectText.text="成功"

                    quadText.visible=true
                    if(QmlDevState.state.ProductKey=="" || QmlDevState.state.DeviceName==""|| QmlDevState.state.ProductSecret==""|| QmlDevState.state.DeviceSecret=="")
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
            }
            //            else if("ssid"==key && step==3)
            //            {

            //                if(wifiConnected==true && value==wifiConnectInfo.ssid)
            //                {
            //                    step=3

            //                }
            //                else
            //                {
            //                    wifiConnect.color="red"
            //                    wifiConnectText.text="失败"
            //                }
            //            }
            else if("Reset"==key && step==3)
            {
                step=0xff
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
    Item{
        id:topBar
        width:parent.width
        height:100
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:themesTextColor
            font.pixelSize: 40
            font.bold : true
            text: qsTr("智能模块检测")
        }
        Button{
            width:100+50
            height:parent.height
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:100
                height:50
                anchors.centerIn: parent
                radius: 8
                color:themesTextColor2
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
    Item{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        GridLayout{
            width:parent.width -100
            height: parent.height - 20
            anchors.horizontalCenter: parent.horizontalCenter
            rows: 5
            columns: 2
            rowSpacing: 5
            columnSpacing: 5

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:50
                Layout.alignment: Qt.AlignVCenter
                text:"通讯及版本检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:version
                Layout.preferredWidth: 400
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignVCenter
                radius: 8
                color:"transparent"

                Text{
                    id:versionText
                    visible: false
                    text:""
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:50
                Layout.alignment: Qt.AlignVCenter

                text:"wifi信号检测:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiSignal

                Layout.preferredWidth: 400
                Layout.preferredHeight:50
                Layout.alignment: Qt.AlignVCenter
                radius: 8
                color:"transparent"

                Text{
                    id:wifiSignalText
                    visible: false
                    text:""
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 220
                Layout.preferredHeight:50
                Layout.alignment: Qt.AlignVCenter

                text:"wifi连接:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiConnect

                Layout.preferredWidth: 400
                Layout.preferredHeight:50
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
                Layout.preferredHeight:50
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
                Layout.preferredHeight:50
                Layout.alignment: Qt.AlignVCenter

                text:"恢复出厂设置:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:reset
                Layout.preferredWidth: 400
                Layout.preferredHeight:50
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
    }
}
