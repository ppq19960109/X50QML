import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSystemUpdate onStateChanged:",key)

            if("WifiScanR"==key)
            {

            }
            else if(("WifiState"==key))
            {
            }
        }
    }
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
            id:version
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
                load_page("pageReleaseNotes")
            }
        }
        Rectangle{
            width: 180
            height: 50
            anchors.top: version.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color:"#000"
            Text{
                text:"正在检查"
                color:"#fff"
                font.pixelSize: 30
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageBusyIndicator{
                id:busy
                visible: true
                width: 40
                height: 40
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                running: visible
            }
        }

        Button{
            id:version_btn
            width: 150
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
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
                showUpdateConfirm()
            }
        }
    }
    Component{
        id:component_updateConfirm
        Rectangle {
            anchors.fill: parent
            color: "#000"
            radius: 10
            Button {
                width:50
                height:50
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.right:parent.right
                anchors.rightMargin: 5

                Text{
                    width:40
                    color:"white"
                    font.pixelSize: 40

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"X"
                }
                background: Rectangle {
                    color:"transparent"
                }
                onClicked: {
                    closeUpdateConfirm()
                }
            }

            Text{
                width:200
                color:"white"
                font.pixelSize: 40
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"系统更新"
            }
            Text{
                width:600
                color:"white"
                font.pixelSize: 35
                anchors.centerIn:parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"检测到最新版本V1.2，是否升级系统"
            }

            Button {
                id:cancel_btn
                width: 100
                height: 40
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 200
                Text{
                    width:parent.width
                    color:"white"
                    font.pixelSize: 30

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"取消"
                }
                background: Rectangle {
                    color:"blue"
                    radius: 5
                }
                onClicked: {
                    closeUpdateConfirm()
                }
            }

            Button {
                id:confirm_btn
                width: 100
                height: 40
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 200
                Text{
                    width:parent.width
                    color:"white"
                    font.pixelSize: 30

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"升级"
                }
                background: Rectangle {
                    color:"blue"
                    radius: 5
                }
                onClicked: {

                }
            }
        }
    }
    function showUpdateConfirm(){
        loader_main.sourceComponent = component_updateConfirm
    }
    function closeUpdateConfirm(){
        loader_main.sourceComponent = null
    }
}

