import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Component.onCompleted: {
        SendFunc.loadPowerSet(3)
    }
    Component.onDestruction: {
        SendFunc.loadPowerSet(0)
    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("电源板输出检测")
    }
    Rectangle{
        width:parent.width-100
        height:200
        anchors.centerIn: parent
        color:themesPopupWindowColor
        Text{
            anchors.centerIn: parent
            text:"步骤 "+QmlDevState.state.LoadPowerState
            color:"#fff"
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
