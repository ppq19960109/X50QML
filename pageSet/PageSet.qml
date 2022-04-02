import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {

    Component.onCompleted: {


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
            width:parent.width-54
            height: parent.height-64
            anchors.centerIn: parent
            rows: 2
            columns: 3
            rowSpacing: 4
            columnSpacing: 0

            Button{
                Layout.preferredWidth: 236
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370.png"
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
                Layout.preferredWidth: 236
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370.png"
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
                Layout.preferredWidth: 280
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370(1).png"
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
                Layout.preferredWidth: 236
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370.png"
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
                Layout.preferredWidth: 236
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370.png"
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
                Layout.preferredWidth: 280
                Layout.preferredHeight:166
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    anchors.fill: parent
                    source:"qrc:/x50/set/圆角矩形 1370(1).png"
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

