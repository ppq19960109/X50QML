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
            text:qsTr("系统更新")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Image{
            id:logo
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/images/icon_mars_fans_club_logo.png"
        }
        Button{
            width: 250
            height: 50
            anchors.top: logo.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{

                color:"transparent"
            }
            Text{
                text:"当前版本V1.0  >"
                color:"#fff"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {

            }
        }
        Button{
            width: 150
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                radius: 30
                color:"blue"
            }
            Text{
                text:"检查更新"
                color:"#fff"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {

            }
        }
    }
}

