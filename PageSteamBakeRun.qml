import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.left: parent.left
        color:"#000"

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
    Rectangle{
        width:parent.width/2
        anchors.top:parent.top
        anchors.bottom: statusBar.top
        anchors.right: parent.right
        color:"#000"
        Canvas{
            property real percent: slider.value
            property real lineWidth:15
            property real r: canvas.width/2-lineWidth
            id: canvas_cir_bar
            height: 300
            width: 300
            anchors.centerIn: parent
            onPaint: {
                var ctx = getContext("2d");
                //                ctx.reset()
                ctx.save()
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.translate(150,150)
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
                ctx.strokeStyle = 'red';
                ctx.arc(0, 0, r, rad, 1.5*Math.PI);
                //                ctx.closePath()
                ctx.stroke();

                console.log("radian:",rad,"r:",r,"Angle",360*percent/100)
                var x = Math.cos(rad)*r;
                var y = Math.sin(rad)*r;
                console.log("x:",x,"y:",y)

                ctx.beginPath();
                ctx.fillStyle = 'red'
                ctx.arc(x, y, 15, 0, 2*Math.PI);
                ctx.closePath()
                ctx.fill()


                //显示百分数
                ctx.font = "30px sans-serif";
                ctx.textAlign = 'center';
                ctx.fillStyle = "blue";
                ctx.fillText(percent + '%', 0, 0);
                ctx.restore();
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
                canvas.requestPaint()
                canvas_cir_bar.requestPaint()
            }
        }
    }
}
