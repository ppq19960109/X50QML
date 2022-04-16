import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property alias name: name.text
    property alias centerText:centerText.text
    property alias leftBtnText:leftBtnText.text
    property alias leftBtnOpacity:leftBtn.opacity
    property alias rightBtnText:rightBtnText.text
    property alias rightBtnOpacity:rightBtn.opacity
    signal leftClick()
    signal rightClick()
    signal close()
    implicitWidth: parent.width
    implicitHeight:80
    ToolBar {

        width: parent.width
        implicitHeight:80

        background:Image {
            asynchronous:true
            source: themesImagesPath+"homebar-background.png"
        }
        //back图标
        TabButton {
            id:backBtn
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: Image{
                asynchronous:true
                anchors.centerIn: parent
                source: themesImagesPath+"back-button-background.png"
            }
            onClicked: {
                close()
            }
        }

        Text{
            id:name
            //        width:80
            anchors.left:backBtn.right
            anchors.verticalCenter: parent.verticalCenter
            color:themesTextColor2
            font.pixelSize: 35
            //        textFormat: Text.AutoText
            //        horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter

        }
        Text{
            id:centerText
            visible: centerText.text!=""
            anchors.centerIn: parent
            color:themesTextColor2
            font.pixelSize: 35
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }
        //left
        TabButton{
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
                    //                horizontalAlignment:Text.AlignHCenter
                    //                verticalAlignment:Text.AlignVCenter
                }
            }

            onClicked: {
                leftClick()
            }
        }
        //right
        TabButton{
            id:rightBtn
            width:150
            height:parent.height
            visible: rightBtnText.text!=""
            anchors.right:parent.right
            //        anchors.rightMargin: 40
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
                    //                horizontalAlignment:Text.AlignHCenter
                    //                verticalAlignment:Text.AlignVCenter
                }
            }

            onClicked: {
                rightClick()
            }
        }
    }
}
