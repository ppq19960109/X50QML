import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id:root
    //头部
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backTopPage()
            }
        }

        Text{
            width:100
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("多段")
        }
    }
    //内容
    Rectangle{
        id:wrapper
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"
        Image {
            source: "/images/main_menu/dibuyuans.png"
            anchors.bottom:parent.bottom
        }
        Rectangle {
            id: content
            width: parent.width - 60
            height: 190
            anchors.top:parent.top
            anchors.topMargin:28
            //            anchors.leftMargin: 30
            //            anchors.rightMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            color:"transparent"
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
                    font.pixelSize: 34
                    color:"#9AABC2"
                    //                    clip :true
                    wrapMode: Text.WordWrap
                    //                    elide: Text.ElideRight
                }
            }
        }
        CheckBox {
            id:checkBoxRemind
            width:200
            anchors.top:content.bottom
            anchors.topMargin:20
            anchors.horizontalCenter: parent.horizontalCenter

            text:"下次不再提醒"
            font.pixelSize: 30
            contentItem: Text {
                text: checkBoxRemind.text
                font: checkBoxRemind.font
                color:"#7286A4"
                leftPadding :checkBoxRemind.indicator.width+10
            }
        }

        Button{
            id:btn_yes
            width: img_yes.width
            height: img_yes.height
            anchors.top:checkBoxRemind.bottom

            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                color:"transparent"
            }
            Image{
                id:img_yes
                anchors.centerIn: parent
                source:"/images/anniu_yes.png"
            }
            Text{
                text:"下一步"
                font.pixelSize: 30
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color:"#ECF4FC"
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
