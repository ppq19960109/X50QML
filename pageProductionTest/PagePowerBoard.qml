import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "qrc:/SendFunc.js" as SendFunc
Item {
    Component.onCompleted: {
        productionTestStatus=2
        var errorcode=QmlDevState.state.ErrorCodeShow
        if(errorcode!=15)
            loaderErrorCodeShow(errorcode)
    }
    Component.onDestruction: {
        productionTestStatus=1
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
            text: qsTr("电源板输入输出检测")
        }
        Button{
            width:100
            height:50
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom
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

    Item{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        RowLayout{
            anchors.fill: parent
            Button{
                Layout.preferredWidth: 200
                Layout.preferredHeight:100
                Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
                background:Rectangle{
                    radius: 16
                    color:themesTextColor2
                }
                Text{
                    text:"输入检测"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pagePowerInput")
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
                    text:"输出检测"
                    color:"#FFF"
                    font.pixelSize: 35
                    anchors.centerIn: parent
                }
                onClicked: {
                    load_page("pagePowerOut")
                }
            }
        }
    }
}
