import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/pageCook"
import "../"
import "qrc:/SendFunc.js" as SendFunc
Item {

    Component.onCompleted: {

    }

    PageBackBar{
        id:topBar
        anchors.top:parent.top
        name:"蒸烤箱"
    }
    Row {
        width: parent-100
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: row.horizontalCenter
        spacing: 780
        Repeater {
            model: ["左腔","右腔"]
            Item
            {
                width: btnBar.width
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                PageButtonBar{
                    id:btnBar
                    visible: true
                    anchors.verticalCenter: parent.verticalCenter
                    orientation:true
                    space:models.length==3?33:54
                    models: {
                        if(index==0)
                        {
                            return ["左腔蒸烤","多段烹饪","智慧菜谱"]
                        }
                        else
                        {
                            return ["继续","取消"]
                        }
                    }
                    onClick: {

                    }
                }
                Text{
                    id:stateText
                    color:themesTextColor2
                    font.pixelSize: 24
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 17
                    text:qsTr(modelData+"状态")
                }
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: index==0?-60:60
                    anchors.verticalCenter: stateText.verticalCenter
                    asynchronous:true
                    smooth:false
                    source: themesPicturesPath+(index==0?"icon_leftcook_state.png":"icon_rightcook_state.png")
                }
            }
        }
    }
    Row {
        id:row
        width: 290*2+112
        height: 290
        anchors.top: topBar.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 112

        Repeater {
            model: ["左腔","右腔"]
            Button{
                width: 290
                height: width

                background:Image {
                    asynchronous:true
                    smooth:false
                    //                    source: themesPicturesPath+"icon_close_heat.png"
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return false
                        }
                        else
                        {
                            return false
                        }
                    }
                    anchors.fill: parent
                    Image {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 86
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+"icon_cook_add.png"
                    }
                    Text{
                        text:modelData+"烹饪"
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 183
                    }
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:"预热中"
                        color:themesTextColor
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 48
                    }
                    Text{
                        text:"100℃"
                        color:themesTextColor
                        font.pixelSize: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 98
                    }
                    Text{
                        text:"蒸汽嫩烤"
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 161
                    }
                    Text{
                        text:120+"℃     "+60+"分钟"
                        color:themesTextColor2
                        font.pixelSize: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 200
                    }
                }
                Item
                {
                    visible: {
                        if(index==0)
                        {
                            return false
                        }
                        else
                        {
                            return true
                        }
                    }
                    anchors.fill: parent
                    Text{
                        text:"经典蒸"
                        color:themesTextColor2
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 75
                    }
                    Text{
                        text:"烹饪已完成"
                        color:themesTextColor
                        font.pixelSize: 30
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 123
                    }
                    Button {
                        width:140
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 186
                        background: Rectangle{
                            color:themesTextColor2
                            radius: 25
                        }
                        Text{
                            text:"返回"
                            color:"#000"
                            font.pixelSize: 30
                            anchors.centerIn: parent
                        }
                        onClicked: {

                        }
                    }
                }
                PageCirBar{
                    width: 310
                    height: width
                    anchors.centerIn: parent
                    runing:true
                    canvasDiameter:width
                    outerRing:true
                }
                onClicked: {
                    if(index==0)
                    {

                    }
                    else
                    {

                    }
                }
            }
        }
    }

}
