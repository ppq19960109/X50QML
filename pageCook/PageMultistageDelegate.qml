import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {
    property alias closeVisible: close.visible

      property alias nameText: nameText.text
//    property int modeIndex
//    property alias tempIndex: tempText.text
//    property alias timeIndex: timeText.text

    signal cancel()
    signal confirm()

    implicitWidth: parent.width
    implicitHeight: 100

    PageDivider{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
    Button {
        id:close
        width:delImg.width
        height:parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 40
        visible:true

        background: Item{
            Image {
                id:delImg
                cache:false
                asynchronous:true
                anchors.centerIn: parent
                source: "qrc:/x50/icon/icon_delete.png"
            }
        }
        onClicked: {
            cancel()
        }
    }
    Button {
        height: parent.height
        anchors.left: parent.left
        anchors.right: close.left

        background: Item {}

        Text {
            id: indexText
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            color:"#FFF"
            font.pixelSize: 40
            text:index+1+"、"
        }
        Text{
            id:nameText
            anchors.left: indexText.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            color: "#FFF"
            font.pixelSize: 40
        }

        onClicked: {
            confirm()
        }
    }
}

