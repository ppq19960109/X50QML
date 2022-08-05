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
//    source:step>10?"":themesImagesPath+"test/image"+step+".png" //themesImagesPath+"image"+step+".png"
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
Item{
    property var containerqml: null
    SwipeView {
        id:swipe
        anchors.fill: parent
        currentIndex:0

        interactive:true //是否可以滑动
        Item{
            Text {
                width: parent.width-100
                //            height: 50
                anchors.centerIn: parent
                color:"#FFF"
                font.pixelSize: 40
                text: qsTr("滑动屏幕,观察测试过程显示的一些图像上是否有黑点和亮点
")
                wrapMode: Text.WordWrap
                //            horizontalAlignment:Text.AlignHCenter
                //            verticalAlignment:Text.AlignVCenter
            }
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image1.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image2.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image3.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image4.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image5.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image6.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image7.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image8.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image9.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesImagesPath+"test/image10.png"
        }
        Item {
            Button{
                width: 200
                height: 100
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -150

                background:Rectangle{
                    radius: 16
                    color:"green"
                }
                Text{
                    text:"成功"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    containerqml.clickedLcdFunc(1)
                    backPrePage()
                }
            }
            Button{
                width: 200
                height: 100
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 150

                background:Rectangle{
                    radius: 16
                    color:"red"
                }
                Text{
                    text:"失败"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    containerqml.clickedLcdFunc(-1)
                    backPrePage()
                }
            }
        }
        Component.onCompleted:{
            contentItem.highlightMoveDuration = 100       //将移动时间设为0
            contentItem.highlightMoveVelocity = -1
        }

    }
    //    MouseArea{
    //        anchors.fill: parent
    //        enabled: swipe.currentIndex<10
    //        onClicked: {
    //            console.log("onClicked",swipe.currentIndex)
    //            swipe.incrementCurrentIndex()
    //        }
    //    }
}
//AnimatedSprite {
//    property int step: 1
//    anchors.fill: parent
//    source: themesImagesPath+"test/image"+step+".png"
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
