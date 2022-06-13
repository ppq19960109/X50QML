import QtQuick 2.7
//import QtGraphicalEffects 1.0

Item{
    width: 600
    height:360
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
        radius: 16
        rotation:  0
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#454E4E" }
            GradientStop { position: 0.43; color: "#596767" }
            GradientStop { position: 1.0; color: "#4A5454" }
        }
    }
//    Rectangle {
//        anchors.fill: parent
//        radius: 16
//        LinearGradient {            ///--[Mark]
//            anchors.fill: parent
//            start: Qt.point(0, 0)
////            end: Qt.point(width, 0)      ///1.横向渐变
////            end: Qt.point(0, height)     ///2.竖向渐变
//            end: Qt.point(height, height) ///3.斜向渐变
//            gradient: Gradient {
//                GradientStop {  position: 0.0;    color: "#454E4E" }
//                GradientStop {  position: 0.43;    color: "#596767" }
//                GradientStop {  position: 1.0;    color: "#4A5454" }
//            }
//        }
//    }

}
