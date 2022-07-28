import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "qrc:/SendFunc.js" as SendFunc
Item {
    readonly property int layWidth:200
    readonly property int layHeight:30
    readonly property int fontPixelSize:20

    readonly property var twobytes: [twobyte0, twobyte1, twobyte2, twobyte3, twobyte4, twobyte5, twobyte6, twobyte7, twobyte8, twobyte9, twobyte10]
    readonly property var onebytes: [onebyte0, onebyte1, onebyte2, onebyte3, onebyte4, onebyte5, onebyte6]

    Component.onCompleted: {
        SendFunc.loadPowerSet(2)
    }
    Component.onDestruction: {
        SendFunc.loadPowerSet(0)
    }
    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState
        onStateChanged: { // 处理目标对象信号的槽函数
//            console.log("PagePowerBoard:",key,value,typeof value)
            if("PCBInput"==key)
            {
                var i
                for(i=0;i<22;i+=2)
                {
                    twobytes[i/2].text=(value[i]<<8) + value[i+1]
                }
                for(;i<29;++i)
                {
                    onebytes[i-22].text=value[i]
                }
            }
            key=null
            value=null
        }
    }
    Item{
        id:topBar
        width:parent.width
        height:80
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            color:themesTextColor
            font.pixelSize: 40
            font.bold : true
            text: qsTr("电源板输入检测")
        }
        Button{
            width:100
            height:50
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: parent.bottom

            background:Rectangle{
                radius: 8
                color:themesTextColor2
            }
            Text{
                text:"退出"
                color:"#fff"
                font.pixelSize: 40
                anchors.centerIn: parent
            }
            onClicked: {
                backPrePage()
            }
        }
    }

    Item{
        id:bottomBar
        width:parent.width
        anchors.top: topBar.bottom
        anchors.bottom: parent.bottom
        GridLayout{
            width:480
            height: parent.height - 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            rows: 11
            columns: 2
            rowSpacing: 1
            columnSpacing: 1

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"防火墙AD1:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte0
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"防火墙AD2:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte1
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"热电偶AD1:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte2
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"热电偶AD2:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte3
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"燃气传感器AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte4
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"左箱内温度传感器AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte5
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"左底部温度传感器AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte6
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"左水位AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte7
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右箱内温度传感器AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte8
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右底部温度传感器AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte9
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右水位AD:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:twobyte10
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"65535"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
        }
        GridLayout{
            width:280
            height: parent.height - 40
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            rows: 7
            columns: 2
            rowSpacing: 1
            columnSpacing: 1

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右电磁阀:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte0
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右旋钮按键:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte1
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"左旋钮按键:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte2
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"水盒状态:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte3
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"左门状态:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte4
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"右门状态:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte5
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

            Text{
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"EEPROM状态:"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }
            Text{
                id:onebyte6
                Layout.preferredWidth: layWidth
                Layout.preferredHeight:layHeight
                text:"255"
                color:"#FFF"
                font.pixelSize: fontPixelSize
            }

        }
    }
}
