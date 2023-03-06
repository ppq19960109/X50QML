import QtQuick 2.9
import QtQuick.Controls 2.5

Item {
    property alias model:pathView.model
    property alias cacheItemCount:pathView.cacheItemCount
    property alias pathItemCount:pathView.pathItemCount
    property int delegateIndex:0
    property alias currentIndex:pathView.currentIndex
    property alias moving:pathView.moving
    signal valueChanged(int index,string valueName)
    id:root
    //        anchors.fill: parent

    Component {
        id: rectDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 35 : 25
            property color textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
            width:parent.width
            height:parent.height/parent.pathItemCount
//            opacity: PathView.isCurrentItem ? 1 : 0.5

            Text {
                id:text
                anchors.centerIn: parent
                color:textColor
                font.pixelSize: textFont
                text: modelData
            }
        }
    }
    Component {
        id: modeDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 35 : 25
            property color textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
            property url imgUrl:PathView.isCurrentItem ?leftWorkBigImg[modelData.modelData]:leftWorkSmallImg[modelData.modelData]
            width:parent.width
            height:parent.height/parent.pathItemCount
//            opacity: PathView.isCurrentItem ? 1 : 0.5

            Image {
                asynchronous:true
                smooth:false
                anchors.right: text.left
                anchors.rightMargin: 10
                anchors.verticalCenter: text.verticalCenter
                source: imgUrl
            }
            Text {
                id:text
//                anchors.verticalCenter:  parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 30
                color:textColor
                font.pixelSize: textFont
                text: workModeEnum[modelData.modelData]
            }
        }
    }
    PathView {
        id:pathView
        anchors.fill: parent
        cacheItemCount:2
//        currentIndex:0
        pathItemCount:3
        interactive: true
//        focus: true
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightMoveDuration:200
        highlightRangeMode: PathView.StrictlyEnforceRange
        maximumFlickVelocity:3600
//        model:textModel
        delegate:delegateIndex==0?rectDelegate:modeDelegate

        path : Path{
            startX: root.width/2
            startY: 0
            PathLine {
                x :root.width/2
                y:root.height
            }

        }
        onMovementEnded: {
//            console.log("currentIndex:",currentIndex);
            valueChanged(currentIndex,"model");
        }

//        Component.onCompleted: {
//            console.log("parent.x:"+parent.x,"parent.y:"+parent.y,"parent.width:"+parent.width,"parent.height:"+parent.height)
//            console.log("x:"+root.x,"y:"+root.y,"width:"+root.width,"height:"+root.height)
//        }
    }
}
