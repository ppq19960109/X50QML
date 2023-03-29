import QtQuick 2.12
import QtQuick.Controls 2.5
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
    implicitHeight: 70

    PageDivider{
        anchors.bottom: parent.bottom
    }
    Button {
        id:close
        width:100
        height:parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        background: Image {
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesImagesPath+"icon_cook_delete.png"
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
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            color:"#FFF"
            font.pixelSize: 30
            text:index+1+"、"
        }
        Text{
            id:nameText
            anchors.left: indexText.right
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            color: "#FFF"
            font.pixelSize: 25
        }

        onClicked: {
            confirm()
        }
    }
}

