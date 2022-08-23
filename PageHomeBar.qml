import QtQuick 2.12
import QtQuick.Controls 2.5

ToolBar {
    background: null
    Text {
        id: clock
        width: parent.width
        height: 55
        anchors.top: parent.top
        text: qsTr("12:44")
        font.pixelSize: 30
        color:themesTextColor2
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter
    }
    Image{
        asynchronous:true
        smooth:false
        anchors.left: parent.left
        source: themesPicturesPath+"icon_newline2.png"
    }
    Column {
        width: parent.width
        anchors.top: clock.bottom
        anchors.bottom:parent.bottom
        spacing: 0
        Repeater {
            model: [(wifiConnected==true?"icon_wifi_connected.png":"icon_wifi_disconnect.png"),"icon_set.png", "icon_alarm.png",(stackView.depth>1?"icon_standby.png":"icon_sleep.png") ]
            ToolButton {
                width: parent.width
                height:86
                background: null
                Image{
                    asynchronous:true
                    smooth:false
                    anchors.top: parent.top
                    source: themesPicturesPath+"icon_newline.png"
                }
                Image{
                    visible: index!=2 || (index==2 && gTimerLeft==0)
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+modelData
                }
                Text{
                    visible: index==2 && gTimerLeft>0
                    text:gTimerLeftText
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                }
                onClicked: {
                    console.log("onClicked index",index)

                    switch (index){
                    case 0:
                        if(isExistView("PageSet")==null)
                            push_page(pageSet,{pageSetIndex:4})
                        break
                    case 1:
                        if(isExistView("PageSet")==null)
                            push_page(pageSet)
                        break
                    case 2:
                        loaderManual.sourceComponent = pageTimer
                        break
                    case 3:
                        if(stackView.depth>1)
                            backTopPage()
                        else
                            screenSleep()
                        break
                    }
                }
            }
        }
    }
}
