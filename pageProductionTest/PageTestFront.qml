import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {
    Component.onCompleted: {
        stackView.width=1280
        productionTestStatus=1
        SendFunc.setBuzControl(buzControlEnum.SHORT)
        SendFunc.setProductionTestStatus(1)
    }
    Component.onDestruction: {
        productionTestStatus=0
        SendFunc.setProductionTestStatus(0)
        stackView.width=1160
    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("整机产测模式")
        customClose:true
        onClose:{
            backTopPage()
        }
    }
    Item{
        width: parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        Grid{
            width:300*2+200
            height: 120*2+50
            anchors.centerIn: parent
            rows: 2
            columns: 2
            rowSpacing: 50
            columnSpacing: 200

            Button{
                width: 300
                height:120
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
                    push_page(pageScreenTest)
                }
            }
            Button{
                width: 300
                height:120
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
                    push_page(pageIntelligentDetection)
                }
            }
            Button{
                width: 300
                height:120
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"输入输出检测"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                }

                onClicked: {
                    push_page(pagePowerBoard)
                }
            }
            Button{
                width: 300
                height:120
                background:Rectangle{
                    radius: 16
                    color:testMode?themesTextColor:themesTextColor2
                }
                Text{
                    text:"测试模式"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    wrapMode: Text.WrapAnywhere
                    anchors.verticalCenterOffset: -20
                }
                Text{
                    text:testMode?"开":"关"
                    color:"#FFF"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 30
                }
                onClicked: {
                    testMode=!testMode
                }
            }
        }
    }
}
