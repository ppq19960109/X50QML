import QtQuick 2.7
//import QtGraphicalEffects 1.0

Item{
    width: 600
    height:358
    //    Rectangle {
    //        width: 600
    //        height: 600
    //        gradient: Gradient {
    //            GradientStop { position: 0; color: "white" }
    //            GradientStop { position: 1; color: "black" }
    //        }
    //        Row {
    //            opacity: 0.5
    //            Item {
    //                id: foo
    //                width: 100; height: 100
    //                Rectangle { x: 5; y: 5; width: 60; height: 60; color: "red" }
    //                Rectangle { x: 20; y: 20; width: 60; height: 60; color: "orange" }
    //                Rectangle { x: 35; y: 35; width: 60; height: 60; color: "yellow" }
    //            }
    //            ShaderEffectSource {
    //                width: 400; height: 400
    //                sourceItem: foo
    //            }
    //        }
    //    }

        Rectangle {

            anchors.fill: parent
            radius: 8
            rotation:  0
            border.width:1
            border.color:"#97A3A1"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#373A3A" }
                GradientStop { position: 0.51; color: "#596767" }
                GradientStop { position: 1.0; color: "#383A3A" }
            }
        }

//    Rectangle {
//        id:rect
//        anchors.fill: parent
//        radius: 8
//        border.width:1
//        border.color:"#97A3A1"
//        LinearGradient {            ///--[Mark]
//            anchors.fill: rect
//            anchors.margins: 1
//            source: rect
//            start: Qt.point(0, 0)
//            //            end: Qt.point(width, 0)      ///1.横向渐变
//            //            end: Qt.point(0, height)     ///2.竖向渐变
//            end: Qt.point(height, height) ///3.斜向渐变
//            gradient: Gradient {
//                GradientStop { position: 0.0; color: "#373A3A" }
//                GradientStop { position: 0.51; color: "#596767" }
//                GradientStop { position: 1.0; color: "#383A3A" }
//            }
//        }
//    }
//    DropShadow {
//        anchors.fill: rect
//        horizontalOffset: 0
//        verticalOffset: 7
//        radius: 6
//        samples: 13
//        color: "#042017"
//        opacity: 0.4
//        source: rect
//    }
}
