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
        onLeftClick:{
            edit=!edit
        }
        onRightClick:{
            load_page("pageCookDetails",JSON.stringify(recipeListView.model[recipeListView.currentIndex]))
        }
        onClose:{
            backPrePage()
        }
    }
    //内容
    Item{
        id:wrapper
        anchors.bottom:topBar.top
        anchors.top: parent.top

        Item {
            id: content
            width: parent.width - 120
            anchors.top:parent.top
            anchors.topMargin:50
            anchors.bottom: checkBoxRemind.top
            anchors.bottomMargin: 30
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
                    font.pixelSize: 35
                    lineHeight: 1.4
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
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            checked: false
        }
        Button{
            id:nextBtn
            width: 176
            height: 64
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
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
