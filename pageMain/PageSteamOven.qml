import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {
    Component.onCompleted: {

    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("蒸烤箱")
    }
    PageTabBar{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        currentIndex:1
    }
    Row {
        width: 344*3+26*2
        height: 266
        anchors.top: topBar.bottom
        anchors.topMargin: 17
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 26
        Repeater {
            model: [{"background":"left_steam_oven_background.png","text":"left_steam_oven_text.png"}, {"background":"right_steam_background.png","text":"right_steam_text.png"}]
            Button{
                width: 344
                height:parent.height

                background:Image {
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+modelData.background
                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.top: parent.top
                    anchors.topMargin: 37
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: themesPicturesPath+modelData.text
                }
                onClicked: {
                    if(index==0)
                    {
                        push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.LEFT})
                    }
                    else
                    {
                        push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.RIGHT})
                    }
                }
            }
        }
        Column{
            width: 344
            height:parent.height
            spacing: 6
            Repeater {
                model: [{"background":"assist_cook_background.png","text":"assist_cook_text.png"}, {"background":"multistage_cook_background.png","text":"multistage_cook_text.png"}]
                Button{
                    width: parent.width
                    height:130
                    background:Image {
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+modelData.background
                    }
                    Image {
                        asynchronous:true
                        smooth:false
                        anchors.centerIn: parent
                        source: themesPicturesPath+modelData.text
                    }
                    onClicked: {
                        if(index==0)
                        {
                            push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.ASSIST})
                        }
                        else
                        {
                            push_page(pageMultistage)
                        }
                    }
                }
            }
        }
    }

}
