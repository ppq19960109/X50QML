import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtTest 1.1

import "qrc:/SendFunc.js" as SendFunc
Rectangle {
    property string name: "PageGetQuad"
    property int get_quad_count: 0
    color: "transparent"

    Timer{
        id:timer_quad
        repeat: false
        running: false
        interval: 2000
        triggeredOnStart: false
        onTriggered: {
            getQuad()
        }
    }

    Component.onCompleted: {

        SendFunc.connectWiFi(productionTestWIFISSID,productionTestWIFIPWD,1)
    }

    Component.onDestruction: {
        sysPower=-1
        systemPower(QmlDevState.state.SysPower)
    }
    function getQuad()
    {
        var Data={}
        Data.ProductKey = null
        Data.ProductSecret = null
        Data.DeviceName = null
        Data.DeviceSecret = null
        SendFunc.getToServer(Data)
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("page PageGetQuad:",key)

            if( wifiConnect.color=="#00000000" && "WifiState"==key)
            {
                if(value==4)
                {
                    wifiConnect.color="green"
                    wifiConnectText.text="成功"

                    quadText.visible=true
                    timer_quad.restart()
                }
                else
                {
                    wifiConnect.color="red"
                    wifiConnectText.text="失败"
                }
            }
            else if(quadText.visible==true && quad.color=="#00000000" && "DeviceSecret"==key)
            {
                if(value!="")
                {
                    timer_quad.stop()
                    quad.color="green"
                    quadText.text="四元组烧录成功"
                    SendFunc.getAllToServer()
                }
                else
                {
                    ++get_quad_count
                    if(get_quad_count>4)
                    {
                        quad.color="red"
                        quadText.text="四元组烧录失败"
                    }
                    timer_quad.restart()
                }
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
            width:parent.width -100
            height: parent.height -100
            anchors.centerIn: parent
            rows: 2
            columns: 2
            rowSpacing: 20
            columnSpacing: 20

            Text{
                Layout.preferredWidth: 240
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                verticalAlignment:Text.AlignVCenter
                text:"WIFI连接状态:"
                color:"#FFF"
                font.pixelSize: 40
            }
            Rectangle{
                id:wifiConnect

                Layout.preferredWidth: 400
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter
                radius: 8
                color:"transparent"

                Text{
                    id:wifiConnectText
                    text:"正在连接WIFI..."
                    color:"#FFF"
                    font.pixelSize: 50
                    anchors.centerIn: parent
                }
            }

            Text{
                Layout.preferredWidth: 240
                Layout.preferredHeight:60
                Layout.alignment: Qt.AlignVCenter

                verticalAlignment:Text.AlignVCenter
                text:"四元组烧录:"
                color:"#FFF"
                font.pixelSize: 40
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
                    text:"正在烧录四元组..."
                    color:"#FFF"
                    font.pixelSize: 50
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
