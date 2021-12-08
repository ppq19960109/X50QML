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

    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        color:"#000"

        PageCirProgressBar{
            id:leftProgressBar
            device:0
            width:250
            height: 250
            anchors.centerIn: parent
            workMode:leftWorkModeFun(QmlDevState.state.LStOvMode)
            canvasDiameter:250
            percent:slider.value
            workState:QmlDevState.state.LStOvState
            workTime:workState === workStateEnum.WORKSTATE_FINISH?"返回":(workState === workStateEnum.WORKSTATE_RESERVE?QmlDevState.state.LStOvOrderTimerLeft+"分钟":QmlDevState.state.LStOvSetTimerLeft+"分钟")
            workTemp:workState==0?qsTr("左腔烹饪"):qsTr(QmlDevState.state.LStOvRealTemp+"℃")
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
                        load_page("pageSteamBakeBase",JSON.stringify({"device":leftProgressBar.device}))
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

    }
    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right
        color:"#000"

        PageCirProgressBar{
            id:rightProgressBar
            device:1
            width:250
            height: 250
            anchors.centerIn: parent
            workMode:workState==0?qsTr("右腔"):rightWorkMode
            canvasDiameter:250
            percent:slider.value
            workState:QmlDevState.state.RStOvState
            workTime:workState === workStateEnum.WORKSTATE_RESERVE?"返回":(workState === workStateEnum.WORKSTATE_FINISH?QmlDevState.state.RStOvSetTimerLeft+"分钟":QmlDevState.state.RStOvOrderTimerLeft+"分钟")
            workTemp:workState==0?qsTr("右腔烹饪"):qsTr(QmlDevState.state.RStOvRealTemp+"℃")
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
                        load_page("pageSteamBakeBase",JSON.stringify({"device":rightProgressBar.device}))
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
    }
    Rectangle{
        id:statusBar
        width:parent.width
        height: 60
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
                    QmlDevState.setState("LStOvMode",4)
                    QmlDevState.setState("RStOvState",4)
                }
                leftProgressBar.updatePaint()
                rightProgressBar.updatePaint()
            }
        }
    }
}
