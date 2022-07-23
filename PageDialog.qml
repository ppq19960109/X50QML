import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property var para
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
    }
    anchors.fill: parent

    Rectangle {
        id:hint
        anchors.centerIn: parent
        implicitWidth: 730
        implicitHeight: 350
        color: themesPopupWindowColor

        radius: 10
        Button {
            width:closeImg.width+50
            height:closeImg.height+50
            anchors.top:parent.top
            anchors.right:parent.right
            Image {
                id:closeImg
                asynchronous:true
                smooth:false
                cache:false
                anchors.centerIn: parent
                source: themesPicturesPath+"icon_window_close.png"
            }
            background: null
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
