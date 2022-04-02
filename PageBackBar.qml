import QtQuick 2.7
import QtQuick.Controls 2.2

ToolBar {
    property alias name: name.text
    property alias centerText:centerText.text
    property alias leftBtnText:leftBtnText.text
    property alias leftBtnOpacity:leftBtn.opacity
    property alias rightBtnText:rightBtnText.text
    property alias rightBtnOpacity:rightBtn.opacity
    signal leftClick()
    signal rightClick()
    signal close()

    background:Rectangle{
        color:"#000"
        opacity: 0.15
    }
    //back图标
    TabButton {
        id:backBtn
        width:100
        height:parent.height
        anchors.left:parent.left
        anchors.verticalCenter: parent.verticalCenter
        Image{
            asynchronous:true
            anchors.centerIn: parent
            source: "qrc:/x50/icon/icon_wife_nor.png"
        }
        background: Rectangle {
            opacity: 0
        }
        onClicked: {
            close()
        }
    }

    Text{
        id:name
        width:80
        anchors.left:backBtn.right
        anchors.verticalCenter: parent.verticalCenter
        color:"#FFF"
        font.pixelSize: 35
        //        textFormat: Text.AutoText
        //        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter

    }
    Text{
        id:centerText
        visible: centerText.text!=""
        anchors.centerIn: parent
        color:"#FFF"
        font.pixelSize: 35
        horizontalAlignment:Text.AlignHCenter
        verticalAlignment:Text.AlignVCenter
    }
    //left
    TabButton{
        id:leftBtn
        width:140
        height:parent.height
        visible: leftBtnText.text!=""
        enabled: visible
        anchors.right:rightBtn.left
//        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        opacity: 1
        background:Rectangle{
            width:110
            height:50
            anchors.centerIn: parent
            color:"transparent"
            border.color:"#00E6B6"
            radius: 8
        }
        Text{
            id:leftBtnText
            color:"#00E6B6"
            font.pixelSize: 30
            anchors.centerIn:parent
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }
        onClicked: {
            leftClick()
        }
    }
    //right
    TabButton{
        id:rightBtn
        width:180
        height:parent.height
        visible: rightBtnText.text!=""
        anchors.right:parent.right
//        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        opacity: 1
        background:Rectangle{
            width:110
            height:50
            anchors.centerIn: parent
            color:"transparent"
            border.color:"#00E6B6"
            radius: 8
        }
        Text{
            id:rightBtnText
            color:"#00E6B6"
            font.pixelSize: 30
            anchors.centerIn:parent
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment:Text.AlignVCenter
        }
        onClicked: {
            rightClick()
        }
    }
}
