import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/SendFunc.js" as SendFunc
Button {
    property var pushRod:QmlDevState.state.PushRod
    width:124
    height:48
    anchors.centerIn: parent
    background:Rectangle{
       color: themesTextColor2
       radius: 8
    }
    Text{
        anchors.centerIn: parent
        color:"#000"
        font.pixelSize: 28
        text: pushRod?"关门":"开门"
    }
    onClicked: {
        var Data={}
        Data.PushRod = !pushRod
        SendFunc.setToServer(Data)
    }
}
