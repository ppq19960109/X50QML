import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property alias hint_text: hint.text
    property alias confirm_text: confirm_btn_text.text
    property alias checkbox_visible: checkbox.visible
    signal cancel()
    signal confirm()

    anchors.fill: parent
    color: "transparent"
    Rectangle {
        anchors.centerIn: parent
        implicitWidth: 500
        implicitHeight: 280
        color: "#000"
        radius: 10
        Button {
            id:cancel_btn
            width:50
            height:50
            anchors.top:parent.top
            anchors.topMargin: 5
            anchors.right:parent.right
            anchors.rightMargin: 5

            Text{
                width:40
                color:"white"
                font.pixelSize: 40

                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text:"X"
            }
            background: Rectangle {
                color:"transparent"
            }
            onClicked: {
                cancel()
            }
        }

        Text{
            id:hint
            width:400
            color:"white"
            font.pixelSize: 35
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode:Text.Wrap
        }

        CheckBox {
            id:checkbox
            width:150
            height:30
            anchors.bottom:confirm_btn.top
            anchors.bottomMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
            text: qsTr("下次不再提醒")
            contentItem: Text {
                width:200
                text: parent.text
                font.pixelSize: 25
                opacity: 1.0
                color: "white"
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkbox.indicator.width + checkbox.spacing
            }
        }
        Button {
            id:confirm_btn
            width:150
            height:40
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id:confirm_btn_text
                width:300
                color:"white"
                font.pixelSize: 30

                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color:"blue"
                radius: 5
            }
            onClicked: {
                confirm()
            }
        }
    }
}
