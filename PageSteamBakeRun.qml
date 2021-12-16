import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    property string name: "pageSteamBakeRun"
    Component.onCompleted: {
        console.log("PageSteamBakeRun onCompleted")

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

    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        color:"#4A5150"

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:300
            height: 300
            anchors.centerIn: parent
            workColor:"#19A582"
            workMode:workState===workStateEnum.WORKSTATE_STOP?qsTr("左腔烹饪"):QmlDevState.state.MultiMode===1?leftDishName:leftWorkModeFun(QmlDevState.state.LStOvMode)
            canvasDiameter:300
            percent:30
            workState:QmlDevState.state.LStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.LStOvOrderTimerLeft+"分钟":QmlDevState.state.LStOvSetTimerLeft+"分钟"
            workTemp:qsTr(QmlDevState.state.LStOvRealTemp+"℃")
            multCount:QmlDevState.state.cnt
            multCurrent:QmlDevState.state.current-1
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(leftProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                    {
                        mouse.accepted = false
                    }
                    else
                    {
                        showNewCook(leftProgressBar.device)
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
            width:56
            height: width
            anchors.left: leftProgressBar.left
            anchors.leftMargin: 24
            anchors.bottom: leftProgressBar.bottom
            anchors.bottomMargin: 10
            background:Rectangle{
                color:"#000"
                radius: 30
                border.color: "#FFF"
            }
            Text{
                color:"white"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:"x"
            }
            onClicked:{
                QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_STOP)
                setCookOperation(leftDevice,workOperationEnum.CANCEL)
            }
        }
        Button{
            visible: leftProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:56
            height: width
            anchors.right: leftProgressBar.right
            anchors.rightMargin: 24
            anchors.bottom: leftProgressBar.bottom
            anchors.bottomMargin: 10
            background:Rectangle{
                color:"#000"
                radius: 30
                border.color: "#FFF"
            }
            Text{
                color:"white"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:"||"
            }
            onClicked:{
                QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_PAUSE)
                setCookOperation(leftDevice,workOperationEnum.PAUSE)
            }
        }
    }
    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right
        color:"#4A5150"

        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:300
            height: 300
            anchors.centerIn: parent
            workColor:"#19A582"
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
                    if(rightProgressBar.workState === workStateEnum.WORKSTATE_FINISH)
                    {
                        mouse.accepted = false
                    }
                    else
                    {
                        showNewCook(rightProgressBar.device)
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
            width:56
            height: width
            anchors.left: rightProgressBar.left
            anchors.leftMargin: 24
            anchors.bottom: rightProgressBar.bottom
            anchors.bottomMargin: 10
            background:Rectangle{
                color:"#000"
                radius: 30
                border.color: "#FFF"
            }
            Text{
                color:"white"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:"x"
            }
            onClicked:{
                QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_STOP)
                setCookOperation(rightDevice,workOperationEnum.CANCEL)
            }
        }
        Button{
            visible: rightProgressBar.workState !== workStateEnum.WORKSTATE_STOP
            width:56
            height: width
            anchors.right: rightProgressBar.right
            anchors.rightMargin: 24
            anchors.bottom: rightProgressBar.bottom
            anchors.bottomMargin: 10
            background:Rectangle{
                color:"#000"
                radius: 30
                border.color: "#FFF"
            }
            Text{
                color:"white"
                font.pixelSize: 40
                anchors.centerIn:parent
                text:"||"
            }
            onClicked:{
                QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_PAUSE)
                setCookOperation(rightDevice,workOperationEnum.PAUSE)
            }
        }
    }
        Rectangle{
            id:statusBar
            width:parent.width
            height: 80
            anchors.bottom: parent.bottom
            Slider {
                id: slider
                anchors.centerIn: parent
                stepSize: 2
                to: 100
                value: 30
                onValueChanged: {
                    console.log("slider:",value)
                    if(value==100)
                    {
                        QmlDevState.setState("LStOvState",4)
                        QmlDevState.setState("RStOvState",4)
                    }
                    leftProgressBar.updatePaint()
                    rightProgressBar.updatePaint()
                }
            }
        }
//    PageHomeBar {
//        id:statusBar
//        width:parent.width
//        anchors.bottom: parent.bottom
//        height:80
//    }
}
