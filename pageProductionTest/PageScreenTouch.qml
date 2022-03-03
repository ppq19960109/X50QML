import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    property int pressedX: 0
    property int pressedY: 0
    property int touchCount: 0
    property int touchExited:0

    readonly property int passWidth: 480
    readonly property int passHeight: 280
    color: "transparent"
    Component.onCompleted: {

    }
    function touchJudge(x,y,parent)
    {
        console.warn("touchJudge",parent.width,parent.height,x,y,pressedX,pressedY)
        if(touchExited>0)
            return -1

        if(parent.width>parent.height)
        {
            if(Math.abs(x-pressedX)>passWidth)
            {
                parent.color="green"
                return 0
            }
        }
        else
        {
            if(Math.abs(y-pressedY)>passHeight)
            {
                parent.color="green"
                return 0
            }
        }

        return -1
    }
    Rectangle{
        property real lastX
        property real lastY
        width:parent.width
        height:60
        anchors.verticalCenter:parent.verticalCenter
        color:"#fff"
        rotation:30
        Canvas{
            id:tilted1Canvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = tilted1Area.mouseX
                parent.lastY = tilted1Area.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: tilted1Area
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                tilted1Canvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }

    Rectangle{
        property real lastX
        property real lastY
        width:parent.width
        height:60
        anchors.verticalCenter:parent.verticalCenter
        color:"#fff"
        rotation:-30
        Canvas{
            id:tilted2Canvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = tilted2Area.mouseX
                parent.lastY = tilted2Area.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: tilted2Area
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                tilted2Canvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
    Rectangle{
        property real lastX
        property real lastY
        width:parent.width
        height:60
        anchors.top: parent.top
        color:"#fff"
        Canvas{
            id:topCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = topArea.mouseX
                parent.lastY = topArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行

            }
        }
        MouseArea{
            id: topArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                topCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
    Rectangle{
        property real lastX
        property real lastY
        width:parent.width
        height:60
        anchors.verticalCenter: parent.verticalCenter
        color:"#fff"
        Canvas{
            id:verCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = verArea.mouseX
                parent.lastY = verArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: verArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                verCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
    Rectangle{
        property real lastX
        property real lastY
        width:parent.width
        height:60
        anchors.bottom: parent.bottom
        color:"#fff"
        Canvas{
            id:bottomCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = bottomArea.mouseX
                parent.lastY = bottomArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行

            }
        }
        MouseArea{
            id: bottomArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                bottomCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }

    Rectangle{
        property real lastX
        property real lastY
        width:60
        height:parent.height
        anchors.left: parent.left
        color:"#fff"
        Canvas{
            id:leftCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = leftArea.mouseX
                parent.lastY = leftArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: leftArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                leftCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
    Rectangle{
        property real lastX
        property real lastY
        width:60
        height:parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color:"#fff"
        Canvas{
            id:horCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = horArea.mouseX
                parent.lastY = horArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: horArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                horCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
    Rectangle{
        property real lastX
        property real lastY
        width:60
        height:parent.height
        anchors.right: parent.right
        color:"#fff"
        Canvas{
            id:rightCanvas
            anchors.fill:parent
            contextType: "2d"
            onPaint: {//绘图事件的响应
                context.lineWidth=2;//线的宽度
                context.strokeStyle="red";//线的颜色
                context.beginPath();//开始
                context.moveTo(parent.lastX, parent.lastY)//移动到指定位置
                parent.lastX = rightArea.mouseX
                parent.lastY = rightArea.mouseY
                context.lineTo(parent.lastX, parent.lastY)//划线到指定位置
                context.stroke();//背景执行
            }
        }
        MouseArea{
            id: rightArea
            anchors.fill: parent

            onPressed: {
                console.warn("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
                console.warn("onReleased",mouse.x,mouse.y)
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    parent.z=-1
                    parent.enabled=false
                    if(++touchCount>=8)
                        backPrePage()
                }
            }
            onPositionChanged:{
                console.warn("onPositionChanged",mouse.x,mouse.y)
                rightCanvas.requestPaint()//重绘
            }
            onExited:{
                console.warn("onExited")
                touchExited=1
            }
        }
    }
}
