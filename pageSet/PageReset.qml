import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        enabled:parent.visible
        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageReset:",key)
            if("Reset"==key)
            {
                loaderPopupShow("恢复出厂设置成功","",292,"确定")
            }
        }
    }

    //内容
    Item{
        anchors.fill: parent

        Image {
            asynchronous:true
            smooth:false
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            source: themesPicturesPath+"icon_warn.png"
        }
        Text{
            anchors.top: parent.top
            anchors.topMargin: 120
            anchors.horizontalCenter: parent.horizontalCenter
            text:"此操作会将设备初始化\n清除内部空间中的数据"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
            font.pixelSize: 30
            wrapMode:Text.WrapAnywhere
            lineHeight:1.2
        }

        Button{
            width: 176+10
            height: 50+10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                width:176
                height:50
                anchors.centerIn: parent
                color:themesTextColor2
                radius: height/2
            }
            Text{
                text:"重置设备"
                color:"#000"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {
                showResetConfirm()
            }
        }
    }
    Component{
        id:component_resetConfirm
        PageDialogConfirm{
            hintTopText:"操作确认"
            hintCenterText:"该操作将会清除您的个人数据\n包括烹饪记录、设备预设等\n请确认是否重置？"
            confirmText:"重置设备"
            hintHeight:412
            onCancel: {
                loaderMainHide()
            }
            onConfirm: {
                systemReset()
                loaderLoadingShow("恢复出厂设置中...")
            }
        }
    }
    function showResetConfirm(){
        loader_main.sourceComponent = component_resetConfirm
    }

}

