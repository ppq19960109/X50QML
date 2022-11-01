import QtQuick 2.12

Rectangle {
    id: root
    property int frameCnt: 0
    property int sec: 0
    property int fps: 0
    property real fpsAvg: 0
    property alias runing: numberAnimation.running

    radius: 4
    Rectangle{
        height: 2
        color: "red"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        NumberAnimation on width{
            id: numberAnimation
            from: 0
            to: root.width - root.radius
            duration: 1000
            loops: Animation.Infinite
        }
        onWidthChanged: {
            frameCnt++;
        }
    }

    Text{
        id: fpsText
        anchors.centerIn: parent
        font.pixelSize: 20
        text: root.fps + "/" + root.fpsAvg.toFixed(1) + " fps"
    }

    Timer{
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            fpsAvg = fpsAvg + (frameCnt - fpsAvg) / ++sec;
            fps = frameCnt
            frameCnt = 0
        }
    }
}
