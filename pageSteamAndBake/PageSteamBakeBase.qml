import QtQuick 2.2
import QtQuick.Controls 2.2

Item {

    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
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
                console.log("TabButton back")
                backPrePage();
            }
        }

        Text{
            id:name
            width:50
            color:"#9AABC2"
            font.pixelSize: fontSize
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("蒸箱")
        }
        //多段
        TabButton{
            id:step
            width:160
            height:parent.height
            anchors.right:parent.right
            background:Rectangle{
                color:"transparent"
            }
            Text{
                id:stepName
                color:"#ECF4FC"
                font.pixelSize: fontSize
                anchors.centerIn:parent
                text: qsTr("多段蒸")
            }
            onClicked: {

            }
        }
    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        //                Image {
        //                    source: "/images/main_menu/dibuyuans.png"
        //                    anchors.bottom:parent.bottom
        //                }
        //内容左部
        Rectangle{
            id:contentLeft
            width:626
            height:parent.height
            anchors.top:parent.top
            anchors.left:parent.left
            color:"transparent"
            Rectangle{
                id:nav
                width:parent.width
                height:100
                anchors.top:parent.top
                anchors.left:parent.left
                anchors.topMargin: 0
                color:"transparent"
                Button{
                    id:firstBtn
                    width:190
                    height:parent.height
                    anchors.top:parent.top
                    anchors.left:parent.left
                    anchors.leftMargin: 62
                    background:Rectangle{
                        color:"transparent"
                    }
                    Text{
                        id:firstFont
                        color:"#10CDFF"
                        font.pixelSize: fontSize
                        anchors.centerIn: parent
                        text:"经典蒸"
                    }
                    Image{
                        id:firstBg
                        source: "/images/xiahuaxian.png"
                        opacity: 1
                        anchors.top:firstFont.bottom
                        anchors.horizontalCenter:firstBtn.horizontalCenter
                    }
                    onClicked: {
                        firstFont.color="#10CDFF";
                        secondFont.color="#9AABC2";
                        firstBg.opacity=1;
                        secondBg.opacity=0;
                    }
                }
                Button{
                    id:secondBtn
                    width:190
                    height:parent.height
                    anchors.top:parent.top
                    anchors.right:parent.right
                    anchors.rightMargin: 122
                    background:Rectangle{
                        color:"transparent"
                    }
                    Text{
                        id:secondFont
                        color:"#9AABC2"
                        font.pixelSize: fontSize
                        anchors.centerIn: parent
                        text:"模式蒸"
                    }
                    Image{
                        id:secondBg
                        source: "/images/xiahuaxian.png"
                        opacity: 0
                        anchors.top:secondFont.bottom
                        anchors.horizontalCenter:secondBtn.horizontalCenter

                    }

                    onClicked: {
                        firstFont.color="#9AABC2";
                        secondFont.color="#10CDFF";
                        firstBg.opacity=0;
                        secondBg.opacity=1;
                    }
                }

            }
            Rectangle {
                width:parent.width
                anchors.top: nav.bottom
                anchors.bottom: parent.bottom
                color:"transparent"

                Row {
                    anchors.fill: parent
                    spacing: 20

                    DataPathView {
                        width: 100
                        height:parent.height
                    }
                    DataPathView {
                        width: 100
                        height:parent.height
                    }

                }
            }

        }
        //内容Right
        Rectangle{
            id:contentRight

            height:parent.height
            anchors.top:parent.top
            anchors.left: contentLeft.right
            anchors.right:parent.right
            anchors.rightMargin: 10
            color:"transparent"
            Button{
                id:startUp
                width:parent.width
                height:96
                anchors.top:parent.top
                anchors.topMargin: 100
                anchors.right:parent.right
                background:Rectangle{
                    color:"transparent"
                }
                Image{
                    id:startUpBg
                    source: "/images/anniu.png"
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.right:parent.right
                }
                Text{
                    id:startText
                    anchors.centerIn: startUpBg
                    color:"#fff"
                    text:"启动"
                    font.pixelSize: fontSize
                }
                onClicked: {

                }
            }
            Button{
                id:order
                width:parent.width
                height:96
                anchors.top:startUp.bottom
                anchors.topMargin: 44
                anchors.right:parent.right
                visible: true
                background:Rectangle{
                    color:"transparent"
                }
                Image{
                    id:orderBg
                    source: "/images/anniu.png"
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.right:parent.right
                    visible:false
                }
                Text{
                    id:orderText
                    anchors.centerIn: orderBg
                    color:"#9AABC2"
                    text:"预约"
                    font.pixelSize: fontSize
                }
            }
        }
    }
}
