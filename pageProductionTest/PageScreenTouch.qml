import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id:root
    property var containerqml: null
    property int pressedX: 0
    property int pressedY: 0
    property int touchCount: 0
    property int touchExited:0
    property int timeout:20
    readonly property int rectWidth: 100
    readonly property int passWidth: 500
    readonly property int passHeight: 320
    Timer{
        id:timer_test
        repeat: true
        running: true
        interval: 1000
        triggeredOnStart: false
        onTriggered: {
            if(--timeout==0)
            {
                containerqml.clickedTouchFunc(-1)
                backPrePage()
            }
        }
    }
    Component.onCompleted: {

    }

    function touchJudge(x,y,parent)
    {
//        console.log("touchJudge",parent.width,parent.height,x,y,pressedX,pressedY)
        if(touchExited>2)
            return -1

        if(parent.width>parent.height)
        {
            if(Math.abs(x-pressedX)>passWidth)
            {
                return 0
            }
        }
        else
        {
            if(Math.abs(y-pressedY)>passHeight)
            {
                return 0
            }
        }

        return -1
    }
    Rectangle{
        property real lastX
        property real lastY
        id:rect
        x:0
        y:0
        width:800
        height:rectWidth
        color:themesTextColor2
        transformOrigin: Item.Center
        rotation:0
        Canvas{
            id:canvas
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
//                console.log("onPressed",mouse.x,mouse.y)
                parent.lastX = mouseX//鼠标位置
                parent.lastY = mouseY
                pressedX = mouseX
                pressedY = mouseY
                touchExited=0
            }
            onReleased: {
//                console.log("onReleased",mouse.x,mouse.y)
                canvas.context.reset()
                canvas.requestPaint()
                if(touchJudge(mouse.x,mouse.y,parent)==0)
                {
                    ++touchCount;
                }
            }
            onPositionChanged:{
//                console.log("onPositionChanged",mouse.x,mouse.y)
                canvas.requestPaint()//重绘
            }
            onExited:{
                ++touchExited
            }
        }
    }
    Text {
        anchors.top: parent.top
        anchors.topMargin: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 100
        color: themesTextColor
        font.pixelSize: 40
        text: timeout+"s"
    }
    onTouchCountChanged:{
//        console.log("onTouchCountChanged",touchCount)
        timeout=20
        if(touchCount==1)
        {
            rect.width=rectWidth
            rect.height=root.height
        }
        else if(touchCount==2)
        {
            rect.width=root.width
            rect.height=rectWidth
            rect.y=root.height-rectWidth
        }
        else if(touchCount==3)
        {
            rect.width=rectWidth
            rect.height=root.height
            rect.x=root.width-rectWidth
            rect.y=0
        }
        else if(touchCount==4)
        {
            rect.x=root.width/2-rectWidth/2
            rect.y=0
        }
        else if(touchCount==5)
        {
            rect.width=root.width
            rect.height=rectWidth
            rect.x=0
            rect.y=root.height/2-rectWidth/2
        }
        else if(touchCount==6)
        {
            rect.width=root.width+5
            rect.rotation=31
        }
        else if(touchCount==7)
        {
            rect.rotation=-31
        }
        else if(touchCount>=8)
        {
            containerqml.clickedTouchFunc(1)
            backPrePage()
        }
    }

}
