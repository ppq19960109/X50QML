import QtQuick 2.5
import QtQuick.Controls 2.2

//Item {

    BusyIndicator {
        id: control
//        anchors.fill: parent
        background:Rectangle{
            color:"transparent"
        }
        contentItem: Item {
            anchors.centerIn: parent
            implicitWidth: parent.width
            implicitHeight: parent.width

            Item {
                id: item
                anchors.centerIn: parent
                x: parent.width / 2
                y: parent.height / 2
                width: parent.width
                height: parent.height
                opacity: control.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 300
                    }
                }

                RotationAnimator {
                    target: item
                    running: control.visible && control.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 7000
                }

                Repeater {
                    id: repeater
                    model: 8

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 6
                        implicitHeight: 6
                        radius: 5
                        color: index<3?"darkgray":"#fff"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 3
                                origin.y: 3
                            }
                        ]
                    }
                }
            }
        }
    }
//}
