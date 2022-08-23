import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property bool versionCheckState: false

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSystemUpdate onStateChanged:",key)

            if("OTAState"==key)
            {
                if(value==1)
                {
                    versionCheckState=false
                }
                else if(value==2)
                {
                    checkStatus.visible=false
                    versionCheckState=false
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

    //内容
    Item{
        anchors.fill: parent

        Image{
            id:logo
            cache:false
            smooth:false
            asynchronous:true
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            source: themesPicturesPath+"icon_logo.png"
        }
        Button{
            id:version
            width: 440
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 140
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
                source: themesPicturesPath+"icon_more.png"
            }
            onClicked: {

            }
        }
        Item{
            id:checkStatus
            width: 180
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 195
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            Text{
                id:checkText
                text:versionCheckState ?"正在检查...":"已经是最新版本"
                color:"#fff"
                font.pixelSize: 35
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Button{
            width: 176+10
            height: 50+10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: versionCheckState==false
            background:Rectangle{
                width:176
                height:50
                anchors.centerIn: parent
                color:versionCheckState==true?"transparent":themesTextColor2
                border.color: themesTextColor2
                radius: height/2
            }
            Text{
                text:"检查更新"
                color:versionCheckState==true?themesTextColor2:"#000"
                font.pixelSize: 30
                anchors.centerIn: parent
            }
            onClicked: {
                if(wifiConnected)
                {
                    checkStatus.visible=true
                    versionCheckState=true
                    SendFunc.otaRquest(0)
                }
                else
                {
                    loaderWifiConfirmShow("当前设备离线，请检查网络")
                }
            }
        }
    }

}

