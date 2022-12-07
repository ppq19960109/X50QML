import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    //定义全局分类菜谱
    readonly property var  menuId: ['快捷模式','智慧菜谱','预制菜']

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("右腔料理")
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
        Item{
            id:leftContent
            width:195
            height:parent.height

            ListView{
                id:menuList
                model:menuId
                width:parent.width
                height:100*3
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                cacheBuffer:2
                orientation:ListView.Vertical
                currentIndex:0
                highlightMoveDuration:0
                highlightMoveVelocity:-1
                boundsBehavior:Flickable.StopAtBounds
                snapMode: ListView.SnapToItem
                delegate: Item{
                    height: 100
                    width:parent.width

                    Button {
                        width:parent.width
                        height:parent.height-2
                        anchors.top: parent.top
                        background: Rectangle{
                            color:menuList.currentIndex===index?"#131313":"transparent"
                        }

                        Text{
                            text: modelData
                            font.pixelSize: menuList.currentIndex===index?40:35
                            anchors.centerIn: parent
                            color:menuList.currentIndex===index?themesTextColor:themesTextColor2
                        }
                        onClicked: {
                            if(menuList.currentIndex!=index)
                            {
                                menuList.currentIndex=index
                            }
                        }
                    }
                    Rectangle{
                        anchors.bottom: parent.bottom
                        width:parent.width
                        height: 2
                        color:"#fff"
                        opacity: 0.1
                    }
                }
            }
        }
        StackLayout {
            height:parent.height
            anchors.left: leftContent.right
            anchors.right: parent.right
            currentIndex: menuList.currentIndex
            PageShortcutMode{}
            PageRecipes{
                Component.onCompleted: {
                    model=QmlDevState.getPanguRecipe(0);
                }
            }
            PageRecipes{
                Component.onCompleted: {
                    model=QmlDevState.getPanguRecipe(1);
                }
            }
        }
    }

}
