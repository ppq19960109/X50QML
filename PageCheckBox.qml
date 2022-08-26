import QtQuick 2.12
import QtQuick.Controls 2.5

CheckBox {
    id:control
    width:240
    height:40
    checked: false
    text: qsTr("下次不再提示")
    leftPadding:0
    spacing:10
    contentItem: Text {
        width:parent.width
        text: parent.text
        font.pixelSize: 30
        color: "#FFF"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    indicator: Item {
        implicitWidth: 40
        implicitHeight: implicitWidth
        x: control.leftPadding
        y: parent.height / 2 - height / 2
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
        Image {
            anchors.centerIn: parent
            source: themesPicturesPath+(control.checked ?"icon_checked.png":"icon_unchecked.png")
            //                    visible: control.checked
        }
    }
}
