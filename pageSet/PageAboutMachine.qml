import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Timer{
        id:timer_qrcode
        repeat: false
        running: false
        interval: 20*60000
        triggeredOnStart: false
        onTriggered: {
            closeLoaderQrcode()
        }
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageAboutMachine:",key)

            if("WifiState"==key)
            {
                if(value==4 && timer_qrcode.running==false)
                {
                    timer_qrcode.restart()
                    showQrcodeBind("此二维码可以")
                }
            }
        }
    }

    Component.onCompleted: {
        infoModel.get(0).value=QmlDevState.state.ProductCategory
        infoModel.get(1).value=QmlDevState.state.ProductModel
        infoModel.get(2).value=QmlDevState.state.DeviceName
        listView.model=infoModel
        console.log("infoModel",listView.model.count)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("关于本机")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }
    ListModel {
        id: infoModel

        ListElement {
            key: "品类："
            value: ""
        }
        ListElement {
            key: "型号："
            value: ""
        }
        ListElement {
            key: "device ID："
            value: ""
        }
    }

    Component {
        id: infoDelegate
        Item{
            width: parent.width
            height: 80
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text:key
                color:"#fff"
                font.pixelSize: 35
            }
            Text{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                text:value
                color:"#fff"
                font.pixelSize: 35
            }
            PageDivider{
                anchors.bottom: parent.bottom
            }
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        Item{
            width:parent.width-80
            height: parent.height-80
            anchors.centerIn: parent
            ListView {
                id: listView
                width: parent.width
                height: listView.model.count*80
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                interactive: false
                delegate: infoDelegate

                focus: true
            }
            Button{
                width: parent.width
                height: 90
                anchors.top: listView.bottom

                PageDivider{
                    anchors.bottom: parent.bottom
                }
                background:Item{}
                Text{
                    text:"绑定官方APP"
                    color:"#fff"
                    font.pixelSize: 35
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }
                //                Text{
                //                    text:" 已绑定火粉俱乐部"
                //                    visible: QmlDevState.state.APPBind==1
                //                    color:"#fff"
                //                    font.pixelSize: 30
                //                    anchors.verticalCenter: parent.verticalCenter
                //                    anchors.right: qrcodeImg.left
                //                    anchors.rightMargin: 20
                //                    horizontalAlignment:Text.AlignHCenter
                //                    verticalAlignment:Text.AlignVCenter
                //                }
                Image {
                    id:qrcodeImg
                    asynchronous:true
                    smooth:false
//                    cache:false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "qrc:/x50/set/gengduo.png"
                }

                onClicked: {

                    if( timer_qrcode.running==false)
                    {
                        if(systemSettings.wifiEnable && wifiConnected==true)
                        {
                            wifiConnected=false
                            var Data={}
                            Data.BackOnline = null
                            SendFunc.setToServer(Data)
                        }
                        else
                        {
                            showLoaderFault("","未连网，请连接网络后再试",true,"","/x50/icon/icon_pop_error.png",false)
                        }
                    }
                    else
                    {
                        showQrcodeBind("此二维码可以")
                    }
                }
            }
        }
    }

}

