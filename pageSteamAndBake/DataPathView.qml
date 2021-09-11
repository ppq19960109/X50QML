import QtQuick 2.0

Item {
    property string textColor:"#7286A3"
    property string highlightColor:"#ECF4FC"

    id:root
    //        anchors.fill: parent

    Component {
        id: rectDelegate;
        Item  {
            width:root.width
            height:root.height/pathView.pathItemCount
            opacity: PathView.isCurrentItem ? 1 : 0.5
            Text {
                anchors.centerIn: parent
                color:'white'
                font.pixelSize: 40
                text: index;
            }
        }
    }

    PathView {
        id:pathView
        anchors.fill: parent

//        currentIndex:0
        pathItemCount:3
        interactive: true
        maximumFlickVelocity:1000
//        focus: true;
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightRangeMode: PathView.StrictlyEnforceRange;

        model:10
        delegate:rectDelegate

        path : Path{
            startX: root.width/2
            startY: 0
            PathLine {
                x :root.width/2
                y:root.height
            }

        }
//        Component.onCompleted: {
//            console.log("parent.x:"+parent.x,"parent.y:"+parent.y,"parent.width:"+parent.width,"parent.height:"+parent.height)
//            console.log("x:"+root.x,"y:"+root.y,"width:"+root.width,"height:"+root.height)
//        }
    }
}
