import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    property int versionCheckState: 0
    property var otaSlientUpgrade: QmlDevState.state.OTASlientUpgrade
    Component {
        id: pageReleaseNotes
        PageReleaseNotes {}
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSystemUpdate onStateChanged:",key)

            if("OTAState"==key)
            {
                if(value==1)
                {
                    if(versionCheckState>0)
                        --versionCheckState
                }
                else if(value==2)
                {
                    checkStatus.visible=false
                    versionCheckState=0
                }
            }
            else if("OTAPowerState"==key)
            {
                if(value==1)
                {
                    if(versionCheckState>0)
                        --versionCheckState
                }
                else if(value==2)
                {
                    checkStatus.visible=false
                    versionCheckState=0
                }
            }
        }
    }

    //内容
    Item{
        anchors.fill: parent

        Image{
            id:logo
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
                text:"当前版本 "+get_current_version()
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -10
            }
            Image {
                asynchronous:true
                smooth:false
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: curVer.right
                anchors.leftMargin: 30
                source: themesPicturesPath+"icon_more.png"
            }
            onClicked: {
                loaderManual.sourceComponent = pageReleaseNotes
            }
        }
        Item{
            id:checkStatus
            width: 500
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 195
            anchors.horizontalCenter: parent.horizontalCenter
            visible: otaSlientUpgrade>0?true:false
            Text{
                id:checkText
                text:{
                    if(otaSlientUpgrade>0)
                        return "已准备好最新版本，重启安装更新"
                    return versionCheckState>0 ?"正在检查...":"已经是最新版本"
                }
                color:versionCheckState>0?"#fff":themesTextColor
                font.pixelSize: 35
                anchors.centerIn: parent
            }
        }

        Button{
            width: 176+10
            height: 50+10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: versionCheckState==0
            background:Rectangle{
                width:176
                height:50
                anchors.centerIn: parent
                color:versionCheckState>0?"transparent":themesTextColor2
                border.color: themesTextColor2
                radius: height/2
            }
            Text{
                id:updateBtnText
                text:otaSlientUpgrade>0?"重启":"检查更新"
                color:versionCheckState>0?themesTextColor2:"#000"
                font.pixelSize: 30
                anchors.centerIn: parent
            }
            onClicked: {
                if(otaSlientUpgrade>0)
                {
                    QmlDevState.setState("OTASlientUpgrade",0)
                    updateBtnText.text="重启中"
                    systemRestart()
                    return
                }

                if(wifiConnected)
                {
                    checkStatus.visible=true
                    versionCheckState=2
                    SendFunc.otaRquest(0)
                    SendFunc.otaPowerRquest(0)
                }
                else
                {
                    loaderCheckWifiShow("当前设备离线，请检查网络")
                }
            }
        }
    }

}

