import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
Item {
    property string name: "PageSteamOven"
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
                Rectangle
                {
                    id:workStatus
                    visible: {
                        if(index==0)
                        {
                            return lStOvState!==workStateEnum.WORKSTATE_STOP
                        }
                        else
                        {
                            return rStOvState!==workStateEnum.WORKSTATE_STOP
                        }
                    }
                    width: 130
                    height: 130
                    anchors.top: parent.top
                    anchors.topMargin: 115
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#000"
                    opacity: 0.5
                    radius: 65
                }
                Image {
                    visible: workStatus.visible
                    anchors.centerIn: workStatus
                    asynchronous:true
//                    smooth:false
                    source: themesPicturesPath+"icon_runing.png"
                    RotationAnimation on rotation {
                        from: 0
                        to: 360
                        duration: 8000 //旋转速度，默认250
                        loops: Animation.Infinite //一直旋转
                        running:workStatus.visible
                    }
                }
                Text{
                    visible: workStatus.visible
                    text:"工作中\n..."
                    color:themesTextColor
                    font.pixelSize: 26
                    anchors.centerIn: workStatus
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment:Text.AlignVCenter
                    lineHeight:0.6
                }
                onClicked: {

                    if(index==0)
                    {
                        if(lStOvState!==workStateEnum.WORKSTATE_STOP)
                            push_page(pageSteaming)
                        else
                            push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.LEFT})
                    }
                    else
                    {
                        if(rStOvState!==workStateEnum.WORKSTATE_STOP)
                            push_page(pageSteaming)
                        else
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
                            if(rStOvState!==workStateEnum.WORKSTATE_STOP)
                                push_page(pageSteaming)
                            else
                                push_page(pageSteamOvenConfig,{cookWorkPos:cookWorkPosEnum.ASSIST})
                        }
                        else
                        {
                            if(lStOvState!==workStateEnum.WORKSTATE_STOP)
                                push_page(pageSteaming)
                            else
                                push_page(pageMultistage)
                        }
                    }
                }
            }
        }
    }

}
