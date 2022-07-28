import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property var para:null
    property int cookDialog:0
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
    Component.onDestruction: {
        para=null
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 600
        implicitHeight: 360
        color: themesPopupWindowColor
//         border.color: "#fff"
        radius: 16
//        PageDialogGradient{
//            anchors.fill: parent
//        }
        Button {
            width:closeImg.width+60
            height:closeImg.height+60
            anchors.top:parent.top
//            anchors.topMargin: 33
            anchors.right:parent.right
//            anchors.rightMargin: 33

            Image {
                id:closeImg
                asynchronous:true
                smooth:false
                cache:false
                anchors.centerIn: parent
                source: themesImagesPath+"icon-window-close.png"
            }
            background: Item {}
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
            width:176+15
            height:64+15
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Text{
                id:confirmBtnText
                color:"#000"
                font.pixelSize: 30

                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                width:176
                height:64
                anchors.centerIn: parent
                color:themesTextColor2
                radius: 32
            }
            onClicked: {
                confirm()
            }
        }
    }
}
