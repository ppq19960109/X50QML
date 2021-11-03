import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id:root
    //头部
    Rectangle{
        id:topBar
        width:parent.width
        height:96
        anchors.top:parent.top
        color:"#000"
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        Text{
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.horizontalCenter: parent.horizontalCenter
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
            anchors.left:parent.left
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
            width: img_no.width
            height: img_no.height
            anchors.top:checkBoxRemind.bottom

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -parent.width/4
            background:Rectangle{
                color:"transparent"
            }
            Image{
                id:img_no
                anchors.centerIn: parent
                source:"/images/anniu_yes.png"
            }
            Text{
                text:"返回"
                font.pixelSize: 30
                anchors.centerIn: parent
                color:"#ECF4FC"
            }
            onClicked: {
                backPrePage();
            }
        }
        Button{
            id:btn_yes
            width: img_yes.width
            height: img_yes.height
            anchors.top:checkBoxRemind.bottom

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: parent.width/4
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
                root.visible=false
            }
        }
    }
}
