import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
Item {

    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage()
            }
        }

        Text{
            id:pageName
            width:100
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("设置")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        color:"#000"

        GridLayout{
            width:parent.width-60
            height: parent.height-50
            anchors.centerIn: parent
            rows: 2
            columns: 3
            rowSpacing: 10
            columnSpacing: 10

            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"网络"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageWifi")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"本机设置"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageLocalSettings")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"恢复出厂设置"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageReset")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"系统更新"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageSystemUpdate")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"关于本机"
                    color:"#000"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageAboutMachine")
                }
            }
            Button{
                Layout.preferredWidth: 220
                Layout.preferredHeight:160
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 10
                    color:"#fff"
                }
                Text{
                    text:"售后指南"
                    color:"#000"
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

