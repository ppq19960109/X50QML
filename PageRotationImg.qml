import QtQuick 2.2
import QtQuick.Controls 2.2

Image {
    id: busyImg

    RotationAnimator {
        target: busyImg
        running: busyImg.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 5000
    }
}
