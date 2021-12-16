import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
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
            text:qsTr("恢复出厂设置")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"#000"

        Text{
            anchors.centerIn: parent
            text:"此操作会将设备初始化，清除内部空间中的数据"
            color:"#fff"
            font.pixelSize: 30
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
                text:"重置设备"
                color:"#fff"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {
                console.log("page systemReset")
                QmlDevState.systemReset()
            }
        }
    }
}

