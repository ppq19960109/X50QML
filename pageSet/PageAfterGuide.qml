import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("售后指南")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Image{
            id:qrCodeImg
            width: 200
            height: 200
            asynchronous:true
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            source: "file:AfterSalesQrCode.png"
        }

        Text{
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 280
            anchors.horizontalCenter: parent.horizontalCenter

            text:"扫描二维码查看设备使用说明<br/>售后电话：<font color='"+themesTextColor+"'>400-888-8490</font><br/>"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
            font.pixelSize: 35
        }
    }
}

