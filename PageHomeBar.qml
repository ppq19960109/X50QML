import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/SendFunc.js" as SendFunc

Item {
    property alias windImg:wind_icon.source
    implicitWidth: parent.width
    implicitHeight:80

    ToolBar {
        width: parent.width
        implicitHeight:80

        anchors.top: parent.top
        background:Image {
            asynchronous:true
            source: themesImagesPath+"homebar-background.png"
        }

        //wifi图标
        TabButton {
            id:wifi
            width: wifi_icon.width+40
            height:parent.height
            anchors.left:parent.left
            anchors.leftMargin: 20

            background: Item {
            }
            Image{
                id:wifi_icon
                asynchronous:true
                anchors.centerIn: parent
                source: wifiConnected ? "qrc:/x50/main/icon_wife_nor.png":"qrc:/x50/main/icon_wife_w.png"
            }
            onClicked: {
                load_page("pageWifi")
            }
        }

        TabButton {
            id:wind
            width: wind_icon.width+40
            height:parent.height
            anchors.centerIn: parent
            //        anchors.leftMargin: 140

            background: Item {
            }
            Image{
                id:wind_icon
                asynchronous:true
                anchors.centerIn: parent
            }
            onClicked: {

            }
        }

        TabButton {
            id:closeHeat
            visible: QmlDevState.state.RStoveTimingState==timingStateEnum.RUN
            width:time.width+closeHeatImg.width+20
            height:parent.height
            anchors.right:childLockBtn.left
            anchors.rightMargin: 20

            background: Item {
            }
            Image{
                id:closeHeatImg
                asynchronous:true
                anchors.right: time.left
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/x50/main/icon_time.png"
            }
            Text{
                id:time
                anchors.verticalCenter: parent.verticalCenter
                color:"#fff"
                text:"0"+Math.floor(QmlDevState.state.RStoveTimingLeft/60)+":"+Math.floor(QmlDevState.state.RStoveTimingLeft%60/10)+(QmlDevState.state.RStoveTimingLeft%60%10)//qsTr("01:12")
                font.pixelSize:35
                anchors.right: parent.right
            }
            onClicked: {
                showCloseHeat()
            }
        }
        Component{
            id:component_closeHeat
            PageDialogConfirm{
                hintTopText:"右灶定时已开启"
                hintBottomText:""
                cancelText:"取消定时"
                confirmText:"重新定时"
                hintWidth:600
                hintHeight:280
                closeBtnVisible:false
                onCancel: {

                    var Data={}
                    Data.RStoveTimingOpera = timingOperationEnum.STOP
                    SendFunc.setToServer(Data)
                    //                QmlDevState.setState("RStoveTimingState",timingStateEnum.STOP)
                    closeLoaderMain()
                }
                onConfirm: {
                    closeLoaderMain()
                    load_page("pageCloseHeat")
                }
            }
        }
        function showCloseHeat(device,state){
            loader_main.sourceComponent = component_closeHeat
        }
        Component{
            id:component_lock_screen
            PageLockScreen{
            }
        }

        //---------------------------------------------------------------

        //童锁按钮
        TabButton{
            id:childLockBtn
            width:120
            height:parent.height
            anchors.right:parent.right
            //        anchors.rightMargin: 0
            background:Item{
            }
            Image{
                id:tongsuoImg
                asynchronous:true
                anchors.centerIn: parent
                source: systemSettings.childLock ?"qrc:/x50/main/icon_ts_g.png" : "qrc:/x50/main/icon_ts_k.png"
            }

            onPressedChanged: {

                if (pressed) {
                    longPressTimer.running = true
                }
                else
                {
                    longPressTimer.running = false
                }
            }
        }
        Timer {
            id: longPressTimer
            interval: 300
            repeat: false
            running: false

            onTriggered: {

                if(systemSettings.childLock==false)
                {
                    console.log("启用童锁")
                    systemSettings.childLock=true
                    showLockScreen()
                }

            }
        }
    }
    function showLockScreen(){
        loader_lock_screen.sourceComponent = component_lock_screen
    }
    function closeLockScreen(){
        loader_lock_screen.sourceComponent = undefined
    }
}
