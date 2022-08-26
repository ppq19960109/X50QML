import QtQuick 2.12
import QtQuick.Controls 2.5
Rectangle {
    color: "#000"
    MouseArea{
        anchors.fill: parent
    }
    Text{
        color:"#fff"
        font.pixelSize: 60
        anchors.top: parent.top
        anchors.topMargin: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 30
        text: "|"
    }

    Text{
        id:time
        color:"#fff"
        font.pixelSize: 150
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 200
        text: gTimeText

    }

    Text{
        color:"#fff"
        font.pixelSize: 38
        anchors.top: parent.top
        anchors.topMargin: 250
        anchors.horizontalCenter: time.horizontalCenter
        text: gMonth+"月"+gDate+"日 周"+weeksEnum[gDay]+" "+gHoliday
    }

    Image {
        id:icon_weather
        anchors.top:parent.top
        anchors.topMargin: 110
        anchors.left: parent.left
        anchors.leftMargin: 715
        source: themesPicturesPath+"weather/"+gWeatherId+".png"
    }

    Text{
        color:"#fff"
        font.pixelSize: 55
        anchors.top: parent.top
        anchors.topMargin: 230
        anchors.horizontalCenter: icon_weather.horizontalCenter
        text:weatherEnum[gWeatherId]
    }

    Text{
        id:temp
        color:"#fff"
        font.pixelSize: 150
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 845
        text: gTemp
    }
    Text{
        color:"#fff"
        font.pixelSize: 45
        anchors.top: parent.top
        anchors.topMargin: 105
        anchors.left: parent.left
        anchors.leftMargin: 1030
        text: "℃"
    }
    Text{
        color:"#fff"
        font.pixelSize: 55
        anchors.top: parent.top
        anchors.topMargin: 240
        anchors.horizontalCenter: temp.horizontalCenter
        text: gLowTemp+"/"+gHighTemp
    }
}
