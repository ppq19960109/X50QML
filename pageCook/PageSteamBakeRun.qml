import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Rectangle {
    color: themesWindowBackgroundColor
    property string name: "pageSteamBakeRun"


    Component.onCompleted: {
        leftProgressBar.updatePaint()
        rightProgressBar.updatePaint()
        loaderSteamHide()
        sleepWakeup()
    }
    Component.onDestruction: {
        closeCancelRun()
        loaderNewCookHide()
        steamingStatus=false
    }
    StackView.onActivating:{
        SendFunc.permitSteamStartStatus(0)
    }
    StackView.onActivated:{
        if(permitStartStatus>0)
            SendFunc.permitSteamStartStatus(0)
    }

    function cookConfirm(){
        console.log("cookConfirm",leftProgressBar.workState,rightProgressBar.workState)
        if(leftProgressBar.workState===workStateEnum.WORKSTATE_FINISH)
        {
            SendFunc.setCookOperation(cookWorkPosEnum.LEFT,workOperationEnum.CONFIRM)
        }
        if(rightProgressBar.workState===workStateEnum.WORKSTATE_FINISH||rightProgressBar.workState===workStateEnum.WORKSTATE_CLEAN_FINISH)
        {
            SendFunc.setCookOperation(cookWorkPosEnum.RIGHT,workOperationEnum.CONFIRM)
        }
    }

    Item{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        Item{
            visible: leftProgressBar.workState!==workStateEnum.WORKSTATE_STOP && rightProgressBar.workState!==workStateEnum.WORKSTATE_STOP
            width: 80
            height:80
            anchors.top:parent.top
            anchors.topMargin: 20
            anchors.left:parent.left
            anchors.leftMargin: 15
            Image {
                anchors.top:parent.top
                anchors.left:parent.left
                source: themesImagesPath+"icon-cookstatus-left.png"
            }
            Text {
                width: 70
                height:70
                anchors.top:parent.top
                anchors.right:parent.right
                font.pixelSize: 30
                color:"#878787"
                text:"左腔\n状态"
                //                wrapMode: Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }
        }
        PageRotationImg{
            width: 310
            height: width
            visible:leftProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT
            duration:8000
            anchors.centerIn: leftProgressBar
            source:"qrc:/x50/icon_left_runing.png"
        }

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:310
            height: width
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 15

            workColor:"#E68855"
            workState:QmlDevState.state.LStOvState
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("左腔烹饪"):QmlDevState.state.MultiMode===1?QmlDevState.state.CookbookName:CookFunc.leftWorkModeName(QmlDevState.state.LStOvMode)
            canvasDiameter:width
            setTimeLeft:QmlDevState.state.LStOvSetTimerLeft
            orderTimeLeft:QmlDevState.state.LStOvOrderTimerLeft
            percent:(workState === workStateEnum.WORKSTATE_RESERVE|| workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)?(100-100*orderTimeLeft/QmlDevState.state.LStOvOrderTimer):(100-100*setTimeLeft/QmlDevState.state.LStOvSetTimer)
            workTime:
            {
                if(workState === workStateEnum.WORKSTATE_PREHEAT)
                {
                    return QmlDevState.state.LStOvRealTemp
                }
                else if(workState === workStateEnum.WORKSTATE_RESERVE || workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)
                {
                    var time=orderTimeLeft
                    return (time<600?"0":"")+ Math.floor(time/60)+qsTr(" ")+(time%60<10?"0":"")+time%60
                }
                else
                {
                    return setTimeLeft
                }
            }
            workTemp:qsTr(QmlDevState.state.LStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_STOP)
                    {
                        loaderPageNewCook(leftProgressBar.device)
                    }
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_PAUSE && QmlDevState.state.MultiMode==0)
                    {
                        load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.LEFT,"reserve":0})
                    }
                    else if(leftProgressBar.workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        var para =CookFunc.getDefHistory();
                        para.cookPos=cookWorkPosEnum.LEFT
                        var mode=QmlDevState.state.MultiMode
                        if(mode==0)
                        {
                            var list = []
                            var steps={}
                            steps.mode=QmlDevState.state.LStOvMode
                            steps.temp=QmlDevState.state.LStOvSetTemp
                            steps.time=QmlDevState.state.LStOvSetTimer
                            list.push(steps)
                            para.dishName=CookFunc.getDishName(list)
                        }
                        else if(mode==1)
                        {
                            para.dishName=leftProgressBar.workMode
                        }
                        else
                        {
                            para.dishName="多段烹饪"
                        }
                        load_page("pageSteamBakeReserve",{"root":para})
                        para=undefined
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
            onWorkStateChanged: {
                if(workState===workStateEnum.WORKSTATE_STOP || workState === workStateEnum.WORKSTATE_FINISH)
                {
                    closeCancelRun(cookWorkPosEnum.LEFT)
                }
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP && leftProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:90
            height: width
            anchors.left: leftProgressBar.left
            anchors.leftMargin: 5
            anchors.bottom: leftProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
            }
            onClicked:{
                if(leftProgressBar.workState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("左腔","预约")
                else
                    showCancelRun("左腔","工作")
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP && leftProgressBar.workState !== workStateEnum.WORKSTATE_FINISH
            width:90
            height: width
            anchors.right: leftProgressBar.right
            anchors.rightMargin: 5
            anchors.bottom: leftProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                anchors.centerIn:parent
                source: themesImagesPath+((leftProgressBar.workState===workStateEnum.WORKSTATE_PAUSE || leftProgressBar.workState===workStateEnum.WORKSTATE_PAUSE_RESERVE)?"icon-cookpause.png":"icon-cookrun.png")
            }
            onClicked:{
                if(leftProgressBar.workState===workStateEnum.WORKSTATE_PAUSE|| leftProgressBar.workState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                {
                    //                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(cookWorkPosEnum.LEFT,workOperationEnum.START)
                    if(QmlDevState.state.ErrorCodeShow==0)
                    {
                        if(QmlDevState.state.LStOvDoorState==1)
                        {
                            //                            loaderAutoPopupShow("","左腔门开启，工作暂停",292)
                            loaderDoorAutoPopupShow("左腔门开启，工作暂停")
                        }
                    }
                    else
                    {
                        loaderErrorCodeShow(QmlDevState.state.ErrorCodeShow,cookWorkPosEnum.LEFT)
                    }
                }
                else
                {
                    //                    QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_PAUSE)
                    SendFunc.setCookOperation(cookWorkPosEnum.LEFT,workOperationEnum.PAUSE)
                }
            }
        }
        PageIndicator {
            id:leftIndicator
            visible: QmlDevState.state.MultiMode > 0
            count: QmlDevState.state.cnt
            currentIndex: QmlDevState.state.current-1
            anchors.top: leftProgressBar.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: leftProgressBar.horizontalCenter
            interactive: false
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

        Item{
            visible: leftProgressBar.workState!==workStateEnum.WORKSTATE_STOP && rightProgressBar.workState!==workStateEnum.WORKSTATE_STOP
            width: 80
            height:80
            anchors.top:parent.top
            anchors.topMargin: 20
            anchors.right:parent.right
            anchors.rightMargin: 15
            Image {
                anchors.top:parent.top
                anchors.right:parent.right
                source: themesImagesPath+"icon-cookstatus-right.png"
            }
            Text {
                width: 70
                height:70
                anchors.top:parent.top
                anchors.left:parent.left
                font.pixelSize: 30
                color:"#878787"
                text:"右腔\n状态"
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
            }
        }
        PageRotationImg{
            width: 310
            height: width
            visible:rightProgressBar.workState === workStateEnum.WORKSTATE_PREHEAT
            duration:8000
            anchors.centerIn: rightProgressBar
            source:"qrc:/x50/icon_right_runing.png"
        }
        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:310
            height: width
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -15

            workColor:"#DE932F"
            workState:QmlDevState.state.RStOvState
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("右腔烹饪"):"智能模式"
            canvasDiameter:width
            setTimeLeft:Math.ceil(QmlDevState.state.RStOvSetTimerLeft/60)
            orderTimeLeft:QmlDevState.state.RStOvOrderTimerLeft
            percent:(workState === workStateEnum.WORKSTATE_RESERVE|| workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)?(100-100*orderTimeLeft/QmlDevState.state.RStOvOrderTimer):(100-Math.floor(100*QmlDevState.state.RStOvSetTimerLeft/QmlDevState.state.RStOvSetTimer))
            workTime:
            {
                if(workState === workStateEnum.WORKSTATE_PREHEAT)
                {
                    return QmlDevState.state.RStOvRealTemp
                }
                else if(workState === workStateEnum.WORKSTATE_RESERVE || workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)
                {
                    var time=orderTimeLeft
                    return (time<600?"0":"")+ Math.floor(time/60)+qsTr(" ")+(time%60<10?"0":"")+time%60
                }
                else
                {
                    return setTimeLeft
                }
            }
            workTemp:qsTr(QmlDevState.state.RStOvRealTemp+"℃ "+QmlDevState.state.RStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_STOP)
                    {
                        loaderPageNewCook(rightProgressBar.device)
                    }
                    else if(rightProgressBar.workState === workStateEnum.WORKSTATE_PAUSE)
                    {
                        load_page("pageSteamBakeBase",{"device":cookWorkPosEnum.RIGHT,"reserve":0})
                    }
                    else if(rightProgressBar.workState === workStateEnum.WORKSTATE_PAUSE_RESERVE)
                    {
                        var para =CookFunc.getDefHistory()
                        para.cookPos=cookWorkPosEnum.RIGHT
                        var list = []
                        var steps={}
                        steps.mode=QmlDevState.state.RStOvMode
                        steps.temp=QmlDevState.state.RStOvSetTemp
                        steps.time=QmlDevState.state.RStOvSetTimer
                        list.push(steps)
                        para.dishName=CookFunc.getDishName(list)
                        load_page("pageSteamBakeReserve",{"root":para})
                        para=undefined
                    }
                    else
                    {
                        mouse.accepted = false
                    }
                }
                onPressed: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_FINISH||rightProgressBar.workState === workStateEnum.WORKSTATE_CLEAN_FINISH)
                        mouse.accepted = false
                }
                onReleased: {
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_FINISH||rightProgressBar.workState === workStateEnum.WORKSTATE_CLEAN_FINISH)
                        mouse.accepted = false
                }
            }
            onConfirm:{
                if(index==0)
                    cookConfirm()
                else
                    load_page("pagePanguClear")

            }
            onWorkStateChanged: {
                if(workState===workStateEnum.WORKSTATE_STOP || workState === workStateEnum.WORKSTATE_FINISH)
                {
                    closeCancelRun(cookWorkPosEnum.RIGHT)
                }
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP && rightProgressBar.workState !== workStateEnum.WORKSTATE_FINISH && rightProgressBar.workState !== workStateEnum.WORKSTATE_CLEAN_FINISH
            width:90
            height: width
            anchors.left: rightProgressBar.left
            anchors.leftMargin: 5
            anchors.bottom: rightProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                anchors.centerIn:parent
                source: themesImagesPath+"icon-cookclose.png"
            }
            onClicked:{
                if(rightProgressBar.workState === workStateEnum.WORKSTATE_RESERVE)
                    showCancelRun("右腔","预约")
                else
                    showCancelRun("右腔","工作")
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP  && rightProgressBar.workState !== workStateEnum.WORKSTATE_FINISH && rightProgressBar.workState !== workStateEnum.WORKSTATE_CLEAN_FINISH
            width:90
            height: width
            anchors.right: rightProgressBar.right
            anchors.rightMargin: 5
            anchors.bottom: rightProgressBar.bottom
            //            anchors.bottomMargin: -10
            background:Image {
                anchors.centerIn:parent
                source: themesImagesPath+((rightProgressBar.workState===workStateEnum.WORKSTATE_PAUSE|| rightProgressBar.workState===workStateEnum.WORKSTATE_PAUSE_RESERVE)?"icon-cookpause.png":"icon-cookrun.png")
            }
            onClicked:{
                if(rightProgressBar.workState===workStateEnum.WORKSTATE_PAUSE|| rightProgressBar.workState===workStateEnum.WORKSTATE_PAUSE_RESERVE)
                {
                    //                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_RUN)
                    SendFunc.setCookOperation(cookWorkPosEnum.RIGHT,workOperationEnum.START)

                    if(QmlDevState.state.ErrorCodeShow==0)
                    {
                        if(QmlDevState.state.RStOvDoorState==1)
                        {
                            //                            loaderAutoPopupShow("","右腔门开启，工作暂停",292)
                            loaderDoorAutoPopupShow("右腔门开启，工作暂停")
                        }
                    }
                    else
                    {
                        loaderErrorCodeShow(QmlDevState.state.ErrorCodeShow,cookWorkPosEnum.RIGHT)
                    }
                }
                else
                {
                    //                    QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_PAUSE)
                    SendFunc.setCookOperation(cookWorkPosEnum.RIGHT,workOperationEnum.PAUSE)
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
}
