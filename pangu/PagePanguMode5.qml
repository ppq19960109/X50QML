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
        cookSteps[cookSteps.length-1].repeat=Math.ceil((timeSlider.value-timeSlider.from)/60)+1
        var para =CookFunc.getDefHistory()
        para.cookPos=1
        para.cookSteps=cookSteps

        startPanguCooking(para,cookSteps)
    }
    PageBackBar{
        id:topBar
        anchors.bottom:parent.bottom
        name:"煲汤"
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
                Layout.preferredHeight: 90
                stepSize: 60
                from: 60
                to: 600
                value: 60
                title:"时间"
                unit:"min"
            }
            PageSlider2 {
                id: waterSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                stepSize: 10
                to: 1500
                value: 0
                title:"进水量"
                unit:"ML"
            }
        }
    }
}


