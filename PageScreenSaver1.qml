import QtQuick 2.12
import QtQuick.Controls 2.5
Item {
    property int index:systemSettings.screenSaverIndex
    MouseArea{
        anchors.fill: parent
    }
    Image {
        source: themesPicturesPath+"screen_saver"+index+".png"
    }

    Text{
        id:time
        color:index==2?"#000":"#fff"
        font.pixelSize: 150
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: index==1?0:-350
        text: gTimeText

    }

    Text{
        color:index==2?"#000":"#fff"
        font.pixelSize: 38
        anchors.top: parent.top
        anchors.topMargin: 250
        anchors.horizontalCenter: time.horizontalCenter
        text: {
            if(index==2)
                return gYear+"年"+gMonth+"月"+gDate+"日 星期"+weeksEnum[gDay]
            else
                return gMonth+"月"+gDate+"日 周"+weeksEnum[gDay]+" "+(wifiConnected?gHoliday:"")
        }
    }
}