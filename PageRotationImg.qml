import QtQuick 2.12
import QtQuick.Controls 2.5

Image {
    property alias duration:rotation.duration
    property alias running:rotation.running
    id: busyImg
    asynchronous:true
    RotationAnimator {
        id:rotation
        target: busyImg
        running: busyImg.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 8000
        onDurationChanged: {
            if(duration>0)
                restart()
        }
//        onRunningChanged: {
//            console.log("onRunningChanged",running)
//        }
    }
}
