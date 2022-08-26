import QtQuick 2.12
import QtQuick.Controls 2.5
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
            width: 240
            height: 240
//            sourceSize.width: 218
//            sourceSize.height: 218
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            asynchronous:true
            smooth:false
            source: themesPicturesPath+"AfterSalesQrCode.png"
        }

        Text{
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 290
            anchors.horizontalCenter: parent.horizontalCenter

            text:"扫描二维码查看设备使用说明<br/>售后电话：<font color='"+themesTextColor+"'>400-888-8490</font><br/>"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
            font.pixelSize: 35
        }
    }
}

