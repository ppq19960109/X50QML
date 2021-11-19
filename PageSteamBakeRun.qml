import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    property string name: "pageSteamBakeRun"
    Component.onCompleted: {
        console.log("PageSteamBakeRun onCompleted")

    }
    enum WORKSTATE {
        WORKSTATE_STOP = 0,
        WORKSTATE_RESERVE = 1,
        WORKSTATE_PREHEAT = 2,
        WORKSTATE_RUN = 3,
        WORKSTATE_FINISH = 4,
        WORKSTATE_PAUSE = 5
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
            name:"左腔"
            width:250
            height: 250
            anchors.centerIn: parent
            workMode:leftWorkModeArr[QmlDevState.state.StOvMode]
            canvasDiameter:250
            percent:slider.value
            workState:QmlDevState.state.StOvState
            workTime:workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH?"返回":QmlDevState.state.StOvSetTimer+"分钟"
            workTemp:workState==0?qsTr("左腔烹饪"):qsTr(QmlDevState.state.StOvSetTemp+"℃")
            multCount:QmlDevState.state.cnt
            multCur:QmlDevState.state.current
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(leftProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
                    {
                        mouse.accepted = false
                    }
                    else
                    {
                        load_page("pageSteamBakeBase",JSON.stringify({"device":"left"}))
                    }
                }
                onPressed: {
                    if(leftProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
                onReleased: {
                    if(leftProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
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
            name:"右腔"
            width:250
            height: 250
            anchors.centerIn: parent
            workMode:workState==0?qsTr("右腔"):rightWorkMode
            canvasDiameter:250
            percent:slider.value
            workState:QmlDevState.state.RStOvState
            workTime:workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH?"返回":QmlDevState.state.RStOvSetTimer+"分钟"
            workTemp:workState==0?qsTr("右腔烹饪"):qsTr(QmlDevState.state.RStOvSetTemp+"℃")
            MouseArea{
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: {
                    if(rightProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
                    {
                        mouse.accepted = false
                    }
                    else
                    {
                        load_page("pageSteamBakeBase",JSON.stringify({"device":"right"}))
                    }
                }
                onPressed: {
                    if(rightProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
                        mouse.accepted = false
                }
                onReleased: {
                    if(rightProgressBar.workState==PageSteamBakeRun.WORKSTATE.WORKSTATE_FINISH)
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
                    QmlDevState.setState("StOvState",4)
                    QmlDevState.setState("RightStOvState",4)
                }
                leftProgressBar.updatePaint()
                rightProgressBar.updatePaint()
            }
        }
    }
}
