import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property bool versionChecked: false

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
//            console.log("PageSystemUpdate onStateChanged:",key)

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
            key=null
            value=null
        }
    }
    Component.onCompleted: {

        //        loaderUpdateShow()
    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("系统更新")
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
            id:logo
            cache:false
            smooth:false
            asynchronous:true
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/x50/set/logo.png"
        }
        Button{
            id:version
            width: 440
            height: 50
            anchors.top: logo.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            background:Item{}
            Text{
                id:curVer
                text:"当前版本 "+QmlDevState.state.ComSWVersion
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            Image {
                cache:false
                asynchronous:true
                smooth:false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "qrc:/x50/set/gengduo.png"
            }
            onClicked: {
                load_page("pageReleaseNotes")
            }
        }
        Item{
            id:checkStatus
            width: 180
            height: 50
            anchors.top: version.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
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
            width: 176+15
            height: 64+15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                width:176
                height:64
                anchors.centerIn: parent
                color:versionChecked==true?"transparent":themesTextColor2
                border.color: themesTextColor2
                radius: 32
            }
            Text{
                text:"检查更新"
                color:versionChecked==true?themesTextColor2:"#000"
                font.pixelSize: 30
                anchors.centerIn: parent
            }
            onClicked: {
                if(wifiConnected)
                {
                    checkStatus.visible=true
                    versionChecked=true
                    SendFunc.otaRquest(0)
                }
                else
                {
                    loaderImagePopupShow("未连网，请连接网络后再试","/x50/icon/icon_pop_error.png")
                }
                //                loaderUpdateConfirmShow()
            }
        }
    }

}

