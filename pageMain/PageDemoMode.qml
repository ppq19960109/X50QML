import QtQuick 2.12
import QtQuick.Controls 2.5

import "qrc:/SendFunc.js" as SendFunc
Item{
    Component.onCompleted: {
        stackView.width=1280
        demoModeStatus=1
        SendFunc.loadPowerSet(4)
    }
    Component.onDestruction: {
        demoModeStatus=0
        SendFunc.loadPowerSet(0)
        stackView.width=1160
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
        clip: true
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo1.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo2.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo3.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo4.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo5.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"demo/demo6.png"
        }
    }
}

