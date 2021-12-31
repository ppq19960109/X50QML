import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    property int device
    property real percent

    property int workState
    property var workColor

    property alias workMode:mode.text
    property alias canvasDiameter:canvas.width

    property alias workTime:time.text
    property alias workTemp:temp.text

    function updatePaint()
    {
        console.log("updatePaint:",mode.text)
        canvas.requestPaint()
    }

    Canvas{
        property int lineWidth:2
        property real r: canvas.width/2-lineWidth
        id: canvas
        width: canvasDiameter
        height: width
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.translate(canvas.width/2,canvas.height/2)
            ctx.lineWidth = 0

            //显示外圈
            ctx.beginPath()
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = workColor
//            ctx.fillStyle = '#596767'
            ctx.arc(0, 0, r, 0, 2*Math.PI)
            ctx.closePath()
            ctx.stroke()
//            ctx.fill()

            //                var rad=(2*percent/100-0.5)*Math.PI
            //                ctx.lineCap="round"
            //                ctx.lineWidth = lineWidth
            //                ctx.beginPath()
            //                ctx.strokeStyle = 'blue'
            //                ctx.arc(0, 0, r, rad, 1.5*Math.PI)
            //                ctx.stroke()

            //            console.log("radian:",rad,"r:",r,"Angle",360*percent/100)
            //                var x = Math.cos(rad)*r
            //                var y = Math.sin(rad)*r

            //                ctx.beginPath()
            //                ctx.fillStyle = 'blue'
            //                ctx.arc(x, y, lineWidth, 0, 2*Math.PI)
            //                ctx.closePath()
            //                ctx.fill()

            //显示百分数
            //                ctx.font = "30px sans-serif"
            //                ctx.textAlign = 'center'
            //                ctx.fillStyle = "blue"
            //                ctx.fillText(percent + '%', 0, 0)

            ctx.restore()
        }
    }
    Rectangle{
        //        width:canvas.width
        //        height: canvas.height
        color:"transparent"
//        border.color: "#fff"
        anchors.fill: parent

        Text{
            id:state
            color:"white"
            visible: workState !== workStateEnum.WORKSTATE_STOP
            font.pixelSize:(workState === workStateEnum.WORKSTATE_PREHEAT ||workState === workStateEnum.WORKSTATE_FINISH) ? 50:30
            anchors.top:parent.top
            anchors.topMargin: (workState === workStateEnum.WORKSTATE_PREHEAT ||workState === workStateEnum.WORKSTATE_FINISH) ? 100:40
            anchors.horizontalCenter: parent.horizontalCenter
//            horizontalAlignment :Text.AlignHCenter
//            verticalAlignment :Text.AlignHCenter
            text: workStateArray[workState]
        }
        Text{
            id:time
            visible: !(workState === workStateEnum.WORKSTATE_PREHEAT ||workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_STOP)
            color:workColor
            font.pixelSize: 50
            anchors.top:parent.top
            anchors.topMargin:80
            anchors.horizontalCenter: parent.horizontalCenter
//            horizontalAlignment :Text.AlignHCenter
//            verticalAlignment :Text.AlignHCenter
        }
        Button{
            visible: workState === workStateEnum.WORKSTATE_FINISH
            width:160
            height: 55
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"transparent"
                border.color: "white"
            }
            Text{
                color:"white"
                font.pixelSize: 25
                anchors.verticalCenter:  parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment :Text.AlignHCenter
                verticalAlignment :Text.AlignHCenter
                text: qsTr("返回")
            }
            onClicked:{
                console.log("PageCirProgressBar device",device)
                if(workState===workStateEnum.WORKSTATE_FINISH)
                {
                    if(leftDevice==device)
                    {
                        QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_STOP)
                    }
                    else
                    {
                        QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_STOP)
                    }
                    setCookOperation(device,workOperationEnum.CONFIRM)
                }
            }
        }
        Image {
            visible: workState === workStateEnum.WORKSTATE_STOP
            anchors.top:parent.top
            anchors.topMargin:70
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/x50/steam/icon_yqpr.png"
        }
        Text{
            id:mode
            visible: workState !== workStateEnum.WORKSTATE_FINISH
            color:"white"
            font.pixelSize: workState === workStateEnum.WORKSTATE_STOP?35:30
            anchors.bottom:parent.bottom
            anchors.bottomMargin: workState === workStateEnum.WORKSTATE_STOP?75:85
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment :Text.AlignHCenter
            verticalAlignment :Text.AlignHCenter
            elide : Text.ElideMiddle
        }
        Text{
            id:temp
            visible: !(workState === workStateEnum.WORKSTATE_FINISH||workState === workStateEnum.WORKSTATE_STOP)
            color:"white"
            font.pixelSize: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment :Text.AlignHCenter
            verticalAlignment :Text.AlignHCenter
        }

    }

}
