import QtQuick 2.7
import QtQuick.Controls 2.2

Image {
    property alias duration:rotation.duration
    property alias smooth:busyImg.smooth
    id: busyImg

    RotationAnimator {
        id:rotation
        target: busyImg
        running: busyImg.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 8000
        onDurationChanged: {
//            console.log("onDurationChanged",busyImg.visible,duration,running)
            if(duration>0)
                restart()
        }
        onRunningChanged: {
//            console.log("onRunningChanged",running)
        }
    }
    Component.onDestruction: {
        rotation.stop()
    }
}
