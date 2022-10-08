import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "qrc:/SendFunc.js" as SendFunc
Item {
    property string name: "pageTestFront"
    Component.onCompleted: {
        productionTestStatus=1
        systemPower(1)
        SendFunc.setSysPower(1)
        SendFunc.setBuzControl(buzControlEnum.SHORT)
        SendFunc.setProductionTestStatus(1)
    }
    Component.onDestruction: {
        productionTestStatus=0
        systemPower(QmlDevState.state.SysPower)
        loaderErrorCodeShow(QmlDevState.state.ErrorCodeShow)
        SendFunc.setProductionTestStatus(0)
    }
    StackView.onActivated:{
        var errorcode=QmlDevState.state.ErrorCodeShow
        if(errorcode===9||errorcode===15)
            loaderErrorHide()
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
            anchors.top: parent.top
            rows: 2
            columns: 2
            rowSpacing: 20
            columnSpacing: 50

            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:120
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
                Layout.preferredWidth: 300
                Layout.preferredHeight:120
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
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:120
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"负载功率检测"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    wrapMode: Text.WordWrap
                }

                onClicked: {
                    load_page("pageLoadPower")
                }
            }
            Button{
                Layout.preferredWidth: 300
                Layout.preferredHeight:120
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"输入输出检测"
                    color:"#FFF"
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    wrapMode: Text.WordWrap
                }

                onClicked: {
                    load_page("pagePowerBoard")
                }
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
                color:"#FFF"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                backTopPage()
            }
        }
    }
}
