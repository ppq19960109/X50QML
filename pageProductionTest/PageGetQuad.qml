import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtTest 1.1

import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "PageGetQuad"
    property int step: 0

    Component.onCompleted: {
        connectTestWiFi()
    }
    Component.onDestruction: {
        sysPower=-1
        systemPower(QmlDevState.state.SysPower)
    }
    function connectTestWiFi()
    {
        SendFunc.connectWiFi(productionTestWIFISSID,productionTestWIFIPWD,1)
//        SendFunc.connectWiFi("IoT-Test","12345678",1)
    }

    function getQuad()
    {
        var Data={}
        Data.QuadGet = null
        SendFunc.setToServer(Data)
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page PageGetQuad:",key)

            if(step==0 && "WifiState"==key)
            {
                if(value==4)
                {
                    step=1
                    wifiConnect.color="green"
                    wifiConnectText.text="成功"

                    quadText.visible=true
                    getQuad()
                }
                else
                {
                    step=0xff
                    wifiConnect.color="red"
                    wifiConnectText.text="失败"
                    retry.visible=true
                }
            }
            else if(step==1 && "DeviceSecret"==key)
            {
                if(value!="")
                {
                    step=2
                    quad.color="green"
                    quadText.text="四元组烧录成功"
                    SendFunc.getAllToServer()
                }
            }
            else if(step==1 && "QuadInfo"==key)
            {
                quad.color="red"
                quadText.text=value
                retry.visible=true
            }
        }
    }
    Item{
        id:topBar
        width:parent.width
        height:80
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:"green"
            font.pixelSize: 40
            font.bold : true
            text: qsTr("四元组烧录")
        }
    }
    Item{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom

        GridLayout{
            width:parent.width-40
            height: parent.height-100
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            rows: 2
            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            Text{
                Layout.preferredWidth: 200
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                verticalAlignment:Text.AlignVCenter
                text:"WIFI连接:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:wifiConnect

                Layout.preferredWidth: 500
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter
                radius: 8
                color:"transparent"

                Text{
                    id:wifiConnectText
                    text:"正在连接WIFI..."
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 200
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                verticalAlignment:Text.AlignVCenter
                text:"四元组烧录:"
                color:"#FFF"
                font.pixelSize: 30
            }
            Rectangle{
                id:quad

                Layout.preferredWidth: 500
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter
                radius: 8
                color:"transparent"

                Text{
                    visible: false
                    id:quadText
                    text:"正在烧录四元组..."
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
            }
        }
        Button{
            id:retry
            visible: false
            width:100+40
            height:50+40
            anchors.right: quit.left
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:100
                height:50
                anchors.centerIn: parent
                radius: 8
                color:"green"
            }
            Text{
                text:"重试"
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                retry.visible=false
                wifiConnectText.text="正在连接WIFI..."
                quadText.text=""
                step=0
                connectTestWiFi()
            }
        }
        Button{
            id:quit
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
