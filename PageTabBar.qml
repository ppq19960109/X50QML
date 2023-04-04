import QtQuick 2.12
import QtQuick.Controls 2.5

Item{
    property bool completed_state: false
    property alias currentIndex: tabBar.currentIndex
    property alias source: bg.source
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
        contentWidth:parent.width-17
        contentHeight:parent.height
        anchors.centerIn: parent
        //anchors.leftMargin: 4
        background:null
        Repeater {
            model: ["AI 烹饪", "蒸烤箱", "智慧菜谱"]
            TabButton {
                width: {
                    if(index==0)
                        170
                    else if(index==1)
                        250
                    else
                        160
                }
                height: parent.height
                background:null
//                background:Rectangle{
//                    color: "transparent"
//                    border.color: "#fff"
//                }

                Item{
                    anchors.fill: parent
                    visible: index==1
                    PageRotationImg {
                        id:left_StOvState
                        asynchronous:true
                        smooth:true
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -95
                        anchors.verticalCenterOffset: 6
                        source: themesPicturesPath+"samll_rotation.png"
                        duration:12000
                        visible: lStOvState===workStateEnum.WORKSTATE_PREHEAT|| lStOvState===workStateEnum.WORKSTATE_RUN|| lStOvState===workStateEnum.WORKSTATE_PAUSE|| lStOvState===workStateEnum.WORKSTATE_PAUSE_PREHEAT
                        running: visible && (lStOvState===workStateEnum.WORKSTATE_PREHEAT || lStOvState===workStateEnum.WORKSTATE_RUN)
                    }
                    Text{
                        visible: left_StOvState.visible
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -60
                        anchors.verticalCenterOffset: 6
                        text:lStOvSetTimerLeft
                        color:"#fff"
                        font.pixelSize: 24
                    }
                    PageRotationImg {
                        id:right_StOvState
                        asynchronous:true
                        smooth:true
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 60
                        anchors.verticalCenterOffset: 6
                        source: themesPicturesPath+"samll_rotation.png"
                        duration:12000
                        visible: rStOvState===workStateEnum.WORKSTATE_PREHEAT|| rStOvState===workStateEnum.WORKSTATE_RUN|| rStOvState===workStateEnum.WORKSTATE_PAUSE|| rStOvState===workStateEnum.WORKSTATE_PAUSE_PREHEAT
                        running: visible && (rStOvState===workStateEnum.WORKSTATE_PREHEAT || rStOvState===workStateEnum.WORKSTATE_RUN)
                    }
                    Text{
                        visible: right_StOvState.visible
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 95
                        anchors.verticalCenterOffset: 6
                        text:rStOvSetTimerLeft
                        color:"#fff"
                        font.pixelSize: 24
                    }
                }

                Image {
                    asynchronous:true
                    smooth:false
                    visible: index==tabBar.currentIndex
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    source: themesPicturesPath+"navigation_bar_text_background.png"
                }
                Text{
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 5
                    text:modelData
                    color:index==tabBar.currentIndex?"#EF832B":"#fff"
                    font.pixelSize: 24
                    //horizontalAlignment:Text.AlignHCenter
                    //verticalAlignment:Text.AlignVCenter
                }
            }
        }
        onCurrentIndexChanged: {
            if(completed_state==false)
                return

            switch (currentIndex){
            case 0:
                replace_page(pageAICook)
                break
            case 1:
                if(lStOvState!==workStateEnum.WORKSTATE_STOP || rStOvState!==workStateEnum.WORKSTATE_STOP)
                    push_page(pageSteaming)
                else
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
