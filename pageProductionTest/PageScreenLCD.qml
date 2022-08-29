import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"

Item{
    property var containerqml: null
    SwipeView {
        id:swipe
        anchors.fill: parent
        currentIndex:0
        interactive:true //是否可以滑动
        clip: true
        Item{
            Text {
                anchors.centerIn: parent
                color:"#FFF"
                font.pixelSize: 40
                text: qsTr("滑动屏幕,观察测试过程显示的一些图像上是否有黑点和亮点
")
                wrapMode: Text.WrapAnywhere
            }
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image1.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image2.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image3.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image4.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image5.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image6.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image7.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image8.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image9.png"
        }
        Image {
            asynchronous: true
            smooth:false
            source:themesPicturesPath+"test/image10.png"
        }
        Item {
            PageButtonBar{
                anchors.centerIn: parent

                space:150
                models: ["成功","失败"]
                onClick:{
                    if(clickIndex==0)
                    {
                        containerqml.clickedLcdFunc(1)
                    }
                    else
                    {
                        containerqml.clickedLcdFunc(-1)
                    }
                    backPrePage()
                }
            }
        }
        Component.onCompleted:{
            contentItem.highlightMoveDuration = 0       //将移动时间设为0
            contentItem.highlightMoveVelocity = -1
        }
        onCurrentIndexChanged:{
            console.log("onCurrentIndexChanged",currentIndex)
        }
    }
}

