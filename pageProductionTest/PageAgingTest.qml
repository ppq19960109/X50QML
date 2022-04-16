import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    property int time_count: 0
    property var containerqml: null
    property int aging_status:0

    Component.onCompleted: {

    }
    Timer{
        id:timer_aging
        repeat: true
        running: true
        interval: 2000
        triggeredOnStart: true
        onTriggered: {

            if(time_count%3==0)
            {
                rect_bg.color="red"
            }
            else if(time_count%3==1)
            {
                rect_bg.color="green"
            }
            else if(time_count%3==2)
            {
                rect_bg.color="blue"
            }
            var total_time=time_count*2
            cumulative_time.text="累计测试时间: "+Math.floor(total_time/3600)+"时"+Math.floor((total_time%3600)/60)+"分"+Math.floor(total_time%60)+"秒"
            ++time_count

            if(time_count>=7200)//7200
            {
                timer_aging.running=false
                rect_bg.color="green"
                rect_test.text="老化测试成功"
                aging_status=1
            }
        }
    }

    Rectangle{
        id:rect_bg
        width: timer_aging.running?700:400
        height: timer_aging.running?300:100
        anchors.centerIn: parent
        color: "red"
        Text {
            id: rect_test
            visible: !timer_aging.running
            anchors.centerIn: parent
            color:"#FFF"
            font.pixelSize: 40
            text: qsTr("老化测试")
        }
    }
    Text {
        id: cumulative_time
        visible: timer_aging.running
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        color:"#FFF"
        font.pixelSize: 40
        text: qsTr("累计测试时间:")
    }
    Button{
        width:100+50
        height:50+50
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        background:Rectangle{
            width:100
            height:50
            anchors.centerIn: parent
            radius: 8
            color:themesTextColor2
        }
        Text{
            text:"退出"
            color:"#FFF"
            font.pixelSize: 40
            anchors.centerIn: parent
        }
        onClicked: {
            if(timer_aging.running)
            {
                timer_aging.running=false
                rect_bg.color="red"
                rect_test.text="老化测试失败"
                aging_status=-1
            }
            else
            {
                containerqml.clickedfunc(aging_status)
                backPrePage()
            }
        }
    }

}
