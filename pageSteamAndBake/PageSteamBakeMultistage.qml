import QtQuick 2.0
import QtQuick.Controls 2.2

Page {

    PageMultistageRemind{
        id:remind
        anchors.fill: parent
        visible: true
    }
    PageMultistageSet{
        anchors.fill: parent
        visible: !remind.visible
    }
}
