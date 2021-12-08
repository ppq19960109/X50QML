import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property alias closeVisible: close.visible

    property int modeIndex
    property alias tempIndex: tempText.text
    property alias timeIndex: timeText.text

    signal close()
    signal confirm()

    implicitWidth: parent.width
    implicitHeight: 100

    Button {
        id:close
        width:50
        height:parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        visible:true

        background: Rectangle{
            color:"transparent"
            Image {
                anchors.centerIn: parent
                source: "/images/guanbi.png"
            }
        }
        onClicked: {
            close()
        }
    }
    Button {
        height: parent.height
        anchors.left: parent.left
        anchors.right: close.left
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle{
            color:"transparent"
        }
        Text {
            id: indexText
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            color:"#9AABC2"
            font.pixelSize: 40
            text:index+1
        }

        Text{
            id:modeText
            width: 160
            anchors.left: indexText.right
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter

            text: leftWorkModeFun(modeIndex)
            color: "#ECF4FC"
            font.pixelSize: 40
        }

        Text{
            id:tempText
            width: 160
            anchors.left: modeText.right
            anchors.leftMargin:50
            anchors.verticalCenter: parent.verticalCenter
            color: "#ECF4FC"
            font.pixelSize: 40
        }

//        Text{
//            id:tempImage
//            anchors.left: tempText.right
//            anchors.leftMargin:5
//            text:"℃"
//            anchors.verticalCenter: parent.verticalCenter
//            color: "#ECF4FC"
//            font.pixelSize: 30
//        }

        Text{
            id:timeText
            width: 160
            anchors.left: tempText.right
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            color: "#ECF4FC"
            font.pixelSize: 40
        }

//        Text{
//            id:timeImage
//            anchors.left: timeText.right
//            anchors.leftMargin:5
//            color: "#ECF4FC"
//            text:"分钟"
//            font.pixelSize: 30
//            anchors.verticalCenter: parent.verticalCenter
//        }
        onClicked: {
            confirm()
        }
    }
}

