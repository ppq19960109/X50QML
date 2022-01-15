import QtQuick 2.7
import QtQuick.Controls 2.2

Rectangle {
    property alias hintTopText: hintTop.text
    property alias confirmText: confirmBtnText.text
    property alias checkboxVisible: control.visible
    property alias checkboxState: control.checked
    property alias hintHeight: hint.height
    signal cancel()
    signal confirm()

    MouseArea{
        anchors.fill: parent
//        hoverEnabled:true
//        propagateComposedEvents: true
//        onPressed: {
//            mouse.accepted = true
//        }
    }
    Component.onCompleted: {
        console.log("PageDialog",closeImg.width)
    }

    anchors.fill: parent
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }
    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 358
        color: "#596767"
//         border.color: "#fff"
        radius: 16
        PageDialogGradient{
            anchors.fill: parent
        }
        Button {
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
//            anchors.topMargin: 33
            anchors.right:parent.right
//            anchors.rightMargin: 33

            Image {
                id:closeImg
                anchors.centerIn: parent
                source: "/x50/icon/icon_close.png"
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

        PageCheckBox {
            id:control

            anchors.bottom:confirmBtn.top
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
        }
        Button {
            id:confirmBtn
            width:195
            height:85
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 30
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
                width:175
                height:65
                anchors.centerIn: parent
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
