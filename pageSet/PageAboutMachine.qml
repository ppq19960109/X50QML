import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    id:root
    Timer{
        id:timer_qrcode
        repeat: false
        running: false
        interval: 20*60000
        triggeredOnStart: false
        onTriggered: {
            loaderQrcodeHide()
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        enabled:root.visible
        onStateChanged: { // 处理目标对象信号的槽函数
            if("WifiState"==key)
            {
                if(value==4 && timer_qrcode.running==false)
                {
                    timer_qrcode.restart()
                    loaderQrcodeShow("火粉APP")
                }
            }
        }
    }

    Component.onCompleted: {
        infoModel.setProperty(0,"value",QmlDevState.state.ProductCategory)
        infoModel.setProperty(1,"value",QmlDevState.state.ProductModel)
        infoModel.setProperty(2,"value",QmlDevState.state.DeviceName)
        listView.model=infoModel
    }

    ListModel {
        id: infoModel

        ListElement {
            key: "设备品类："
            value: ""
        }
        ListElement {
            key: "设备型号："
            value: ""
        }
        ListElement {
            key: "设备ID："
            value: ""
        }
    }

    Component {
        id: infoDelegate
        Item{
            width: parent.width
            height: 75
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text:key
                color:"#fff"
                font.pixelSize: 30
            }
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text:value
                color:"#fff"
                font.pixelSize: 30
            }
            PageDivider{
                anchors.bottom: parent.bottom
            }
        }
    }
    //内容
    Item{
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        ListView {
            id: listView
            width: parent.width
            height: listView.model.count*75
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: false
            delegate: infoDelegate
        }
        Button{
            width: parent.width
            height: 80
            anchors.top: listView.bottom
            PageDivider{
                anchors.bottom: parent.bottom
            }
            background:Item{}
            Text{
                text:"绑定官方APP"
                color:"#fff"
                font.pixelSize: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }
            Image {
                id:qrcodeImg
                asynchronous:true
                smooth:false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                source: themesPicturesPath+"icon_more.png"
            }

            onClicked: {

                if( timer_qrcode.running==false)
                {
                    if(QmlDevState.state.DeviceSecret==="")
                    {
                        loaderErrorConfirmShow("四元组不存在")
                        return
                    }
                    if(systemSettings.wifiEnable && wifiConnected==true)
                    {
                        loaderLoadingShow("二维码刷新中...",true)
                        wifiConnected=false
                        var Data={}
                        Data.BackOnline = null
                        SendFunc.setToServer(Data)
                    }
                    else
                    {
                        loaderWifiConfirmShow("当前设备离线，请检查网络")
                    }
                }
                else
                {
                    loaderQrcodeShow("火粉APP")
                }
            }
        }

    }

}

