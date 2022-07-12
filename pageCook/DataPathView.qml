import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias model:pathView.model
    property alias cacheItemCount:pathView.cacheItemCount
    property int delegateIndex:0
    property alias currentIndex:pathView.currentIndex
    property alias moving:pathView.moving
    signal valueChanged(int index)
    id:root

    Component {
        id: rectDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property color textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
            width:parent.width
            height:parent.height/parent.pathItemCount

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
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property color textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
            property url imgUrl:PathView.isCurrentItem ?leftWorkBigImg[modelData]:leftWorkSmallImg[modelData]
            width:parent.width
            height:parent.height/parent.pathItemCount

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
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 30
                color:textColor
                font.pixelSize: textFont
                text: workModeEnum[modelData]
            }
        }
    }
    PathView {
        id:pathView
        anchors.fill: parent
        cacheItemCount:3
//        currentIndex:0
        pathItemCount:3
        interactive: true

        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightMoveDuration:150
        highlightRangeMode: PathView.StrictlyEnforceRange
        maximumFlickVelocity:2400
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
            console.log("currentIndex:",currentIndex);
            valueChanged(currentIndex);
        }
    }
}
