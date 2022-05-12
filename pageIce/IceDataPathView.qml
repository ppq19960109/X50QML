import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias model:pathView.model
    property int delegateIndex:0
    property alias currentIndex:pathView.currentIndex
    property alias moving:pathView.moving
    signal valueChanged(var index,var valueName)
    id:root
    //        anchors.fill: parent

    Component {
        id: rectDelegate
        Item  {
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property var textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
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
            property int textFont:PathView.isCurrentItem ? 45 : 35
            property var textColor:PathView.isCurrentItem ?themesTextColor:themesTextColor2
            property var imgUrl:PathView.isCurrentItem ?leftWorkBigImg[modelData]:leftWorkSmallImg[modelData]
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
                anchors.verticalCenter:  parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.horizontalCenterOffset: 20
                color:textColor
                font.pixelSize: textFont
                text: leftWorkMode[modelData]
            }
        }
    }
    PathView {
        id:pathView
        anchors.fill: parent

//        currentIndex:0
        pathItemCount:3
        interactive: true
//        focus: true
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightRangeMode: PathView.StrictlyEnforceRange;

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
            valueChanged(currentIndex,"model");
        }
    }
}
