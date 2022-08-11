import QtQuick 2.7
import QtQuick.Controls 2.2

CheckBox {
    id:control
    width:240
    height:60
    checked: false
    text: qsTr("下次不再提醒")
    leftPadding:0
    contentItem: Text {
        width:parent.width
        text: parent.text
        font.pixelSize: 30
//        opacity: 1.0
        color: "#FFF"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    indicator: Item {
        implicitWidth: 50
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
            width: 30
            height: width
            anchors.centerIn: parent
            source: themesImagesPath+(control.checked ?"iocn_checked.png":"iocn_uncheck.png")
            //                    visible: control.checked
        }
    }
}
