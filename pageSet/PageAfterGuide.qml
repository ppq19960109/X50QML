import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        background:Rectangle{
            color:"#000"
        }
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
            id:pageName
            width:100
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("售后指南")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Image{
            id:qrCodeImg
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:AfterSalesQrCode.png"
        }

        Text{
            anchors.top: qrCodeImg.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text:"扫描二维码，查看设备使用说明"
            color:"#fff"
            font.pixelSize: 30
        }
        Text{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text:"售后电话："+QmlDevState.state.AfterSalesPhone
            color:"#fff"
            font.pixelSize: 40
        }
    }
}

