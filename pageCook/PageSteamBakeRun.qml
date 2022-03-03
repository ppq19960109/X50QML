import QtQuick 2.0
import QtQuick.Controls 2.2

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property string name: "pageSteamBakeRun"
    Component.onCompleted: {
        console.log("PageSteamBakeRun onCompleted")
        SendFunc.permitSteamStartStatus(0)
    }

    StackView.onActivated:{
        leftProgressBar.updatePaint()
        rightProgressBar.updatePaint()
    }
    Component{
        id:pageLeftCook
        PageLeftCook{}
    }
    Component{
        id:pageRightCook
        PageRightCook{}
    }
    function showNewCook(device){
        if(device===leftDevice)
        {
            loader_main.sourceComponent = pageLeftCook
        }
        else
        {
            loader_main.sourceComponent = pageRightCook
        }
    }
    Image {
        source: "/x50/main/背景.png"
    }
    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        color:"transparent"

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:300
            height: 300
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 75

            workColor:workState===workStateEnum.WORKSTATE_STOP?"#FFF":"#19A582"
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("左腔烹饪"):QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.leftWorkModeFun(QmlDevState.state.LStOvMode)
            canvasDiameter:300
            percent:30
            workState:QmlDevState.state.LStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.LStOvOrderTimerLeft+"分钟":QmlDevState.state.LStOvSetTimerLeft+"分钟"
            workTemp:qsTr(QmlDevState.state.LStOvRealTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_STOP||leftProgressBar.workState === workStateEnum.WORKSTATE_PAUSE)
                    {
                        showNewCook(leftProgressBar.device)
                    }
                    else
                    {
                        mouse.accepted = false
                    }
                }
                onPressed: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
                onReleased: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:95
            height: width
            anchors.left: leftProgressBar.left
            anchors.leftMargin: 5
            anchors.bottom: leftProgressBar.bottom
            anchors.bottomMargin: -10
            background:Rectangle{
                color:"transparent"
            }
            Image {
                anchors.centerIn:parent
                source: "qrc:/x50/steam/icon_close.png"
            }
            onClicked:{
                if(QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("左腔","预约")
                else
                    showCancelRun("左腔","运行")
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:95
            height: width
            anchors.right: leftProgressBar.right
            anchors.rightMargin: 5
            anchors.bottom: leftProgressBar.bottom
            anchors.bottomMargin: -10
            background:Rectangle{
                color:"transparent"
            }
            Image {
                anchors.centerIn:parent
                source: QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_PAUSE?"qrc:/x50/steam/icon_start.png":"qrc:/x50/steam/icon_close(1).png"
            }
            onClicked:{
                if(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_PAUSE)
                {
//                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(leftDevice,workOperationEnum.START)
                }
                else
                {
//                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_PAUSE)
                    SendFunc.setCookOperation(leftDevice,workOperationEnum.PAUSE)
                }
            }
        }
        PageIndicator {
            id:leftIndicator
            visible: true
            count: QmlDevState.state.cnt
            currentIndex: QmlDevState.state.current-1
            anchors.top: leftProgressBar.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: leftProgressBar.horizontalCenter
            interactive: true
            delegate: Rectangle {
                color:"transparent"
                implicitWidth: indicator.implicitWidth+5
                implicitHeight: 4
                Rectangle {
                    id:indicator
                    implicitWidth: index===leftIndicator.currentIndex?25:10
                    implicitHeight: 4
                    anchors.centerIn: parent
                    radius: implicitHeight/2
                    color:index===leftIndicator.currentIndex?leftProgressBar.workColor:"#FFF"
                }
            }
        }
    }
    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right
        color:"transparent"

        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:300
            height: 300
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 75

            workColor:workState===workStateEnum.WORKSTATE_STOP?"#FFF":"#19A582"
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("右腔烹饪"):rightWorkMode
            canvasDiameter:300
            percent:20
            workState:QmlDevState.state.RStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.RStOvOrderTimerLeft+"分钟":QmlDevState.state.RStOvSetTimerLeft+"分钟"
            workTemp:qsTr(QmlDevState.state.RStOvRealTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_STOP||rightProgressBar.workState === workStateEnum.WORKSTATE_PAUSE)
                    {
                        showNewCook(rightProgressBar.device)
                    }
                    else
                    {
                         mouse.accepted = false
                    }
                }
                onPressed: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
                onReleased: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:95
            height: width
            anchors.left: rightProgressBar.left
            anchors.leftMargin: 5
            anchors.bottom: rightProgressBar.bottom
            anchors.bottomMargin: -10
            background:Rectangle{
                color:"transparent"
            }
            Image {
                anchors.centerIn:parent
                source: "qrc:/x50/steam/icon_close.png"
            }
            onClicked:{
                if(QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("右腔","预约")
                else
                    showCancelRun("右腔","运行")
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:95
            height: width
            anchors.right: rightProgressBar.right
            anchors.rightMargin: 5
            anchors.bottom: rightProgressBar.bottom
            anchors.bottomMargin: -10
            background:Rectangle{
                color:"transparent"
            }
            Image {
                anchors.centerIn:parent
                source: QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE?"qrc:/x50/steam/icon_start.png":"qrc:/x50/steam/icon_close(1).png"
            }
            onClicked:{
                if(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE)
                {
//                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.START)
                }
                else
                {
//                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_PAUSE)
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.PAUSE)
                }
            }
        }

    }
    //        Rectangle{
    //            id:statusBar
    //            width:parent.width
    //            height: 80
    //            anchors.bottom: parent.bottom
    //            Slider {
    //                id: slider
    //                anchors.centerIn: parent
    //                stepSize: 2
    //                to: 100
    //                value: 30
    //                onValueChanged: {
    //                    console.log("slider:",value)
    //                    if(value==100)
    //                    {
    //                        QmlDevState.setState("LStOvState",4)
    //                        QmlDevState.setState("RStOvState",4)
    //                    }
    //                    leftProgressBar.updatePaint()
    //                    rightProgressBar.updatePaint()
    //                }
    //            }
    //        }
    PageHomeBar {
        id:statusBar
        width:parent.width
        anchors.bottom: parent.bottom
        height:80
        windImg:QmlDevState.state.HoodSpeed===0?"":"qrc:/x50/main/icon_wind_"+QmlDevState.state.HoodSpeed+".png"
    }
    Component{
        id:component_cancelRun
        PageDialogConfirm{
            hintTopText:""
            hintBottomText:""
            cancelText:"取消"
            confirmText:"继续工作"
            hintHeight:280
            onCancel: {
                closeLoaderMain()
                if(hintTopText.indexOf("左腔")!=-1)
                {
                    SendFunc.setCookOperation(leftDevice,workOperationEnum.CANCEL)
//                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_STOP)
                }
                else
                {
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.CANCEL)
//                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_STOP)
                }
            }
            onConfirm: {
                closeLoaderMain()
            }
        }
    }
    function showCancelRun(device,state){
        loader_main.sourceComponent = component_cancelRun
        loader_main.item.hintTopText= "是否取消"+device+state+"？"
        loader_main.item.cancelText= "取消"+state
    }

}
