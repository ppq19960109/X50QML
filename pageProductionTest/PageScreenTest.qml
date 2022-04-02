import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    id:root
    property string name: "PageTestFront"
    color: "#000"
    Component.onCompleted: {

    }
    function clickedfunc(status)
    {
        console.log("clickedfunc:"+status);
        systemSettings.productionTestAging=status
    }
    Rectangle{
        id:topBar
        width:parent.width
        height:60
        anchors.top: parent.top
        color:"transparent"
        Text {
            anchors.centerIn: parent
            color:"green"
            font.pixelSize: 40
            font.bold : true
            text: qsTr("屏幕检测")
        }
    }
    Rectangle{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        color:"transparent"

        GridLayout{
            width:parent.width
            height: parent.height-80
            anchors.top: parent.top
            rows: 2
            columns: 3
            rowSpacing: 0
            columnSpacing: 20
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"LCD"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenLCD")
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"触摸"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenTouch")
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"背光"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenLight")
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"划线耐久"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenLine")
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"点击耐久"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageScreenClick")
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:"blue"
                }
                Text{
                    text:"老化测试"
                    color:systemSettings.productionTestAging==0?"#FFF":aging_status==1?"lime":"red"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageAgingTest",{containerqml:root})
                }
            }
        }
        Button{
            width:100+40
            height:50+30
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:100
                height:50
                anchors.centerIn: parent
                radius: 8
                color:"green"
            }
            Text{
                text:"退出"
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                backPrePage()
            }
        }
    }
}
