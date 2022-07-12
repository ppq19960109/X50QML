import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {

    Component.onCompleted: {


    }

    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("设置")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onClose:{
            backPrePage()
        }
    }

    //内容
    Item{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        GridLayout{

            anchors.centerIn: parent
            rows: 2
            columns: 3
            rowSpacing: 30
            columnSpacing: 20

            Button{
                Layout.preferredWidth: 212
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button1-background.png"
                }
                Text{
                    text:"网络"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageWifi")
                }
            }
            Button{
                Layout.preferredWidth: 212
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button1-background.png"
                }
                Text{
                    text:"本机设置"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageLocalSettings")
                }
            }
            Button{
                Layout.preferredWidth: 256
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button2-background.png"
                }
                Text{
                    text:"恢复出厂设置"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageReset")
                }
            }
            Button{
                Layout.preferredWidth: 212
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button1-background.png"
                }
                Text{
                    text:"系统更新"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageSystemUpdate")
                }
            }
            Button{
                Layout.preferredWidth: 212
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button1-background.png"
                }
                Text{
                    text:"关于本机"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageAboutMachine")
                }
            }
            Button{
                Layout.preferredWidth: 256
                Layout.preferredHeight:142
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Image{
                    asynchronous:true
                    smooth:false
                    anchors.fill: parent
                    source:themesImagesPath+"statusset-button2-background.png"
                }
                Text{
                    text:"售后指南"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    push_page("pageAfterGuide")
                }
            }
        }
    }
}

