import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/SendFunc.js" as SendFunc

Item {
    implicitWidth: parent.width
    implicitHeight:80

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
                Data.RStoveTimingOpera = timingOperationEnum.CANCEL
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
    function showCloseHeat()
    {
        loader_main.sourceComponent = component_closeHeat
    }

    ToolBar {
        //        width: parent.width
        //        implicitHeight:80
        //        anchors.top: parent.top
        anchors.fill: parent
        background:Image {
            asynchronous:true
            smooth:false
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
                smooth:false
                anchors.centerIn: parent
                source: themesImagesPath+(wifiConnected==true ? "icon_wifi_connected.png":"icon_wifi_disconnect.png")
            }
            onClicked: {
                load_page("pageWifi")
            }
        }

        TabButton {
            id:wind
            width: wind_icon.width
            height:parent.height
            anchors.centerIn: parent
            //        anchors.leftMargin: 140

            background: Item {
            }
            Image{
                id:wind_icon
                visible: QmlDevState.state.HoodSpeed!=0
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: QmlDevState.state.HoodSpeed!=0?(themesImagesPath+"icon_wind_"+QmlDevState.state.HoodSpeed+".png"):""
            }
            onClicked: {

            }
        }

        TabButton {
            id:closeHeat
            visible: QmlDevState.state.RStoveStatus
            width:closeHeatImg.width+10+time.width
            height:parent.height
            anchors.right:childLockBtn.left
            anchors.rightMargin: 20

            background: Item {}
            Image{
                id:closeHeatImg
                asynchronous:true
                smooth:false
                anchors.right: time.left
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: themesImagesPath+"icon_heat.png"
            }
            Text{
                id:time
                visible: QmlDevState.state.RStoveTimingState==timingStateEnum.RUN
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                color:themesTextColor
                text:"0"+Math.floor(QmlDevState.state.RStoveTimingLeft/60)+":"+Math.floor(QmlDevState.state.RStoveTimingLeft%60/10)+(QmlDevState.state.RStoveTimingLeft%60%10)//qsTr("01:12")
                font.pixelSize:34
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }
            onClicked: {
                if(QmlDevState.state.RStoveTimingState==timingStateEnum.RUN)
                    showCloseHeat()
                else
                    load_page("pageCloseHeat")
            }
            Component.onCompleted: {
                console.log("TabButton:",time.width)
            }
        }

        Component{
            id:component_lock_screen
            PageLockScreen{
                Component.onCompleted: {
                    SendFunc.setBuzControl(buzControlEnum.SHORT)
                }
                Component.onDestruction: {
                    SendFunc.setBuzControl(buzControlEnum.SHORTTWO)
                }
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
                visible: !systemSettings.childLock
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesImagesPath+ "icon_childlock_open.png"
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
