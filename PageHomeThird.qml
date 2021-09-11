import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1

Item {
    width:parent.width
    height: parent.height
    //        anchors.fill: parent
    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20

        Button{
            id:timer
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 235
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter

            background:Rectangle{
                color:"transparent"
                Image{
                    source: "images/main_menu/beijing.png"
                }
            }

            Image{
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                anchors.topMargin:40
                source: "images/main_menu/dingshiqi.png"
                visible:true
            }
            Text{
                text:"定时器"
                color:"#fff"
                font.pixelSize: fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 5
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                //         load_page("pageTimer",JSON.stringify({deviceType:"定时器"}))
            }
        }

        Button{
            id:weather
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 235
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter
            background:Rectangle{
                color:"transparent"
                Image{
                    source: "images/main_menu/beijing.png"
                }
            }
            Image{
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                anchors.topMargin:40
                source: "images/main_menu/tianqi.png"
            }
            Text{
                text:"天气"
                color:"#fff"
                font.pixelSize: fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 5
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                //              load_page("pageWeather",JSON.stringify({deviceType:"天气"}))
            }
        }

        Button{
            id:messageCenter
            //            width: 235
            //            height:parent.height
            Layout.preferredWidth: 235
            Layout.preferredHeight:parent.height
            Layout.alignment: Qt.AlignHCenter
            background:Rectangle{
                color:"transparent"
                Image{
                    source: "images/main_menu/beijing.png"
                }
            }
            Image{
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.top:parent.top
                anchors.topMargin:40
                source: "images/main_menu/xiaoxi.png"
            }
            Text{
                text:"消息中心"
                color:"#fff"
                font.pixelSize: fontSize
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 5
                anchors.horizontalCenter:parent.horizontalCenter
            }

            onClicked: {
                //           load_page("pageMessageCenter",JSON.stringify({deviceType:"消息中心"}))
            }
        }
    }
}
