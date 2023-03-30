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
        if(speedSlider.value>=0)
        {
            cookSteps[1].motorDir=0
        }
        else
        {
            cookSteps[1].motorDir=1
        }
        cookSteps[1].motorSpeed=Math.abs(speedSlider.value)

        cookSteps[cookSteps.length-1].repeat=Math.ceil((timeSlider.value-timeSlider.from)/10)+1
        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=cookSteps

        startPanguCooking(para,cookSteps)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"冰沙"
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
                stepSize: 10
                from: 10
                to: 500
                value: 10
                title:"时间"
                unit:"S"
            }
            PageSlider2 {
                id: speedSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                stepSize: 1
                from: -20
                to: 20
                value: 0
                title:"转速"
                unit:"挡"
            }
        }
    }
}


