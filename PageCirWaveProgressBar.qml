import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    Canvas{
        property real percent: slider.value
        property real lineWidth:5
        property real r: canvas.width/2-lineWidth
        id: canvas
        height: 300
        width: 300
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d");
            //                ctx.reset()
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.translate(150,150)
            ctx.lineWidth = lineWidth
            //显示外圈
            ctx.beginPath();
            ctx.moveTo(0,0)
            ctx.strokeStyle = 'red';
            ctx.fillStyle = '#00ffff'
            ctx.arc(0, 0, r, 0, 2*Math.PI);
            ctx.stroke();
            ctx.fill();
            ctx.clip()

            //显示sin曲线
            var dy = r-2*r*percent/100
            ctx.beginPath();
            ctx.moveTo(-r,dy)
            for(var x = 0; x < 2*r; x += 1){
                var y = -Math.sin(x*0.021);
                ctx.lineTo(-r+x, dy + y*6);
            }
            //显示波浪
            ctx.lineTo(r, r);
            ctx.lineTo(-r, r);
            ctx.closePath()
            ctx.fillStyle = '#1c86d1';
            ctx.fill();

            //显示百分数
            ctx.font = "30px sans-serif";
            ctx.textAlign = 'center';
            ctx.fillStyle = "blue";
            ctx.fillText(percent + '%', 0, 0);
            ctx.restore();
        }
    }
}
