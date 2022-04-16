import QtQuick 2.7
import QtQuick.Controls 2.2

import "../"
Item {
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("主题")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onLeftClick:{
        }
        onRightClick:{
        }
        onClose:{
            backPrePage()
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: topBar.top

        ListView{
            id:themesList
            width:parent.width
            height:parent.height
            clip: true
            orientation:ListView.Vertical
            currentIndex:currentTheme
            model:systemthemes
            delegate: Item{
                height: 100
                width:parent.width

                Button {
                    width:parent.width
                    height:parent.height-1
                    anchors.top: parent.top
                    background: Rectangle{
                        anchors.fill: parent
                        color:"#000"
                        opacity: themesList.currentIndex===index?0.3:0.15
                    }

                    Text{
                        text: name
                        font.pixelSize: 40
                        anchors.centerIn: parent
                        color:themesList.currentIndex===index?"#00E6B6":"#FFF"

                    }
                    onClicked: {
                        console.log("themesList",index)
                        if(themesList.currentIndex!=index)
                        {
//                            themesList.currentIndex=index
                            currentTheme=index
                            backTopPage()
                        }
                    }
                }

            }
        }
    }
}
