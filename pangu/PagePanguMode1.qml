import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:/CookFunc.js" as CookFunc
import "qrc:/SendFunc.js" as SendFunc
import ".."
Item{
    property var cookSteps

    function steamStart(order)
    {
        cookSteps[0].waterTime=waterSlider.value
        cookSteps[cookSteps.length-1].repeat=Math.ceil((timeSlider.value-timeSlider.from)/20)+1
        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=cookSteps

        startPanguCooking(para,cookSteps)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"馒头面团-揉面"
        leftBtnText:qsTr("启动")
        //        rightBtnText:qsTr("预约")
        onClose:{
            backPrePage()
        }
        onLeftClick:{
            steamStart(false)
        }
        onRightClick:{
            steamStart(true)
        }
    }
    Item{
        width: parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        ColumnLayout{
            width: 300
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 10

            PageSlider2 {
                id: timeSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                stepSize: 20
                from: 440
                to: 1500
                value: 600
                title:"时间"
                unit:"S"
            }
            PageSlider2 {
                id: waterSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                stepSize: 10
                to: 1500
                value: 0
                title:"进水量"
                unit:"ML"
            }
        }
    }
}


