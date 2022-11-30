import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
Item {
    property int cookWorkPos:0
    property var cookItem:null
    Component.onCompleted: {
        var i
        var hourArray = []
        for(i=0; i< 24; ++i) {
            hourArray.push(i)
        }
        hourPathView.model=hourArray
        var minuteArray = []
        for(i=0; i< 60; ++i) {
            minuteArray.push(i)
        }
        minutePathView.model=minuteArray
    }
    Component.onDestruction: {
        cookItem=null
    }
    MouseArea{
        anchors.fill: parent
    }
    anchors.fill: parent
    Rectangle{
        anchors.fill: parent
        color: "#000"
        opacity: 0.6
    }
    //内容
    Rectangle{
        width:730
        height: 350
        anchors.centerIn: parent
        color: "#333333"
        radius: 10

        PageCloseButton {
            anchors.top:parent.top
            anchors.right:parent.right
            onClicked: {
                loaderMainHide()
            }
        }

        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:-30
        }
        PageDivider{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:row.verticalCenter
            anchors.verticalCenterOffset:30
        }

        Row {
            id:row
            width: parent.width
            height:222
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.left:parent.left
            anchors.leftMargin: 30
            spacing: 10

            Text{
                width:130
                color:"#fff"
                font.pixelSize: 30
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr(cookWorkPos==0?"左腔将在":"右腔将在")
            }
            PageCookPathView {
                id:hourPathView
                width: 200
                height:parent.height
                pathItemCount:3
                currentIndex:0
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("小时")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 60
                }
            }
            PageCookPathView {
                id:minutePathView
                width: 200
                height:parent.height
                pathItemCount:3
                Image {
                    anchors.fill: parent
                    visible: parent.moving
                    asynchronous:true
                    smooth:false
                    anchors.centerIn: parent
                    source: themesPicturesPath+"steamoven/"+"roll_background.png"
                }
                Text{
                    text:qsTr("分钟")
                    color:themesTextColor
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: 60
                }
            }
            Text{
                width:100
                color:"#fff"
                font.pixelSize: 30
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment:Text.AlignHCenter
                verticalAlignment:Text.AlignVCenter
                text:qsTr("后启动")
            }
        }
        Item {
            width:260+140*2
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                width:140
                height: 50
                anchors.left: parent.left
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:qsTr("取消")
                    color:"#000"
                    font.pixelSize: 34
                    anchors.centerIn: parent
                }
                onClicked: {
                    loaderMainHide()
                }
            }
            Button {
                width:140
                height: 50
                anchors.right: parent.right
                background: Rectangle{
                    color:themesTextColor2
                    radius: 25
                }
                Text{
                    text:qsTr("预约")
                    color:"#000"
                    font.pixelSize: 34
                    anchors.centerIn: parent
                }
                onClicked: {
                    if(cookItem!=null)
                    {
                        //                        Object.defineProperty(cookItem, 'orderTime', {
                        //                                                  configurable: false,
                        //                                                  writable: false,
                        //                                              })
                        //                        console.log("getOwnPropertyDescriptor:",JSON.stringify(Object.getOwnPropertyDescriptors(cookItem)))
                        //                        var newObj = Object.assign({},cookItem)
                        //                        console.log("newObj:",JSON.stringify(newObj))
                        cookItem.orderTime=hourPathView.currentIndex*60+minutePathView.currentIndex
                        var cookSteps=null
                        if(cookItem.cookSteps!=null)
                            cookSteps=JSON.parse(cookItem.cookSteps)
                        startCooking(cookItem,cookSteps)
                    }
                    cookSteps=undefined
                    loaderMainHide()
                }
            }
        }
    }
}
