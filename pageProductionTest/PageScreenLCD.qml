import QtQuick 2.7
import QtQuick.Controls 2.2

//Image {
//    property int step: 1
//    width: 800
//    height: 480
//    sourceSize.width: 800
//    sourceSize.height: 480
////    asynchronous: true
//    smooth:false
//    source:step>10?"":"qrc:/x50/test/image"+step+".png" //themesImagesPath+"image"+step+".png"
//    visible: status==Image.Ready
//    MouseArea{
//        anchors.fill: parent
//        onClicked: {
//            if(++step>10)
//            {
//                backPrePage()
//            }
//        }
//    }
//}

SwipeView {
    currentIndex:0

    interactive:true //是否可以滑动
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image5.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image1.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image2.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image3.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image4.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image6.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image7.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image8.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image9.png"
    }
    Image {
        asynchronous: true
        smooth:false
        cache:false
        source:"qrc:/x50/test/image10.png"
    }
    Item {}
    Component.onCompleted:{
        contentItem.highlightMoveDuration = 1       //将移动时间设为0
        contentItem.highlightMoveVelocity = -1
    }
    onCurrentIndexChanged:{
//        console.log("onCurrentIndexChanged",currentIndex)
        if(currentIndex>=10)
            backPrePage()
    }
}
//AnimatedSprite {
//    property int step: 1
//    anchors.fill: parent
//    source: "qrc:/x50/test/image"+step+".png"
//    frameWidth: 800
//    frameHeight: 480
//    frameDuration: 4000
//    frameCount: 1
//    frameX: 0
//    frameY: 0
//    frameSync :false
//    interpolate :true
//    loops :1
//    MouseArea{
//        anchors.fill: parent
//        onClicked: {
//            if(++step>10)
//            {
//                backPrePage()
//            }
//        }
//    }
//}
