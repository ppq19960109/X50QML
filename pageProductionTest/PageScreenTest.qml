import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id:root
    Component.onCompleted: {

    }
    function clickedAgingfunc(status)
    {
        testSettings.productionTestAging=status
    }
    function clickedTouchFunc(status)
    {
        testSettings.productionTestTouch=status
    }
    function clickedLcdFunc(status)
    {
        testSettings.productionTestLcd=status
    }
    function clickedLightFunc(status)
    {
        testSettings.productionTestLight=status
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
            text: qsTr("屏幕检测")
        }
    }
    Item{
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom

        GridLayout{
            width:parent.width
            height: parent.height-100
            anchors.top: parent.top
            rows: 2
            columns: 3
            rowSpacing: 10
            columnSpacing: 10
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"LCD"
                    color:testSettings.productionTestLcd==0?"#FFF":testSettings.productionTestLcd==1?"green":"red"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenLCD",{containerqml:root})
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"触摸"
                    color:testSettings.productionTestTouch==0?"#FFF":testSettings.productionTestTouch==1?"green":"red"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenTouch",{containerqml:root})
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"背光"
                    color:testSettings.productionTestLight==0?"#FFF":testSettings.productionTestLight==1?"green":"red"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pageScreenLight",{containerqml:root})
                }
            }
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
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
                    color:themesTextColor2
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
                    color:themesTextColor2
                }
                Text{
                    text:"老化测试"
                    color:testSettings.productionTestAging==0?"#FFF":testSettings.productionTestAging==1?"green":"red"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }

                onClicked: {
                    load_page("pageAgingTest",{containerqml:root})
                }
            }
        }
        Button{
            width:300+50
            height:50+40
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            background:Rectangle{
                width:300
                height:60
                anchors.centerIn: parent
                radius: 8
                color:themesTextColor2
            }
            Text{
                text:"清除检验记录"
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                testSettings.productionTestLcd=0
                testSettings.productionTestLight=0
                testSettings.productionTestAging=0
                testSettings.productionTestTouch=0
            }
        }
        Button{
            width:100
            height:50
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            background:Rectangle{
                radius: 8
                color:themesTextColor2
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
