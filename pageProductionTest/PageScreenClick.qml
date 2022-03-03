import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle {
    property int centerCount: 0
    property int lefttopCount: 0
    property int  righttopCount: 0
    property int  leftbottomCount: 0
    property int  rightbottomCount: 0
    color: "#000"
    Component.onCompleted: {


    }
    Button{
        id:lefttop
        width:100
        height:100
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        background:Rectangle{
            radius: parent.width/2
            color:"blue"
        }
        onClicked: {
            ++lefttopCount
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.left: lefttop.right
        anchors.leftMargin: 20
        anchors.verticalCenter: lefttop.verticalCenter
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: lefttopCount
        }
    }

    Button{
        id:righttop
        width:100
        height:100
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        background:Rectangle{
            radius: parent.width/2
            color:"blue"
        }
        onClicked: {
            ++righttopCount
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.right: righttop.left
        anchors.rightMargin: 20
        anchors.verticalCenter: righttop.verticalCenter
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: righttopCount
        }
    }

    Button{
        id:center
        width:100
        height:100
        anchors.centerIn: parent
        background:Rectangle{
            radius: parent.width/2
            color:"blue"
        }
        onClicked: {
            ++centerCount
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.right: center.left
        anchors.rightMargin: 20
        anchors.verticalCenter: center.verticalCenter
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: centerCount
        }
    }

    Button{
        id:leftbottom
        width:100
        height:100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        background:Rectangle{
            radius: parent.width/2
            color:"blue"
        }
        onClicked: {
            ++leftbottomCount
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.left: leftbottom.right
        anchors.leftMargin: 20
        anchors.verticalCenter: leftbottom.verticalCenter
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text: leftbottomCount
        }
    }

    Button{
        id:rightbottom
        width:100
        height:100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        background:Rectangle{
            radius: parent.width/2
            color:"blue"
        }
        onClicked: {
            ++rightbottomCount
        }
    }
    Rectangle{
        width:150
        height:50
        anchors.right: rightbottom.left
        anchors.rightMargin: 20
        anchors.verticalCenter: rightbottom.verticalCenter
        color:"#FFF"
        Text {
            anchors.centerIn: parent
            color:"#000"
            font.pixelSize: 30
            font.bold : true
            text:rightbottomCount
        }
    }




    Button{
        width:100+40
        height:50+40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        background:Rectangle{
            width:100
            height:50
            anchors.centerIn: parent
            radius: 8
            color:"green"
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
