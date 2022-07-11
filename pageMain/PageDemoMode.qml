import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/SendFunc.js" as SendFunc
Item{
    Component.onCompleted: {
        demoModeStatus=1
        SendFunc.loadPowerSet(4)
        //        SendFunc.setBuzControl(buzControlEnum.SHORT)
        SendFunc.permitSteamStartStatus(1)
    }
    Component.onDestruction: {
        demoModeStatus=0
        SendFunc.loadPowerSet(0)
    }
    Timer{
        repeat: true
        running: true
        interval: 4000
        triggeredOnStart: false
        onTriggered: {
            console.log("onTriggered")
            if(swipeview.currentIndex==swipeview.count-1)
                swipeview.currentIndex=0
            else
                swipeview.currentIndex+=1

        }
    }
    SwipeView {
        id:swipeview
        anchors.fill: parent
        currentIndex:0
        interactive:false //是否可以滑动

        Image {
            asynchronous: true
            smooth:false
            source:"qrc:/x50/demo/demo1.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:"qrc:/x50/demo/demo2.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:"qrc:/x50/demo/demo3.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:"qrc:/x50/demo/demo4.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:"qrc:/x50/demo/demo5.png"
        }

        //        Component.onCompleted:{
        //            contentItem.highlightMoveDuration = 10       //将移动时间设为0
        //            contentItem.highlightMoveVelocity = -1
        //            contentItem.boundsBehavior=Flickable.StopAtBounds
        //        }
        onCurrentIndexChanged:{
            console.log("onCurrentIndexChanged",currentIndex)
        }
    }
}

