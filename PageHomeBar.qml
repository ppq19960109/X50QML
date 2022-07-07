import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/SendFunc.js" as SendFunc

Item {
    implicitWidth: parent.width
    implicitHeight:90

    Component{
        id:component_closeHeat
        PageDialogConfirm{
            hintTopText:"右灶定时已开启"
            hintBottomText:""
            cancelText:"取消定时"
            confirmText:"重新定时"
            hintWidth:600
            hintHeight:292

            onCancel: {
                if(flag>0)
                {
                    var Data={}
                    Data.RStoveTimingOpera = timingOperationEnum.CANCEL
                    Data.DataReportReason=0
                    SendFunc.setToServer(Data)
                    //                QmlDevState.setState("RStoveTimingState",timingStateEnum.STOP)
                }
                loaderMainHide()
            }
            onConfirm: {
                load_page("pageCloseHeat")
                loaderMainHide()
            }
        }
    }
    function showCloseHeat()
    {
        loader_main.sourceComponent = component_closeHeat
    }

    ToolBar {
        width: parent.width
        implicitHeight:80
        anchors.top: parent.top

        background:Image {
            asynchronous:true
            smooth:false
            source: themesImagesPath+"homebar-background.png"
        }

        //wifi图标
        ToolButton {
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

        //        ToolButton {
        //            id:wind
        //            width: wind_icon.width
        //            height:parent.height
        //            anchors.centerIn: parent

        //            background: Item {
        //            }
        //            Image{
        //                id:wind_icon
        //                visible: source!=""
        //                asynchronous:true
        //                smooth:false
        //                anchors.centerIn: parent
        //                source: {
        //                    var speed=QmlDevState.state.HoodSpeed
        //                    return speed===0?"":(themesImagesPath+"icon_wind_"+speed+".png")
        //                }
        //            }
        //            onClicked: {

        //            }
        //        }

        PageRotationImg {
            property int speed:QmlDevState.state.HoodSpeed
            anchors.centerIn: parent
            visible: speed!=0
            duration: {
                return speed==0?0:(4-speed)*1500
            }
            source: {
                return speed===0?"":(themesImagesPath+"icon_wind_"+speed+".png")
            }
        }

        ToolButton {
            id:closeHeat
            visible: QmlDevState.state.RStoveStatus
            width:closeHeatImg.width+20+time.width
            height:parent.height
            anchors.right:childLockBtn.left
            anchors.rightMargin: 20

            background: Item {}
            Image{
                id:closeHeatImg
                asynchronous:true
                smooth:false
                anchors.right: time.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: themesImagesPath+"icon_heat.png"
            }
            Text{
                id:time

                visible: QmlDevState.state.RStoveTimingState==timingStateEnum.RUN
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 5
                anchors.right: parent.right
                color:themesTextColor
                text:{
                    var time=QmlDevState.state.RStoveTimingLeft
                    return "0"+Math.floor(time/60)+":"+Math.floor(time%60/10)+(time%60%10)//qsTr("01:12")
                }
                font.pixelSize:34
                //                horizontalAlignment:Text.AlignHCenter
                //                verticalAlignment:Text.AlignVCenter
            }
            //            onClicked: {
            //                if(QmlDevState.state.RStoveTimingState==timingStateEnum.RUN)
            //                    showCloseHeat()
            //                else
            //                    load_page("pageCloseHeat")
            //            }
            MouseArea{
                anchors.fill: parent

                onClicked: {
                    console.warn("closeHeat onClicked",mouse.x,mouse.y)
                    if(time.visible==false)
                    {
                        if(mouse.x>closeHeatImg.width+40)
                            return
                    }
                    if(QmlDevState.state.RStoveTimingState==timingStateEnum.RUN)
                        showCloseHeat()
                    else
                        load_page("pageCloseHeat")
                }
            }
        }
        //---------------------------------------------------------------
        //童锁按钮
        ToolButton{
            id:childLockBtn
            width:130
            height:parent.height
            anchors.right:parent.right
            anchors.rightMargin: 20
            background:Item{
            }
            Image{
                visible: !systemSettings.childLock
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesImagesPath+ "icon_childlock_open.png"
            }
            onPressAndHold:{
                if(systemSettings.childLock==false)
                {
                    console.log("启用童锁")
                    systemSettings.childLock=true
                    loaderLockScreen.source="PageLockScreen.qml"
                }
            }

            //            onPressedChanged: {

            //                if (pressed) {
            //                    longPressTimer.running = true
            //                }
            //                else
            //                {
            //                    longPressTimer.running = false
            //                }
            //            }
        }
        //        Timer {
        //            id: longPressTimer
        //            interval: 350
        //            repeat: false
        //            running: false

        //            onTriggered: {
        //                if(systemSettings.childLock==false)
        //                {
        //                    console.log("启用童锁")
        //                    systemSettings.childLock=true
        //                    loaderLockScreen.source="PageLockScreen.qml"
        //                }

        //            }
        //        }
    }
}
