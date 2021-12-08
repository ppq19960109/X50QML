import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    property int device
    property real percent

    property int workState

    property alias workMode:mode.text
    property alias canvasDiameter:canvas.width

    property alias workTime:time.text
    property alias workTemp:temp.text
    property alias multCount:indicator.count
    property alias multCurrent:indicator.currentIndex
    Text{
        id:mode
        color:"white"
        font.pixelSize: 30
        anchors.bottom:canvas.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment :Text.AlignHCenter
        verticalAlignment :Text.AlignHCenter
    }
    function updatePaint()
    {
        console.log("updatePaint:",mode.text)
        canvas.requestPaint()
    }

    Canvas{
        property real lineWidth:10
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
            ctx.strokeStyle = 'white'
            ctx.fillStyle = 'white'
            ctx.arc(0, 0, r, 0, 2*Math.PI)
            ctx.closePath()
            ctx.stroke()
            ctx.fill()
            if(workState && percent<100)
            {
                var rad=(2*percent/100-0.5)*Math.PI
                ctx.lineCap="round"
                ctx.lineWidth = lineWidth
                ctx.beginPath()
                ctx.strokeStyle = 'blue'
                ctx.arc(0, 0, r, rad, 1.5*Math.PI)
                ctx.stroke()

                //            console.log("radian:",rad,"r:",r,"Angle",360*percent/100)
                var x = Math.cos(rad)*r
                var y = Math.sin(rad)*r
                //            console.log("x:",x,"y:",y)
                ctx.beginPath()
                ctx.fillStyle = 'blue'
                ctx.arc(x, y, lineWidth, 0, 2*Math.PI)
                ctx.closePath()
                ctx.fill()
            }
            //显示百分数
            //                ctx.font = "30px sans-serif"
            //                ctx.textAlign = 'center'
            //                ctx.fillStyle = "blue"
            //                ctx.fillText(percent + '%', 0, 0)

            ctx.restore()
        }
    }
    Item{
        width:canvas.width
        height: canvas.height
        anchors.centerIn: parent

        Text{
            id:state
            color:"black"
            visible: workState !== workStateEnum.WORKSTATE_STOP
            font.pixelSize: 40
            anchors.top:parent.top
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment :Text.AlignHCenter
            verticalAlignment :Text.AlignHCenter
            text: workStateArray[workState]
        }
        Button{
            visible: workState !== workStateEnum.WORKSTATE_STOP
            width:160
            height: 50
            anchors.centerIn: parent
            background:Rectangle{
                color:"transparent"
                border.color: workState==4?"black":"transparent"
            }
            Text{
                id:time
                color:"black"
                font.pixelSize: 40
                anchors.verticalCenter:  parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment :Text.AlignHCenter
                verticalAlignment :Text.AlignHCenter
                //            text: qsTr(workTime+"分钟")
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
        Text{
            id:temp
            color:"black"
            font.pixelSize: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment :Text.AlignHCenter
            verticalAlignment :Text.AlignHCenter
            //            text: workTemp
        }
        PageIndicator {
            id:indicator
            visible: count != 0
            count: 0
            currentIndex: 0
            anchors.top: temp.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: true
//            delegate: Image {

//                source:index===swipeview.currentIndex
//                       ?"images/main_menu/user_active"+index+".png":"images/main_menu/user_normal"+index+".png"
//                anchors.verticalCenter:parent.verticalCenter
//            }
        }
    }
    Button{
        visible: workState !== workStateEnum.WORKSTATE_STOP
        width:80
        height: width
        anchors.left: canvas.left
        anchors.top: canvas.bottom
        background:Rectangle{
            color:"transparent"
        }
        Text{
            color:"white"
            font.pixelSize: 40
            anchors.centerIn:parent
            text:"x"
        }
        onClicked:{
            console.log("PageCirProgressBar device",device)
            if(leftDevice==device)
            {
                QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_STOP)
            }
            else
            {
                QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_STOP)
            }
            setCookOperation(device,workOperationEnum.CANCEL)
        }
    }
    Button{
        visible: workState !== workStateEnum.WORKSTATE_STOP
        width:80
        height: width
        anchors.right: canvas.right
        anchors.top: canvas.bottom
        background:Rectangle{
            color:"transparent"
        }
        Text{
            color:"white"
            font.pixelSize: 40
            anchors.centerIn:parent
            text:"||"
        }
        onClicked:{
            console.log("PageCirProgressBar device",device)
            if(leftDevice==device)
            {
                QmlDevState.setState("LStOvState",workStateEnum.WORKSTATE_PAUSE)
            }
            else
            {
                QmlDevState.setState("RStOvState",workStateEnum.WORKSTATE_PAUSE)
            }
            setCookOperation(device,workOperationEnum.PAUSE)
        }
    }


}
