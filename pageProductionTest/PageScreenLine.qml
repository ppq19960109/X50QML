import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    property int rowCount: 0
    property int rowPos: 0
    property int colCount: 0
    property int colPos: 0
    property int touchExited:0
    Component.onCompleted: {

    }

    Rectangle{
        id:row
        width:parent.width
        height:100
        anchors.verticalCenter: parent.verticalCenter
        color:"blue"
        Canvas{
            property real lastX
            property real lastY
            id:rowCanvas
            anchors.fill:parent
            contextType: "2d"
            visible: true
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                //context.fillStyle="white";//填充颜色
                context.beginPath();//开始
                context.moveTo(lastX, lastY)//移动到指定位置
                lastX = rowarea.mouseX
                lastY = rowarea.mouseY
                context.lineTo(lastX, lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            property real pressedX
            id: rowarea
            anchors.fill: parent
            //            hoverEnabled:true
            propagateComposedEvents: true

            onPressed: {
//                console.log("row onPressed.....",mouse.x,mouse.y)
                row.z=1
                col.z=0
                rowCanvas.lastX = mouseX//鼠标位置
                rowCanvas.lastY = mouseY
                pressedX=mouse.x
                rowPos=0
                touchExited=0
            }
            onReleased: {
//                console.log("row onReleased......",mouse.x,mouse.y)
                rowCanvas.context.reset()
                //                rowCanvas.requestPaint()
                if(touchExited<3 && rowPos>0 && Math.abs(mouse.x-pressedX)>=600)
                    ++rowCount
                rowPos=0
            }
            onPositionChanged:{
//                console.log("row onPositionChanged....",mouse.x,mouse.y)
                rowPos=1
                rowCanvas.requestPaint()//重绘
            }
            onExited:{
                ++touchExited
            }
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.bottom: row.top
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: rowCount
        }
    }
    Rectangle{
        id:col
        width:100
        height:parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color:"blue"

        Canvas{
            property real lastX
            property real lastY
            id:colCanvas
            anchors.fill:parent
            contextType: "2d"
            visible: true
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                //context.fillStyle="white";//填充颜色
                context.beginPath();//开始
                context.moveTo(lastX, lastY)//移动到指定位置
                lastX = colarea.mouseX
                lastY = colarea.mouseY
                context.lineTo(lastX, lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            property real pressedY
            id: colarea
            anchors.fill: parent
            //            hoverEnabled:true
            propagateComposedEvents: true

            onPressed: {
//                console.log("col onPressed.....",mouse.x,mouse.y)
                row.z=0
                col.z=1
                colCanvas.lastX = mouseX//鼠标位置
                colCanvas.lastY = mouseY
                pressedY=mouse.y
                colPos=0
                touchExited=0
            }
            onReleased: {
//                console.log("col onReleased......",mouse.x,mouse.y)
                colCanvas.context.reset()
                //                colCanvas.requestPaint()
                if( touchExited<3 && colPos>0&& Math.abs(mouse.y-pressedY)>=360)
                    ++colCount
                colPos=0
            }
            onPositionChanged:{
//                console.log("col onPositionChanged....",mouse.x,mouse.y)
                colPos=1
                colCanvas.requestPaint()//重绘
            }
            onExited:{
                ++touchExited
            }
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: col.right
        anchors.leftMargin: 20
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: colCount
        }
    }

    Button{
        width:100
        height:50
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        background:Rectangle{
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"退出"
            color:"#fff"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            if(rowPos==0 && colPos==0)
                backPrePage()
        }
    }

}
