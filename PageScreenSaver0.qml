import QtQuick 2.12
import QtQuick.Controls 2.5
Item {

    MouseArea{
        anchors.fill: parent
    }
    Image {
        source: themesPicturesPath+"screen_saver0.png"
    }
    Text{
        id:time
        color:"#fff"
        font.pixelSize: 120
        anchors.top: parent.top
        anchors.topMargin: 95
        anchors.left: parent.left
        anchors.leftMargin: 220
        text: gTimeText
    }
    Text{
        color:"#fff"
        font.pixelSize: 32
        anchors.top: parent.top
        anchors.topMargin: 250
        anchors.horizontalCenter: time.horizontalCenter
        text: gMonth+"月"+gDate+"日 周"+weeksEnum[gDay]+" "+(wifiConnected?gHoliday:"")
    }
    Text{
        color:"#fff"
        opacity: 0.5
        font.pixelSize: 40
        anchors.centerIn: parent
        text: "|"
    }
    Item {
        anchors.fill: parent
        visible: wifiConnected
        Image {
            id:icon_weather
            anchors.top:parent.top
            anchors.topMargin: 110
            anchors.left: parent.left
            anchors.leftMargin: 740
            source: themesPicturesPath+"weather/"+gWeatherId+".png"
        }

        Text{
            id:weather_text
            color:"#fff"
            font.pixelSize: 32
            anchors.top: parent.top
            anchors.topMargin: 255
            anchors.horizontalCenter: icon_weather.horizontalCenter
            text:weatherEnum[gWeatherId]
        }

        Text{
            id:temp
            color:"#fff"
            font.pixelSize: 120
            anchors.verticalCenter: icon_weather.verticalCenter
            anchors.left: icon_weather.right
            anchors.leftMargin: 40
            text: gTemp
        }
        Text{
            color:"#fff"
            font.pixelSize: 35
            anchors.top: temp.top
            anchors.topMargin: 20
            anchors.left: temp.right
            anchors.leftMargin: 15
            text: "℃"
        }
        Text{
            color:"#fff"
            font.pixelSize: 32
            anchors.verticalCenter: weather_text.verticalCenter
            anchors.horizontalCenter: temp.horizontalCenter
            text: gLowTemp+"/"+gHighTemp
        }
    }
}
