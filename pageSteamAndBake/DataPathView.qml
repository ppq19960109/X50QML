import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias model:pathView.model
    property alias delegate:pathView.delegate
    property alias currentIndex:pathView.currentIndex
    signal valueChanged(var index,var valueName)
    id:root
    //        anchors.fill: parent


    PathView {
        id:pathView
        anchors.fill: parent

        currentIndex:0
        pathItemCount:3
        interactive: true
        focus: true;
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightRangeMode: PathView.StrictlyEnforceRange;

//        model:textModel
//        delegate:rectDelegate

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

//        Component.onCompleted: {
//            console.log("parent.x:"+parent.x,"parent.y:"+parent.y,"parent.width:"+parent.width,"parent.height:"+parent.height)
//            console.log("x:"+root.x,"y:"+root.y,"width:"+root.width,"height:"+root.height)
//        }
    }
}
