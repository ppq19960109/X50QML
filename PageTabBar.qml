import QtQuick 2.7
import QtQuick.Controls 2.2

Item{
    property bool completed_state: false
    property alias currentIndex: tabBar.currentIndex
    width: bg.width
    height: bg.height

    Image {
        id:bg
        asynchronous:true
        smooth:false
        source: themesPicturesPath+"navigation_bar.png"
    }
    TabBar {
        id:tabBar
        contentWidth:150*3
        contentHeight:parent.height
        anchors.centerIn: parent
        background:null
        Repeater {
            model: ["烟机灶具", "蒸烤箱", "智慧菜谱"]
            TabButton {
                width: 150
                height: parent.height
                background:null
                Image {
                    visible: index==tabBar.currentIndex
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+"navigation_bar_text_background.png"
                }
                Text{
                    anchors.fill: parent
                    text:modelData
                    color:index==tabBar.currentIndex?"#EF832B":"#fff"
                    font.pixelSize: 24
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                }
            }
        }
        onCurrentIndexChanged: {
            if(completed_state==false)
                return
            console.log("onCurrentIndexChanged",currentIndex)
            switch (currentIndex){
            case 0:
                replace_page(pageHood)
                break
            case 1:
                replace_page(pageSteamOven)
                break
            case 2:
                replace_page(pageSmartRecipes)
                break
            }
        }
    }
    Component.onCompleted: {
        console.log("tabbar onCompleted")
        completed_state=true
    }
}
