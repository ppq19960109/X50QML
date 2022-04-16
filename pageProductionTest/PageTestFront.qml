import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    property string name: "PageTestFront"
    Component.onCompleted: {

    }

    Item{
        id:topBar
        width:parent.width
        height:80
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:themesTextColor
            font.pixelSize: 40
            font.bold : true
            text: qsTr("整机产测模式")
        }
    }
    Item{
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom

        GridLayout{
            width:parent.width
            height: parent.height-100
            rows: 1
            columns: 2
            rowSpacing: 0
            columnSpacing: 0

            Button{
                Layout.preferredWidth: 250
                Layout.preferredHeight:250
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"屏幕检测"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenTest")
                }
            }
            Button{
                Layout.preferredWidth: 250
                Layout.preferredHeight:250
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"智能模块检测"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageIntelligentDetection")
                }
            }
        }
        Button{
            width:100+50
            height:50+50
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:100
                height:50
                anchors.centerIn: parent
                radius: 8
                color:themesTextColor2
            }
            Text{
                text:"退出"
                color:"#FFF"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                 backPrePage()
            }
        }
    }
}
