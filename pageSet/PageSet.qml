import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {

    Component.onCompleted: {


    }
    Image {
        anchors.fill: parent
        source: "/x50/main/背景.png"
    }
    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:80
        name:qsTr("设置")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"transparent"

        GridLayout{
            width:parent.width-80
            height: parent.height-90
            anchors.centerIn: parent
            rows: 2
            columns: 3
            rowSpacing: 30
            columnSpacing: 20

            Button{
                Layout.preferredWidth: 210
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"网络"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageWifi")
                }
            }
            Button{
                Layout.preferredWidth: 210
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"本机设置"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageLocalSettings")
                }
            }
            Button{
                Layout.preferredWidth: 250
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"恢复出厂设置"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageReset")
                }
            }
            Button{
                Layout.preferredWidth: 210
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"系统更新"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageSystemUpdate")
                }
            }
            Button{
                Layout.preferredWidth: 210
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"关于本机"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageAboutMachine")
                }
            }
            Button{
                Layout.preferredWidth: 250
                Layout.preferredHeight:140
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"transparent"
                    border.color: "#97A3A1"
                }
                Text{
                    text:"售后指南"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageAfterGuide")
                }
            }
        }
    }
}

