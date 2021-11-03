import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    property bool startButtonState: false

    Component.onCompleted: {
        var tempArray = new Array
        for(var i=0; i< 200; ++i) {
            tempArray.push(i);
            //            console.log("tempArray",i)
        }
        tempPathView.model=tempArray
        timePathView.model=tempArray

    }

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
        //预约
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
                text: qsTr("预约")
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
                Image{
                    source: "/images/fengexian.png"
                    anchors.top:parent.top
                    anchors.topMargin:rowPathView.height/3
                }
                Image{
                    source: "/images/fengexian.png"
                    anchors.top:parent.top
                    anchors.topMargin:rowPathView.height/3*2
                }
                ListModel {
                    id:modeListModel
                    ListElement {modelData:"经典蒸";temp:100;time:40;}
                    ListElement {modelData:"快速蒸";temp:110;time:30;}
                    ListElement {modelData:"热风烧烤";temp:120;time:20}
                    ListElement {modelData:"上下加热";temp:130;time:10}
                }

                Row {
                    id:rowPathView
                    width: parent.width
                    height:parent.height
                    spacing: 20

                    DataPathView {
                        id:modePathView
                        width: parent.width/5
                        height:parent.height
                        model:modeListModel
                        currentIndex:0
                        onValueChanged: {
                            console.log(index,valueName)
                            console.log("model value:",model.get(index).modelData);
                            tempPathView.currentIndex=model.get(index).temp;
                            timePathView.currentIndex=model.get(index).time;

                        }
                    }
                    DataPathView {
                        id:tempPathView
                        width: parent.width/5
                        height:parent.height
                        Component.onCompleted:{
                            //                            tempPathView.positionViewAtIndex(1, PathView.End)
                            tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp;
                        }
                    }
                    Text{
                        //                        width: parent.width/5
                        //                        anchors.left: parent.right
                        anchors.verticalCenter:  parent.verticalCenter
                        text:"℃"
                        font.pixelSize: 30
                        color:"#ECF4FC"
                    }
                    DataPathView {
                        id:timePathView
                        width: parent.width/5
                        height:parent.height
                        Component.onCompleted:{
                            timePathView.currentIndex=modePathView.model.get(modePathView.currentIndex).time;
                        }
                    }
                    Text{
                        //                        width: parent.width/5
                        //                        anchors.left: parent.right
                        anchors.verticalCenter:  parent.verticalCenter
                        text:"分钟"
                        font.pixelSize: 30
                        color:"#ECF4FC"
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
                    text:startButtonState?"停止":"启动"
                    font.pixelSize: fontSize
                }
                onClicked: {
                    startButtonState=!startButtonState
                    console.log(modePathView.model.get(modePathView.currentIndex).modelData,tempPathView.model[tempPathView.currentIndex],timePathView.model[timePathView.currentIndex])
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
