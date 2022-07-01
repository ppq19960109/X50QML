import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/SendFunc.js" as SendFunc
Item{
    Component.onCompleted: {
        SendFunc.loadPowerSet(4)
        SendFunc.setBuzControl(buzControlEnum.SHORT)
    }
    Component.onDestruction: {
        SendFunc.loadPowerSet(0)
    }
    Timer{
        repeat: true
        running: true
        interval: 2000
        triggeredOnStart: false
        onTriggered: {
            console.log("onTriggered")
            if(swipeview.currentIndex < swipeview.count){
                swipeview.currentIndex+=1
            }
            else{
                swipeview.currentIndex=0
            }
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

        Component.onCompleted:{
            contentItem.highlightMoveDuration = 10       //将移动时间设为0
            contentItem.highlightMoveVelocity = -1
            contentItem.boundsBehavior=Flickable.StopAtBounds
        }
        onCurrentIndexChanged:{
            console.log("onCurrentIndexChanged",currentIndex)
        }
    }
}

