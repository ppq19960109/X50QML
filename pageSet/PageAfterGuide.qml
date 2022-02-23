import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
Item {

    Component.onCompleted: {

    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("售后指南")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        Image{
            id:qrCodeImg
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:AfterSalesQrCode.png"
        }

        Text{
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            text:"扫描二维码查看设备使用说明\n售后电话：400-888-8490 "
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
            font.pixelSize: 35
        }
    }
}

