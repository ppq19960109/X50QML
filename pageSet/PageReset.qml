import QtQuick 2.0
import QtQuick.Controls 2.2
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Component.onCompleted: {


    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageReset:",key)

            if("Reset"==key)
            {

                if(value==0)
                {

                }
                else
                {

                }
                backTopPage()
            }
        }
    }

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("恢复出厂设置")
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

        Text{
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 110
            anchors.horizontalCenter: parent.horizontalCenter
            text:"此操作会将设备初始化，\n清除内部空间中的数据 。"
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
            color:"#fff"
            font.pixelSize: 40
            wrapMode:Text.WrapAnywhere
            lineHeight:1.5
        }

        Button{
            width: 175
            height: 65
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 70
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            Text{
                text:"重置设备"
                color:"#00E6B6"
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
            hintBottomText:"该操作将会清除您的个人数据\n包括烹饪记录、设备预设等\n请确认是否重置？"
            confirmText:"重置设备"
            hintHeight:410
            onCancel: {
                closeLoaderMain()
            }
            onConfirm: {
                closeLoaderMain()
                console.log("page systemReset")
                systemReset()
            }
        }
    }
    function showResetConfirm(){
        loader_main.sourceComponent = component_resetConfirm
    }

}

