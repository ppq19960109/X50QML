import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "../"
Item {
    property string name: "PageSet"
    Component.onDestruction: {
        pageSetIndex=0
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("设置")
    }
    Item{
        width: parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        ListView{
            id:menuList
            model:['本机设置','恢复出厂设置','系统更新','关于本机','网络']
            width:206
            anchors.top:parent.top
            anchors.topMargin: 15
            anchors.bottom: parent.bottom
            orientation:ListView.Vertical
            currentIndex:pageSetIndex
            interactive:false
            delegate:Button {
                width:parent.width
                height:62
                background:Image {
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source: menuList.currentIndex===index?(themesPicturesPath+"menulist_item_background.png"):""
                }
                Text{
                    text: modelData
                    font.pixelSize: menuList.currentIndex===index?30:24
                    font.bold: menuList.currentIndex===index
                    anchors.centerIn: parent
                    color:"#fff"
                }
                onClicked: {
                    if(menuList.currentIndex!=index)
                        menuList.currentIndex=index
                }
            }
        }

        StackLayout {
            height:parent.height
            anchors.left:menuList.right
            anchors.right: parent.right
            currentIndex: menuList.currentIndex
            PageLocalSettings {}
            PageReset {}
            PageSystemUpdate {}
            PageAboutMachine {}
            PageWifi {}
        }
    }
}

