import QtQuick 2.7
import QtQuick.Controls 2.2
import "../"
Item {
    property bool completed_state: false
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
