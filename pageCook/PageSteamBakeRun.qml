import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Rectangle {
    color: themesWindowBackgroundColor
    property string name: "pageSteamBakeRun"

    Timer{
        id:timer_run
        repeat: true
        running: leftProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT||rightProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT
        interval: 100
        triggeredOnStart: false
        onTriggered: {
//            console.log("timer_run onTriggered");
            if(leftProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT)
            {
                leftProgressBar.roate+=10
                if(leftProgressBar.roate>360)
                {
                    leftProgressBar.roate=10
                }
                leftProgressBar.updatePaint()
            }
            if(rightProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT)
            {
                rightProgressBar.roate+=10
                if(rightProgressBar.roate>360)
                {
                    rightProgressBar.roate=10
                }
                rightProgressBar.updatePaint()
            }
        }
    }

    Component.onCompleted: {
        console.log("PageSteamBakeRun onCompleted")
        SendFunc.permitSteamStartStatus(0)
        leftProgressBar.updatePaint()
        rightProgressBar.updatePaint()
    }

    StackView.onActivated:{
        SendFunc.permitSteamStartStatus(0)
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

    Item{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:310
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 75

            workColor:"#E68855"
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("左腔烹饪"):QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.leftWorkModeFun(QmlDevState.state.LStOvMode)
            canvasDiameter:width
            percent:workState === workStateEnum.WORKSTATE_RESERVE?(100-100*QmlDevState.state.LStOvOrderTimerLeft/QmlDevState.state.LStOvOrderTimer):(100-100*QmlDevState.state.LStOvSetTimerLeft/QmlDevState.state.LStOvSetTimer)
            workState:QmlDevState.state.LStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.LStOvOrderTimerLeft:QmlDevState.state.LStOvSetTimerLeft
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
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
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
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                anchors.centerIn:parent
                source: themesImagesPath+(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_PAUSE?"icon-cookrun.png":"icon-cookpause.png")
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
            visible: QmlDevState.state.MultiMode > 0
            count: QmlDevState.state.cnt
            currentIndex: QmlDevState.state.current-1
            anchors.top: leftProgressBar.bottom
            anchors.topMargin: 18
            anchors.horizontalCenter: leftProgressBar.horizontalCenter
            interactive: true
            delegate: Item {
                implicitWidth: indicator.implicitWidth
                implicitHeight: 6
                Rectangle {
                    id:indicator
                    implicitWidth: index===leftIndicator.currentIndex?25:6
                    implicitHeight: 6
                    anchors.centerIn: parent
                    radius: implicitHeight/2
                    color:index===leftIndicator.currentIndex?leftProgressBar.workColor:"#434343"
                }
            }
        }
    }
    Item{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right

        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:310
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 75

            workColor:"#DE932F"
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("右腔烹饪"):rightWorkMode
            canvasDiameter:width
            percent:workState === workStateEnum.WORKSTATE_RESERVE?(100-100*QmlDevState.state.RStOvOrderTimerLeft/QmlDevState.state.RStOvOrderTimer):(100-100*QmlDevState.state.RStOvSetTimerLeft/QmlDevState.state.RStOvSetTimer)
            workState:QmlDevState.state.RStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.RStOvOrderTimerLeft:QmlDevState.state.RStOvSetTimerLeft
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
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
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
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                anchors.centerIn:parent
                source: themesImagesPath+(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE?"icon-cookrun.png":"icon-cookpause.png")
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
    //    Rectangle{
    //        id:statusBar
    //        width:parent.width
    //        height: 80
    //        anchors.bottom: parent.bottom
    //        Slider {
    //            id: slider
    //            anchors.centerIn: parent
    //            stepSize: 2
    //            to: 100
    //            value: 30
    //            onValueChanged: {
    //                console.log("slider:",value)

    //                QmlDevState.setState("LStOvSetTimerLeft",100-value)
    //                QmlDevState.setState("LStOvSetTimer",100)
    //                QmlDevState.setState("LStOvOrderTimerLeft",100-value)
    //                QmlDevState.setState("LStOvOrderTimer",100)
    //                QmlDevState.setState("RStOvSetTimerLeft",100-value)
    //                QmlDevState.setState("RStOvSetTimer",100)
    //                QmlDevState.setState("RStOvOrderTimerLeft",100-value)
    //                QmlDevState.setState("RStOvOrderTimer",100)
    //                                        if(value==100)
    //                                        {
    //                                            QmlDevState.setState("LStOvState",4)
    //                                            QmlDevState.setState("RStOvState",4)
    //                                        }

    //            }
    //        }
    //    }
    PageHomeBar {
        id:statusBar
        anchors.bottom: parent.bottom
        windImg:QmlDevState.state.HoodSpeed===0?"":"qrc:/x50/main/icon_wind_"+QmlDevState.state.HoodSpeed+".png"
    }
    Component{
        id:component_cancelRun
        PageDialogConfirm{
            hintTopText:""
            hintBottomText:""
            cancelText:"取消"
            confirmText:"继续工作"
            hintWidth:600
            hintHeight:280
            closeBtnVisible:false
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
