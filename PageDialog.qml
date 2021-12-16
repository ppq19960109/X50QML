import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property alias hintTopText: hintTop.text
    property alias confirmText: confirmBtnText.text
    property alias checkboxVisible: control.visible
    property alias hintHeight: hint.height
    signal cancel()
    signal confirm()

    anchors.fill: parent
    color: "#000"
    opacity: 0.6
    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 358
        color: "#000"
        radius: 16

        Button {
//            width:50
//            height:50
            anchors.top:parent.top
            anchors.topMargin: 33
            anchors.right:parent.right
            anchors.rightMargin: 33

            Image {
                anchors.centerIn: parent
                source: "/x50/icon/icon_close@2x.png"
            }
            background: Rectangle {
                color:"transparent"
            }
            onClicked: {
                cancel()
            }
        }

        Text{
            id:hintTop
            width:parent.width
            color:"white"
            font.pixelSize: 40
            anchors.top: parent.top
            anchors.topMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.Wrap
        }

        CheckBox {
            id:control
            width:200
            height:30
            anchors.bottom:confirmBtn.top
            anchors.bottomMargin: 42
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
            text: qsTr("下次不再提醒")
            contentItem: Text {
                width:parent.width
                text: parent.text
                font.pixelSize: 30
                opacity: 1.0
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: control.indicator.width + control.spacing
            }
//            indicator: Rectangle {
//                implicitWidth: 24
//                implicitHeight: 24
//                x: control.leftPadding
//                y: parent.height / 2 - height / 2
//                radius: 3
//                border.color: control.down ? "#17a81a" : "#21be2b"

//                Rectangle {
//                    width: 14
//                    height: 14
//                    x: 6
//                    y: 6
//                    radius: 2
//                    color: control.down ? "#17a81a" : "#21be2b"
//                    visible: control.checked
//                }
//            }
        }
        Button {
            id:confirmBtn
            width:176
            height:64
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id:confirmBtnText
                color:"#00E6B6"
                font.pixelSize: 30

                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color:"transparent"
                border.color:"#00E6B6"
                radius: 8
            }
            onClicked: {
                confirm()
            }
        }
    }
}
