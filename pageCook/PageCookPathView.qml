import QtQuick 2.9
import QtQuick.Controls 2.2

Item {

    property alias model:pathView.model
    property alias cacheItemCount:pathView.cacheItemCount
    property alias pathItemCount:pathView.pathItemCount
    property alias currentIndex:pathView.currentIndex
    property alias moving:pathView.moving
    property alias interactive:pathView.interactive
    property int delegateType:0
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
        }
    }
    PathView {
        id:pathView
        anchors.fill: parent
        cacheItemCount:3
//        currentIndex:0
        pathItemCount:5
        interactive: true

        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightMoveDuration:160
        highlightRangeMode: PathView.StrictlyEnforceRange
        maximumFlickVelocity:2400
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
            console.log("currentIndex:",currentIndex);
            indexChanged(currentIndex);
        }
    }
}
