import QtQuick 2.12
import QtQuick.Controls 2.5

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
    implicitHeight:90
    ToolBar {
        width: parent.width
        implicitHeight:80
        anchors.top: parent.top

        background:Image {
            asynchronous:true
            smooth:false
            source: themesImagesPath+"homebar-background.png"
        }
        //back图标
        ToolButton {
            id:backBtn
            width:90
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter

            background: Image{
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesImagesPath+"back-button-background.png"
            }
            onClicked: {
                close()
            }
        }

        Text{
            id:name
//            width:180
            height: 40
            anchors.left:backBtn.right
            anchors.verticalCenter: parent.verticalCenter
            color:themesTextColor2
            font.pixelSize: 35
            //        textFormat: Text.AutoText
            textFormat: Text.RichText
//            horizontalAlignment:Text.AlignHCenter
//            verticalAlignment:Text.AlignVCenter
        }
        Text{
            id:centerText
            width: parent.width/2
            visible: centerText.text!=""
            anchors.centerIn: parent
            color:themesTextColor2
            font.pixelSize: 35
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
                    //                horizontalAlignment:Text.AlignHCenter
                    //                verticalAlignment:Text.AlignVCenter
                }
            }

            onClicked: {
                leftClick()
            }
        }
        PageGatingBtn{}
        //right
        ToolButton{
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
