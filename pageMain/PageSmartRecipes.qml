import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    property string name: "PageSmartRecipes"
    Component.onDestruction: {
        smartRecipesIndex=0
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("智慧菜谱")
    }
    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:2
    }

    TabBar {
        id:tabBar
        contentWidth:200*2
        contentHeight:40
        anchors.top: topBar.bottom
        anchors.topMargin: -35
        anchors.horizontalCenter: parent.horizontalCenter

        background:Rectangle {
            color: "#4E4E4E"
            radius: 4
            border.width: 2
        }

        Repeater {
            model: ["蒸烤菜(左腔)", "右灶菜"]
            TabButton {
                width: 200
                height: parent.height
                background:Rectangle {
                    color: index==tabBar.currentIndex?"#3E2B21":"transparent"
                    radius: 4
                    //border.color: index==tabBar.currentIndex?themesTextColor:"transparent"
                    //border.width: 2
                }
                Image {
                    asynchronous:true
                    smooth:false
                    opacity: 0.6
                    visible: index==tabBar.currentIndex
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    source: themesPicturesPath+"navigation_bar_text_background.png"
                }
                Text{
                    anchors.centerIn: parent
                    text:modelData
                    color: index==tabBar.currentIndex?themesTextColor:"#ffffff"
                    font.pixelSize: 24
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }
            }
        }
    }
    StackLayout {
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        currentIndex: tabBar.currentIndex
        PageLeftRecipes{

        }
        PageRightRecipes{

        }
        PageRightRecipes{

        }
        onCurrentIndexChanged: {
            smartRecipesIndex=currentIndex
        }
    }
}
