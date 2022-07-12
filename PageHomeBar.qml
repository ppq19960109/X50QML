import QtQuick 2.7
import QtQuick.Controls 2.2

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
            model: [(wifiConnected==true?"icon_wifi_connected.png":"icon_wifi_disconnect.png"),"icon_set.png", "icon_alarm.png", "icon_standby.png"]
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
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+modelData
                }
                onClicked: {
                    console.log("onClicked index",index)

                    switch (index){
                    case 0:
                        push_page(pageWifi)
                        break
                    case 1:
                        push_page(pageSet)
                        break
                    case 2:
                        break
                    case 3:
                        break
                    }
                }
            }
        }
    }
}
