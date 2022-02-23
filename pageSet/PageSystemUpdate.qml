import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {
    enabled: loader_main.status == Loader.Null
    property bool versionChecked: false

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSystemUpdate onStateChanged:",key)

            if("OTAState"==key)
            {
                if(value==1)
                {
                    versionChecked=false
                }
                else if(value==2)
                {
                    checkStatus.visible=false
                    versionChecked=false
                }
                else if(value==3)
                {

                }
                else if(value==8)
                {

                }
            }
            else if(("OTAProgress"==key))
            {
            }
            else if(("OTANewVersion"==key))
            {

            }
        }
    }
    Component.onCompleted: {

        //        showUpdate()
    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("系统更新")
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
            id:logo
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/x50/set/logo.png"
        }
        Button{
            id:version
            width: 300
            height: 50
            anchors.top: logo.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"transparent"
            }
            Text{
                id:curVer
                text:"当前版本 "+QmlDevState.state.ComSWVersion
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            Image {
                anchors.verticalCenter: curVer.verticalCenter
                anchors.left: curVer.right
                anchors.leftMargin: 20
                source: "qrc:/x50/set/gengduo.png"
            }
            onClicked: {
                load_page("pageReleaseNotes")
            }
        }
        Rectangle{
            id:checkStatus
            width: 180
            height: 50
            anchors.top: version.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            color:"transparent"
            Text{
                id:checkText
                text:versionChecked ?"正在检查...":"已经是最新版本"
                color:"#fff"
                font.pixelSize: 35
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            //            PageBusyIndicator{
            //                id:busy
            //                visible: versionChecked
            //                width: 40
            //                height: 40
            //                anchors.right: parent.right
            //                anchors.verticalCenter: parent.verticalCenter
            //                running: visible
            //            }
        }

        Button{
            width: 175
            height: 65
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            Text{
                text:"检查更新"
                color:"#00E6B6"
                font.pixelSize: 30
                anchors.centerIn: parent
            }
            onClicked: {
                if(wifiConnected)
                {
                    checkStatus.visible=true
                    versionChecked=true
                    otaRquest(0)
                }
                else
                {
                    showLoaderFaultImg("/x50/icon/icon_pop_th.png","未连网，请连接网络后再试")
                }

                //                showUpdateConfirm()
            }
        }
    }

}

