import QtQuick 2.9
import QtQuick.Controls 2.5

Item {

    property alias model:pathView.model
    property alias cacheItemCount:pathView.cacheItemCount
    property alias pathItemCount:pathView.pathItemCount
    property alias currentIndex:pathView.currentIndex
    property alias moving:pathView.moving
    property alias interactive:pathView.interactive
    property int delegateType:0
    property int longPress:0
    property int longStep:10
    signal indexChanged(int index)
    id:root

    Component {
        id: cookDelegate
        Item  {
            width:parent.width
            height:parent.height/parent.pathItemCount

            Image {
                visible: delegateType!=0
                asynchronous:true
                smooth:false
                anchors.right: text.left
                anchors.rightMargin: 10
                anchors.verticalCenter: text.verticalCenter
                source: delegateType==0?"":themesPicturesPath+"steamoven/"+(workModeImg[modelData.modelData]+(pathView.currentIndex==index ?"":"_small")+".png")
            }
            Text {
                id:text
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: delegateType==0?0:20
                color:pathView.currentIndex==index ? themesTextColor:"#fff"
                font.pixelSize: pathView.currentIndex==index ? (delegateType==0?40:34) : 30
                text: delegateType==0?modelData:workModeEnum[modelData.modelData]
            }
            //            MouseArea{
            //                anchors.fill: parent
            //                onClicked: {
            //                    if(pathView.moving==false)
            //                        pathView.currentIndex=index
            //                }
            //                onPressed: {
            //                    mouse.accepted=false
            //                }
            //            }
        }
    }
    Timer{
        id:timer_longPress
        repeat: true
        running: longPress > 0
        interval: 900
        triggeredOnStart: true
        onTriggered: {
            console.log("timer_longPress onTriggered:",pathView.count,pathView.currentIndex,timer_longPress.interval)
            if(longPress==1)
            {
                if(pathView.count > pathView.currentIndex+longStep)
                    pathView.currentIndex+=longStep
                else
                {
                    pathView.currentIndex = pathView.count-1
                    longPress=0
                }
            }
            else
            {
                if( pathView.currentIndex >= longStep )
                    pathView.currentIndex-=longStep
                else
                {
                    pathView.currentIndex=0
                    longPress=0
                }
            }
            longStep+=5
            if(timer_longPress.interval>500)
            {
                timer_longPress.interval-=100
            }
        }
    }
    PathView {
        id:pathView
        anchors.fill: parent
        //        cacheItemCount:3
        //        currentIndex:0
        pathItemCount:5
        interactive: longPress==0
        dragMargin:10
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        //        highlightMoveDuration:200
        highlightRangeMode: PathView.StrictlyEnforceRange
        maximumFlickVelocity:3600
        //        model:textModel
        delegate:cookDelegate

        path : Path{
            startX: root.width/2
            startY: 0
            PathLine {
                x :root.width/2
                y:root.height
            }
        }
        onMovementEnded: {
            //            console.log("onMovementEnded")
            indexChanged(currentIndex);
        }
        MouseArea{
            anchors.fill: parent
            onPressAndHold: {
                console.log("onPressAndHold",parent.height,mouse.y)
                longStep=10
                timer_longPress.interval=900
                if(mouse.y > parent.height/2)
                    longPress=1
                else
                    longPress=2
            }
            onExited: {
//                console.log("onExited")
                longPress=0
            }
            onReleased: {
//                console.log("onReleased")
                longPress=0
            }
        }
    }
}
