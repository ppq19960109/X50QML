import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property bool runing:false
    property int mode:0
    property bool outerRing:false
    property real percent:0
    property int roate:0
    property alias canvasDiameter:canvas.width

    function updatePaint()
    {
        canvas.requestPaint()
    }
    onPercentChanged: {
        if(runing == true)
            updatePaint()
    }
    onRoateChanged: {
        if(runing == true)
            updatePaint()
    }
    onRuningChanged: {
        if(runing==true)
            updatePaint()
    }

    Canvas{
        property int r: canvas.width/2-10
        id: canvas
        visible: runing
        width: canvasDiameter
        height: width
        anchors.centerIn: parent
        onPaint: {
            if(runing == false)
            {
                return
            }
            var ctx = getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            ctx.translate(canvas.width/2,canvas.height/2)
            ctx.lineWidth = 20
            if(outerRing == true)
            {
                //显示外圈
                ctx.beginPath()
                ctx.strokeStyle = "#333333"
                ctx.arc(0, 0, r, 0, 2*Math.PI)
                ctx.closePath()
                ctx.stroke()
            }
            var gr = ctx.createConicalGradient(0, 0, 0.5*Math.PI)
            ctx.lineCap="round"
            ctx.beginPath()
            if(mode == 1)
            {
                ctx.rotate(roate*Math.PI/180);

                gr.addColorStop(1, "#00EF832B");
                gr.addColorStop(0, "#FFEF832B");

                ctx.strokeStyle =gr
                ctx.arc(0, 0, r, (-0.5+0.04)*Math.PI, (1.5-0.04)*Math.PI)
            }
            else
            {
                gr.addColorStop(0, "#DE932F");
                gr.addColorStop(1, "#EF832B");
                ctx.strokeStyle =gr
                if(percent==0)
                {
                    ctx.arc(0, 0, r, -0.5*Math.PI, 1.5*Math.PI)
                }
                else
                {
                    ctx.arc(0, 0, r, (-0.5+0.04)*Math.PI, (1.5-0.04-1.92*percent/100)*Math.PI)
                }
            }
            ctx.stroke()

            ctx.restore()
        }
    }


    //    Slider {
    //        anchors.horizontalCenter: parent.horizontalCenter
    //        anchors.bottom: parent.bottom
    //        stepSize: 2
    //        to: 100
    //        value: 30
    //        onValueChanged: {
    //            console.log("slider:",value)
    //            percent=value
    //        }
    //    }
}
