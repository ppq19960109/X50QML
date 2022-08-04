import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property bool customClose:false
    property alias name: name.text
    property alias centerText:centerText.text
    property alias leftBtnText:leftBtnText.text
    property alias rightBtnText:rightBtnText.text

    signal leftClick()
    signal rightClick()
    signal close()
    implicitWidth: parent.width
    implicitHeight:55
    color: "#141414"
    Rectangle{
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: "#3A3A3A"
    }

    ToolBar {
        implicitWidth: parent.width
        implicitHeight:parent.height

        background:null
        //back图标
        ToolButton {
            id:backBtn
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: Image{
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"back_button_background.png"
            }
            onClicked: {
                if(customClose==true)
                    close()
                else
                    backPrePage()
            }
        }

        Text{
            id:name
            anchors.left:backBtn.right
            anchors.verticalCenter: parent.verticalCenter
            color:themesTextColor2
            font.pixelSize: 24
            //textFormat: Text.AutoText
            //textFormat: Text.RichText
        }
        Text{
            id:centerText
            width: parent.width/2
            visible: centerText.text!=""
            anchors.centerIn: parent
            color:themesTextColor2
            font.pixelSize: 30
            elide: Text.ElideRight
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }
        //left
        ToolButton{
            id:leftBtn
            width:120
            height:parent.height
            visible: leftBtnText.text!=""
            enabled: visible
            anchors.right:rightBtn.left
            anchors.rightMargin: 30
            anchors.verticalCenter: parent.verticalCenter

            background:Rectangle{
                width:105
                height:50
                anchors.centerIn: parent
                color:"transparent"
                border.color:themesTextColor2
                radius: 8

                Text{
                    id:leftBtnText
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.centerIn:parent
                }
            }
            onClicked: {
                leftClick()
            }
        }
        //right
        ToolButton{
            id:rightBtn
            width:150
            height:parent.height
            visible: rightBtnText.text!=""
            anchors.right:parent.right
            anchors.verticalCenter: parent.verticalCenter

            background:Rectangle{
                width:105
                height:50
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                color:"transparent"
                border.color:themesTextColor2
                radius: 8

                Text{
                    id:rightBtnText
                    color:themesTextColor2
                    font.pixelSize: 30
                    anchors.centerIn:parent
                }
            }
            onClicked: {
                rightClick()
            }
        }
    }
}
