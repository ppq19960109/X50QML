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
            text:qsTr("关于本机")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Text{
            id:category
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 100
            text:"品类：集成灶"
            color:"#fff"
            font.pixelSize: 30
        }

        Text{
            id:model
            anchors.top: category.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 100
            text:"型号：X50BCZ"
            color:"#fff"
            font.pixelSize: 30
        }
        Text{
            id:deviceId
            anchors.top: model.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 100
            text:"device ID：XXXXX"
            color:"#fff"
            font.pixelSize: 30
        }
        Button{
            width: 350
            height: 50
            anchors.top: deviceId.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 100
            background:Rectangle{
                color:"transparent"
            }
            Text{
                text:"绑定官方APP   >"
                color:"#fff"
                font.pixelSize: 30
//                anchors.centerIn: parent
            }

            onClicked: {

            }
        }
    }
}

