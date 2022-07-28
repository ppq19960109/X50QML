import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias radius:canvas.width
    property real percent


    function updatePaint()
    {
        canvas.requestPaint()
    }

    Canvas{
        property real lineWidth:10
        property real r: canvas.width/2-lineWidth
        id: canvas
        //        width: radius
        height: width
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.translate(canvas.width/2,canvas.height/2)
            ctx.lineWidth = 0

            //显示外圈
            ctx.beginPath();
            ctx.strokeStyle = 'white';
            ctx.fillStyle = 'white'
            ctx.arc(0, 0, r, 0, 2*Math.PI);
            ctx.closePath()
            ctx.stroke();
            ctx.fill()

            var rad=(2*percent/100-0.5)*Math.PI
            ctx.lineCap="round";
            ctx.lineWidth = lineWidth
            ctx.beginPath();
            ctx.strokeStyle = 'blue';
            ctx.arc(0, 0, r, rad, 1.5*Math.PI);
            ctx.stroke();

            //显示百分数
            ctx.font = "30px sans-serif";
            ctx.textAlign = 'center';
            ctx.fillStyle = "blue";
            ctx.fillText(percent + '%', 0, 0);

            ctx.restore();
        }
    }

}
