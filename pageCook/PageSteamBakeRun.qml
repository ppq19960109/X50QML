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
        running: leftProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT||rightProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT||iceProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT
        interval: 200
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
            if(iceProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT)
            {
                iceProgressBar.roate+=10
                if(iceProgressBar.roate>360)
                {
                    iceProgressBar.roate=10
                }
                iceProgressBar.updatePaint()
            }
        }
    }

    Component.onCompleted: {
        console.log("PageSteamBakeRun onCompleted")
        leftProgressBar.updatePaint()
        rightProgressBar.updatePaint()
        iceProgressBar.updatePaint()
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

    function cookConfirm(){
        if(leftProgressBar.workState===workStateEnum.WORKSTATE_FINISH)
        {
            SendFunc.setCookOperation(leftDevice,workOperationEnum.CONFIRM)
        }
        if(rightProgressBar.workState===workStateEnum.WORKSTATE_FINISH)
        {
            SendFunc.setCookOperation(rightDevice,workOperationEnum.CONFIRM)
        }
        if(iceProgressBar.workState===workStateEnum.WORKSTATE_FINISH)
        {
            SendFunc.setCookOperation(iceDevice,workOperationEnum.CANCEL)
        }
    }

    Item{
        id:leftItem
        width:parent.width/3
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:265
            height: width
            anchors.centerIn: parent

            workColor:"#E68855"
            workState:QmlDevState.state.LStOvState
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("左腔烹饪"):QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.leftWorkModeName(QmlDevState.state.LStOvMode)
            canvasDiameter:width
            percent:workState === workStateEnum.WORKSTATE_RESERVE?(100-100*QmlDevState.state.LStOvOrderTimerLeft/QmlDevState.state.LStOvOrderTimer):(100-100*QmlDevState.state.LStOvSetTimerLeft/QmlDevState.state.LStOvSetTimer)

            orderTimeLeft:QmlDevState.state.LStOvOrderTimerLeft
            workTime:
            {
                if(workState === workStateEnum.WORKSTATE_PREHEAT)
                {
                    return QmlDevState.state.LStOvRealTemp
                }
                else if(workState === workStateEnum.WORKSTATE_RESERVE || (workState === workStateEnum.WORKSTATE_PAUSE && orderTimeLeft!=0))
                {
                    var time=orderTimeLeft
                    return (time<600?"0":"")+ Math.floor(time/60)+":"+(time%60<10?"0":"")+time%60//
                }
                else
                {
                    return QmlDevState.state.LStOvSetTimerLeft
                }
            }
            workTemp:qsTr(QmlDevState.state.LStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_STOP)
                    {
                        showNewCook(leftProgressBar.device)
                    }
                    else if(leftProgressBar.workState === workStateEnum.WORKSTATE_PAUSE && QmlDevState.state.MultiMode==0)
                    {
                        if(QmlDevState.state.LStOvOrderTimerLeft==0)
                        {
                            load_page("pageSteamBakeBase",JSON.stringify({"device":leftDevice,"reserve":0}))
                        }
                        else
                        {
                            var para =CookFunc.getDefHistory()
                            para.cookPos=leftDevice
                            load_page("pageSteamBakeReserve",JSON.stringify(para))
                        }
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
            onConfirm:cookConfirm()
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP && leftProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.left: leftProgressBar.left
            anchors.leftMargin: 10
            anchors.bottom: leftProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
            }
            onClicked:{
                if(QmlDevState.state.LStOvState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("左腔","预约")
                else
                    showCancelRun("左腔","工作")
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP && leftProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.right: leftProgressBar.right
            anchors.rightMargin: 10
            anchors.bottom: leftProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_PAUSE?"icon-cookpause.png":"icon-cookrun.png")
            }
            onClicked:{
                if(QmlDevState.state.LStOvState===workStateEnum.WORKSTATE_PAUSE)
                {
                    //                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(leftDevice,workOperationEnum.START)
                    if(QmlDevState.state.ErrorCodeShow==0)
                    {
                        if(QmlDevState.state.LStOvDoorState==1)
                        {
                            showLoaderPopup("","左腔门开启，工作暂停",275)
                        }
                    }
                    else
                    {
                        showFaultPopup(QmlDevState.state.ErrorCodeShow,leftDevice)
                    }
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
        id:rightItem
        width:parent.width/3
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right

        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:265
            height: width
            anchors.centerIn: parent

            workColor:"#DE932F"
            workState:QmlDevState.state.RStOvState
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("右腔烹饪"):CookFunc.leftWorkModeName(QmlDevState.state.RStOvMode)
            canvasDiameter:width
            percent:workState === workStateEnum.WORKSTATE_RESERVE?(100-100*QmlDevState.state.RStOvOrderTimerLeft/QmlDevState.state.RStOvOrderTimer):(100-100*QmlDevState.state.RStOvSetTimerLeft/QmlDevState.state.RStOvSetTimer)

            orderTimeLeft:QmlDevState.state.RStOvOrderTimerLeft
            workTime:
            {
                if(workState === workStateEnum.WORKSTATE_PREHEAT)
                {
                    return QmlDevState.state.RStOvRealTemp
                }
                else if(workState === workStateEnum.WORKSTATE_RESERVE || (workState === workStateEnum.WORKSTATE_PAUSE && orderTimeLeft!=0))
                {
                    var time=orderTimeLeft
                    return (time<600?"0":"")+ Math.floor(time/60)+":"+(time%60<10?"0":"")+time%60//
                }
                else
                {
                    return QmlDevState.state.RStOvSetTimerLeft
                }
            }
            workTemp:qsTr(QmlDevState.state.RStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_STOP||rightProgressBar.workState === workStateEnum.WORKSTATE_PAUSE)
                    {
                        showNewCook(rightProgressBar.device)
                    }
                    else if(rightProgressBar.workState === workStateEnum.WORKSTATE_PAUSE)
                    {
                        if(QmlDevState.state.RStOvOrderTimerLeft==0)
                        {
                            load_page("pageSteamBakeBase",JSON.stringify({"device":rightDevice,"reserve":0}))
                        }
                        else
                        {
                            var para =CookFunc.getDefHistory()
                            para.cookPos=rightDevice
                            load_page("pageSteamBakeReserve",JSON.stringify(para))
                        }
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
            onConfirm:cookConfirm()
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP && rightProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.left: rightProgressBar.left
            anchors.leftMargin: 10
            anchors.bottom: rightProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
            }
            onClicked:{
                if(QmlDevState.state.RStOvState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("右腔","预约")
                else
                    showCancelRun("右腔","工作")
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP  && rightProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.right: rightProgressBar.right
            anchors.rightMargin: 10
            anchors.bottom: rightProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE?"icon-cookpause.png":"icon-cookrun.png")
            }
            onClicked:{
                if(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE)
                {
                    //                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.START)
                    if(QmlDevState.state.ErrorCodeShow==0)
                    {
                        if(QmlDevState.state.RStOvDoorState==1)
                        {
                            showLoaderPopup("","右腔门开启，工作暂停",275)
                        }
                    }
                    else
                    {
                        showFaultPopup(QmlDevState.state.ErrorCodeShow,rightDevice)
                    }
                }
                else
                {
                    //                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_PAUSE)
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.PAUSE)
                }
            }
        }

    }
    Item{
        width:parent.width/3
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.horizontalCenter: parent.horizontalCenter

        PageCirProgressBar{
            id:iceProgressBar
            device:2
            width:265
            height: width
            anchors.centerIn: parent

            workColor:"#DE932F"
            workState:QmlDevState.state.IceStOvState
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("右腔冰蒸"):CookFunc.leftWorkModeName(QmlDevState.state.IceStOvMode)
            canvasDiameter:width
            percent:0//workMode=="冷凝风机"?0:(100-100*QmlDevState.state.IceStOvSetTimerLeft/QmlDevState.state.IceStOvSetTimer)

            //            orderTimeLeft:QmlDevState.state.IceStOvOrderTimerLeft
            workTime:
            {
                if(workState === workStateEnum.WORKSTATE_PREHEAT)
                {
                    return QmlDevState.state.RStOvRealTemp-3
                }
                else if(workState === workStateEnum.WORKSTATE_RESERVE || (workState === workStateEnum.WORKSTATE_PAUSE && orderTimeLeft!=0))
                {
                    var time=orderTimeLeft
                    return (time<600?"0":"")+ Math.floor(time/60)+":"+(time%60<10?"0":"")+time%60//
                }
                else
                {
                    if(workMode=="冷凝风机")
                        return ""
                    else
                        return QmlDevState.state.IceStOvSetTimerLeft
                }
            }
            workTemp:qsTr(QmlDevState.state.IceStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    mouse.accepted = false
                }
                onPressed: {
                    mouse.accepted = false
                }
                onReleased: {
                    mouse.accepted = false
                }
            }
            onConfirm:cookConfirm()
        }
        Button{
            visible: iceProgressBar.workState !== workStateEnum.WORKSTATE_STOP && iceProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.left: iceProgressBar.left
            anchors.leftMargin: 10
            anchors.bottom: iceProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
            }
            onClicked:{
                if(QmlDevState.state.IcStOvState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("冰蒸","预约")
                else
                    showCancelRun("冰蒸","工作")
            }
        }
        Button{
            visible: iceProgressBar.workState !== workStateEnum.WORKSTATE_STOP  && iceProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:60
            height: width
            anchors.right: iceProgressBar.right
            anchors.rightMargin: 10
            anchors.bottom: iceProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                asynchronous:true
                smooth:false
                anchors.centerIn:parent
                source: themesImagesPath+(QmlDevState.state.RStOvState===workStateEnum.WORKSTATE_PAUSE?"icon-cookpause.png":"icon-cookrun.png")
            }
            onClicked:{
                if(QmlDevState.state.IcStOvState===workStateEnum.WORKSTATE_PAUSE)
                {
                    SendFunc.setCookOperation(iceDevice,workOperationEnum.START)
                }
                else
                {
                    SendFunc.setCookOperation(iceDevice,workOperationEnum.PAUSE)
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
    //                if(value==100)
    //                {
    //                    QmlDevState.setState("LStOvState",4)
    //                    QmlDevState.setState("RStOvState",4)
    //                }

    //            }
    //        }
    //    }
    PageHomeBar {
        id:statusBar
        anchors.bottom: parent.bottom
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
                if(hintTopText.indexOf("左腔")!=-1)
                {
                    SendFunc.setCookOperation(leftDevice,workOperationEnum.CANCEL)
                }
                else if(hintTopText.indexOf("右腔")!=-1)
                {
                    SendFunc.setCookOperation(rightDevice,workOperationEnum.CANCEL)
                }
                else
                {
                    SendFunc.setCookOperation(iceDevice,workOperationEnum.CANCEL)
                }
                closeLoaderMain()
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
