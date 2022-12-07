import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import "../"
Item {
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:qsTr("清洁模式")
        leftBtnText:qsTr("")
        rightBtnText:qsTr("")
        onLeftClick:{
        }
        onRightClick:{
        }
        onClose:{
            backPrePage()
        }
    }
    //内容
    Item{
        width:parent.width
        anchors.top:parent.top
        anchors.bottom: topBar.top
        Row{
            width: 350*2+20
            height: 210
            anchors.centerIn: parent
            spacing: 20
            Repeater{
                model: [{"modeText":"自动进水清洁","text":"将空锅放入后，\n将自动加水清洁"}, {"modeText":"手动加水清洁","text":"请加入600ml水后，将\n锅体放入右腔，关门"}]
                Button{
                    width: 350
                    height:parent.height

                    background:Rectangle {
                        color: "#333333"
                        radius: 4
                    }
                    Text{
                        text:modelData.modeText
                        color:themesTextColor
                        font.pixelSize: 36
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 30
                    }
                    Text{
                        text:modelData.text
                        color:"#fff"
                        font.pixelSize: 32
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: 94
                    }
                    onClicked: {
                        var clearMode=QmlDevState.getClearMode()
                        var para =CookFunc.getDefHistory()
                        para.cookPos=1
                        para.cookSteps=clearMode[curClearMode].cookSteps
                        if(index==0)
                        {
                            para.cookSteps[0].waterTime=60
                        }
                        else
                        {

                        }
                        startPanguCooking(para,para.cookSteps)
                    }
                }
            }
        }
    }

}
