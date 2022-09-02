import QtQuick 2.12
import QtQuick.Controls 2.5

SequentialAnimation {
    id:flashAnimation
    property int flash:0
    running: false
    loops:Animation.Infinite
    NumberAnimation { target: flashAnimation; property: "flash"; from:0;to: 1; duration: 1000 ;easing.type: Easing.Linear}
    NumberAnimation { target: flashAnimation; property: "flash"; from:1;to: 0; duration: 1000 ;easing.type: Easing.Linear}
    onRunningChanged: {
        flash=0
    }
}
