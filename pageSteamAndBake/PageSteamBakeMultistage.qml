import QtQuick 2.0
import QtQuick.Controls 2.2

Page {
    Component.onCompleted: {
        console.log("PageMultistage onCompleted",systemSettings.multistageRemind)
    }
    PageMultistageRemind{
        id:remind
        anchors.fill: parent
        visible: systemSettings.multistageRemind
    }
    PageMultistageSet{
        anchors.fill: parent
        visible: !remind.visible
    }
}
