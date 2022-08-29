import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "../"
Item {
    id:root
    Component.onCompleted: {

    }
    function clickedAgingfunc(status)
    {
        console.log("clickedAgingfunc:"+status);
        testSettings.productionTestAging=status
    }
    function clickedTouchFunc(status)
    {
        console.log("clickedTouchFunc:"+status);
        testSettings.productionTestTouch=status
    }
    function clickedLcdFunc(status)
    {
        console.log("clickedLcdFunc:"+status);
        testSettings.productionTestLcd=status
    }
    function clickedLightFunc(status)
    {
        console.log("clickedLightFunc:"+status);
        testSettings.productionTestLight=status
    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("屏幕检测")

        Button{
            width:250
            height:50
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            background:Rectangle{
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
    }
    Item{
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom

        Grid{
            width:200*3+100*2
            height: 100*2+50
            anchors.centerIn: parent
            rows: 2
            columns: 3
            rowSpacing: 50
            columnSpacing: 100
            Button{
                width: 200
                height:100
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
                    push_page(pageScreenLCD,{containerqml:root})
                }
            }
            Button{
                width: 200
                height:100
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
                    push_page(pageScreenTouch,{containerqml:root})
                }
            }
            Button{
                width: 200
                height:100
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
                    push_page(pageScreenLight,{containerqml:root})
                }
            }
            Button{
                width: 200
                height:100
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
                    push_page(pageScreenLine)
                }
            }
            Button{
                width: 200
                height:100
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
                    push_page(pageScreenClick)
                }
            }
            Button{
                width: 200
                height:100
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
                    push_page(pageAgingTest,{containerqml:root})
                }
            }
        }
    }
}
