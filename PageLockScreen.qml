import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Item {
    property int childLockPressCount:0

    anchors.fill: parent

    Component.onCompleted: {
        SendFunc.setBuzControl(buzControlEnum.SHORT)
    }
    Component.onDestruction: {
        SendFunc.setBuzControl(buzControlEnum.SHORTTWO)
    }

    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.3
    }
    Image{
        anchors.right: parent.right
        anchors.rightMargin: 60
        anchors.bottom: lockBtn.top
        source:themesImagesPath+"icon-lockscreen-hint.png"
    }
    Button{
        id:lockBtn
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 130
        height: 80

        background:Item {}
        Image{
            anchors.centerIn: parent
            source:themesImagesPath+"icon_childlockscreen_close.png"
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
//            console.log("PageLockScreen onPressed",mouse.x,mouse.y)
            mouse.accepted = true
            if(mouse.x<650||mouse.y<390)
            {
                return
            }

            childLockPressCount = 0
            longPressTimer.running = true
        }
        onReleased: {
            console.log("PageLockScreen onReleased")
            mouse.accepted = true

            longPressTimer.running = false
            if(childLockPressCount < 2){
                console.log("请长按童锁键取消童锁")
            }
        }
        //        onPositionChanged:{
        //console.log("PageLockScreen onPositionChanged",mouse.x,mouse.y)
        //        }
    }

    Timer {
        id: longPressTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            if(childLockPressCount<2)
            {
                ++childLockPressCount
                if(childLockPressCount==2)
                {
                    longPressTimer.running = false
                    systemSettings.childLock=false
                    console.log("童锁键取消")
                    loaderLockScreen.source=""
                }
            }
//            console.log("childLockPressCount:",childLockPressCount)
        }
    }
}
