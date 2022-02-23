import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    property int childLockPressCount:0

    anchors.fill: parent
    color: "#000"
    opacity: 0.6

    Button{
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: img.width
        height: img.height

        background:Rectangle{
            color:"transparent"
        }
        Image{
            id:img
            source:"qrc:/x50/main/icon_ts_g.png"
        }
        //        onPressedChanged: {
        //            if (pressed) {
        //                childLockPressCount = 0
        //                longPressTimer.running = true
        //            }
        //            else
        //            {
        //                longPressTimer.running = false
        //                if(childLockPressCount < 2){
        //                    console.log("请长按童锁键取消童锁")
        //                }
        //                else
        //                {
        //                    longPressTimer.running = false
        //                    systemSettings.childLock=false
        //                    console.log("童锁键取消")
        //                    closeLockScreen()
        //                }
        //            }
        //        }
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled:true
        propagateComposedEvents: true

        onPressed: {
            console.warn("PageLockScreen onPressed")
            mouse.accepted = true

            childLockPressCount = 0
            longPressTimer.running = true
        }
        onReleased: {
            console.warn("PageLockScreen onReleased")
            mouse.accepted = true

            longPressTimer.running = false
            if(childLockPressCount < 2){
                console.log("请长按童锁键取消童锁")
            }
            else
            {
                longPressTimer.running = false
                systemSettings.childLock=false
                console.log("童锁键取消")
                closeLockScreen()
            }
        }
    }
    function closeLockScreen(){
        loader_lock_screen.sourceComponent = null
    }
    Timer {
        id: longPressTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            ++childLockPressCount
            console.log("childLockPressCount:",childLockPressCount)
        }
    }
}
