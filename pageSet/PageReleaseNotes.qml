import QtQuick 2.2
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
            text:qsTr("版本说明")
        }
    }
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom

        color:"#000"
        Text{
            id:version
            text:"V1.2"
            color:"#fff"
            font.pixelSize: 35
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.top: parent.top
            anchors.topMargin: 20
        }

        Text{
            text:"更新日志"
            color:"#fff"
            font.pixelSize: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.top: version.bottom
            anchors.topMargin: 40
        }
    }
}
