import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property bool orientation:false
    property int space:0
    property var models:["重置","取消"]
    property int buttonWidth:140
    property int buttonHeight:50
    signal click(int index)
    width:orientation==false?(buttonWidth*models.length+space*(models.length-1)):buttonWidth
    height: orientation==false?buttonHeight:(buttonHeight*models.length+space*(models.length-1))

    Row{
        visible: orientation==false
        spacing: space
        Repeater {
            model:models
            Button {
                width:buttonWidth
                height: buttonHeight
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:modelData
                    color:"#000"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
                onClicked: {
                    click(index)
                }
            }
        }
    }
    Column{
        visible: orientation==true
        spacing: space
        Repeater {
            model:models
            Button {
                width:buttonWidth
                height: buttonHeight
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:modelData
                    color:"#000"
                    font.pixelSize: 30
                    anchors.centerIn: parent
                }
                onClicked: {
                    click(index)
                }
            }
        }
    }
}
