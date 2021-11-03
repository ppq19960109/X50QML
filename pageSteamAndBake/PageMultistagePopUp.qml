import QtQuick 2.0
import QtQuick.Controls 2.2

Item {
    signal showListData(var listData)
    Component.onCompleted: {
        var tempArray = new Array
        for(var i=0; i< 200; ++i) {
            tempArray.push(i);
            //            console.log("tempArray",i)
        }
        tempPathView.model=tempArray
        timePathView.model=tempArray
    }
    Rectangle{
        id:keyboard
        color: "#bb000000"
        anchors.fill: parent
        MouseArea{
            anchors.top:parent.top
            width:parent.width
            height:parent.height-dibutanchuang.height
            onClicked: {
                dismissTanchang()
            }
            onReleased:{}
            onPressed: {}
        }
        Rectangle{
            id:dibutanchuang
            width:parent.width
            height:253
            anchors.bottom: parent.bottom
            color:"transparent"

            Image{
                source: "/images/dibutanchuang_bj.png"
            }
            //内容左部
            Rectangle{
                id:contentLeft
                width:608
                height:parent.height
                anchors.top:parent.top
                anchors.left:parent.left
                anchors.leftMargin: 17
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
                            tempPathView.currentIndex=modePathView.model.get(modePathView.currentIndex).temp;
                        }
                    }
                    Text{
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
                        anchors.verticalCenter:  parent.verticalCenter
                        text:"分钟"
                        font.pixelSize: 30
                        color:"#ECF4FC"
                    }
                }
            }
            //内容右部
            Rectangle{
                id:contentRight
                width:parent.width-contentLeft.width
                height:parent.height
                anchors.top:parent.top
                anchors.right:parent.right

                color:"transparent"
                Button{
                    id:confirm
                    width:confirm_bg.width
                    height:confirm_bg.height
                    anchors.top:parent.top
                    anchors.topMargin:40
                    anchors.horizontalCenter: parent.horizontalCenter

                    background:Rectangle{
                        color:"transparent"
                    }
                    Image{
                        id:confirm_bg
                        source: "/images/anniu.png"
                    }
                    Text{
                        anchors.centerIn: parent
                        color:"#fff"
                        text:"确定"
                        font.pixelSize: 40
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                    }
                    onClicked: {
                        var param = {};
                        param.cookMode =modePathView.model.get(modePathView.currentIndex).modelData
                        param.temp = tempPathView.model[tempPathView.currentIndex]
                        param.time = timePathView.model[timePathView.currentIndex]
                        console.log('listParam'+param);
                        showListData(param);
                        dismissTanchang();
                    }
                }
                Button{
                    id:cancel
                    width:cancel_bg.width
                    height:cancel_bg.height
                    anchors.bottom:parent.bottom
                    anchors.bottomMargin:40
                    anchors.horizontalCenter: parent.horizontalCenter

                    background:Rectangle{
                        color:"transparent"
                    }
                    Image{
                        id:cancel_bg
                        source: "/images/anniu.png"
                        visible: true
                    }
                    Text{
                        anchors.centerIn: parent
                        color:"#9AABC2"
                        text:"取消"
                        font.pixelSize: 40
                        horizontalAlignment:Text.AlignHCenter
                        verticalAlignment:Text.AlignVCenter
                    }
                    onClicked: {
                        dismissTanchang();
                    }
                }
            }
        }

    }
}
