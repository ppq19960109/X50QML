import QtQuick 2.9
import QtQuick.Controls 2.2
import "../"
Rectangle {
    id:root
    color: themesWindowBackgroundColor

    PageBackBar{
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
        name:qsTr("多段烹饪说明")
        leftBtnText:""
        rightBtnText:""
        onClose:{
            backPrePage()
        }
    }
    //内容
    Item{
        id:wrapper
        width: parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Item {
            id: content
            width: parent.width - 120
            anchors.top:parent.top
            anchors.topMargin:50
            anchors.bottom: checkBoxRemind.top
            anchors.bottomMargin: 36
            //            anchors.leftMargin: 30
            //            anchors.rightMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: textRemind.width
                contentHeight: textRemind.height
                //                clip: true
                Text {
                    id: textRemind
                    width: flick.width
                    height: flick.height
                    text:"在设置中，您可以将该次烹饪，拆分为1至3段，并分别设置每段参数，以实现用多段温度、时长来烹饪食物。"
                    font.pixelSize: 36
                    lineHeight: 1.3
                    color:"#FFF"
                    //                    clip :true
                    wrapMode: Text.WordWrap
                    //                    elide: Text.ElideRight
                }
            }
        }
        PageCheckBox {
            id:checkBoxRemind
            anchors.bottom:nextBtn.top
            anchors.bottomMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
        }
        Button{
            id:nextBtn
            width: 176+15
            height: 64+15
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                width:176
                height:64
                anchors.centerIn: parent
                color:themesTextColor2
                radius: 32
            }

            Text{
                text:"下一步"
                color:"#000"
                font.pixelSize: 30
                anchors.centerIn:parent
//                horizontalAlignment:Text.AlignHCenter
//                verticalAlignment:Text.AlignVCenter
            }
            onClicked: {
                if(checkBoxRemind.checked)
                {
                    systemSettings.multistageRemind=false
                }
                root.visible=false
            }
        }
    }
}
