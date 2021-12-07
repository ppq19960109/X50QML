import QtQuick 2.0
import QtQuick.Controls 2.2

Item {

    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        background:Rectangle{
            color:"#000"
        }
        Image {
            anchors.fill: parent
            source: "/images/main_menu/zhuangtai_bj.png"
        }
        //back图标
        TabButton {
            id:goBack
            width:80
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "/images/fanhui.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                backPrePage()
            }
        }

        Text{
            id:pageName
            width:100
            //            height:parent.height
            color:"#9AABC2"
            font.pixelSize: 40
            anchors.left:goBack.right
            anchors.verticalCenter: parent.verticalCenter
            text:qsTr("关于本机")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"
        Item{
            width:parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 100
            Text{
                id:category
                anchors.top: parent.top
                anchors.topMargin: 30

                text:"品类："+QmlDevState.state.ProductCategory
                color:"#fff"
                font.pixelSize: 30
            }

            Text{
                id:model
                anchors.top: category.bottom
                anchors.topMargin: 30

                text:"型号："+QmlDevState.state.ProductModel
                color:"#fff"
                font.pixelSize: 30
            }
            Text{
                id:deviceId
                anchors.top: model.bottom
                anchors.topMargin: 30

                text:"device ID："+QmlDevState.state.DeviceName
                color:"#fff"
                font.pixelSize: 30
            }
            Button{
                width: 350
                height: 50
                anchors.top: deviceId.bottom
                anchors.topMargin: 30

                background:Rectangle{
                    color:"transparent"
                }
                Text{
                    text:"绑定官方APP            >"
                    color:"#fff"
                    font.pixelSize: 30
                }

                onClicked: {
                    showBind()
                }
            }
        }
    }
    Component{
        id:component_bind
        Rectangle {
            anchors.fill: parent
            color: "#000"
            radius: 10
            Button {
                width:50
                height:50
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.right:parent.right
                anchors.rightMargin: 5

                Text{
                    width:40
                    color:"white"
                    font.pixelSize: 40

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"X"
                }
                background: Rectangle {
                    color:"transparent"
                }
                onClicked: {
                    closeLoaderMain()
                }
            }
            Image{
                id:qrCodeImg
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -qrCodeImg.width/2
                anchors.verticalCenter: parent.verticalCenter
                source: "file:QrCode.png"
            }

            Text{
                width:300
                anchors.top: qrCodeImg.top
                anchors.left: qrCodeImg.right
                anchors.leftMargin: 20
                color:"white"
                font.pixelSize: 30
//                font.letterSpacing : 5
                font.bold :true
                lineHeight: 2

                wrapMode:Text.WordWrap
                text:"此二维码可以：\n1：下载官方APP\n2：官方APP绑定设备"
            }
        }
    }
    function showBind(){
        loader_main.sourceComponent = component_bind
    }
}

