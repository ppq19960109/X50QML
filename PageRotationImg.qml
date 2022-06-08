import QtQuick 2.7
import QtQuick.Controls 2.2

Image {
    id: busyImg
    asynchronous:true
    smooth:false
    cache:false
    RotationAnimator {
        target: busyImg
        running: busyImg.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 8000
    }
}
