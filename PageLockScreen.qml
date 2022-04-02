import QtQuick 2.0
import QtQuick.Controls 2.2

Rectangle {
    property int childLockPressCount:0

    anchors.fill: parent
    color: "#000"
    opacity: 0.6

    Image{
        asynchronous:true
        anchors.right: parent.right
        anchors.bottom: lockBtn.top
        source:"qrc:/x50/main/icon_ts_g_k.png"
    }
    Button{
        id:lockBtn
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: img.width
        height: img.height

        background:Rectangle{
            color:"transparent"
        }
        Image{
            id:img
            asynchronous:true
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
        //            }
        //        }
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled:true
        propagateComposedEvents: true

        onPressed: {
            console.warn("PageLockScreen onPressed",mouse.x,mouse.y)
            mouse.accepted = true
            if(mouse.x<680||mouse.y<400)
            {
                return
            }

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
        }
        onPositionChanged:{
            //console.warn("PageLockScreen onPositionChanged",mouse.x,mouse.y)
        }
    }

    Timer {
        id: longPressTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            if(childLockPressCount<3)
            {
                ++childLockPressCount
                if(childLockPressCount==3)
                {
                    longPressTimer.running = false
                    systemSettings.childLock=false
                    console.log("童锁键取消")
                    closeLockScreen()
                }
            }
            console.log("childLockPressCount:",childLockPressCount)
        }
    }
}
