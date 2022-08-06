import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
import "qrc:/pageCook"
Item {
    property bool completed_state: false
    Component{
        id:component_tempControl
        Item {
            property int cookWorkPos:0
            property var clickFunc:null
            Component.onCompleted: {
                var i
                var array = []
                for(i=100; i<= 300; ++i) {
                    array.push(i)
                }
                tempPathView.model=array
            }
            Component.onDestruction: {
                clickFunc=null
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
                    width: parent.width-200
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:tempPathView.verticalCenter
                    anchors.verticalCenterOffset:-30
                }
                PageDivider{
                    width: parent.width-200
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:tempPathView.verticalCenter
                    anchors.verticalCenterOffset:30
                }
                Text{
                    width:130
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:qsTr("控温范围")
                }

                PageCookPathView {
                    id:tempPathView
                    width: 449
                    height:222
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    anchors.horizontalCenter: parent.horizontalCenter
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
                        text:qsTr("℃")
                        color:themesTextColor
                        font.pixelSize: 24
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 60
                    }
                }

                PageButtonBar{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    space:80
                    models: ["取消","确定"]
                    onClick: {
                        loaderMainHide()
                    }
                }
            }
        }
    }
    function loaderTempControl(clickFunc)
    {
        loaderManual.sourceComponent = component_tempControl
        loaderManual.item.clickFunc=clickFunc
    }

    Component.onCompleted: {
        completed_state=true
    }
    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:qsTr("智慧烹饪")
    }

    Row {
        width: 314+204*3+40*2
        height: 282
        anchors.top: topBar.bottom
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40
        Item{
            width: 314
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"auxiliary_temp_control.png"
            }
            Text{
                text:"右灶 | 辅助控温"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            Text{
                visible: auxiliary_temp_control_switch.checked==true
                text:140+"℃"
                color:themesTextColor
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
            }
            PageSwitch {
                id:auxiliary_temp_control_switch
                checked:false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onCheckedChanged: {
                    if(completed_state==false)
                        return
                    if(checked==true)
                        loaderTempControl(null)
                }
            }
        }
        Item{
            width: 204
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"cooking_curve.png"
            }
            Text{
                text:"烹饪曲线"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            PageSwitch {
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onCheckedChanged: {
                    if(completed_state==false)
                        return
                }
            }
        }
        Rectangle{
            width: 204
            height:parent.height
            color: "#000"
            Image {
                visible: oil_temp_switch.checked==false
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"oil_temp.png"
            }
            Text{
                text:"油温显示"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            Text{
                visible: oil_temp_switch.checked==true
                text:"当前油温参考\n左灶 "+140+"℃\n右灶 "+23+"℃"
                color:themesTextColor
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 84
            }
            PageSwitch {
                id:oil_temp_switch
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onCheckedChanged: {
                    if(completed_state==false)
                        return
                }
            }
        }
        Item{
            width: 204
            height:parent.height

            Image {
                asynchronous:true
                smooth:false
                source: themesPicturesPath+"remove_pan_fire.png"
            }
            Text{
                text:"右灶\n移锅小火"
                color:"#fff"
                font.pixelSize: 34
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 30
                horizontalAlignment:Text.AlignHCenter
            }
            PageSwitch {
                checked: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                source: themesPicturesPath+(checked ?"icon_switch_open.png":"icon_switch_close.png")
                onCheckedChanged: {
                    if(completed_state==false)
                        return
                }
            }
        }
    }

}