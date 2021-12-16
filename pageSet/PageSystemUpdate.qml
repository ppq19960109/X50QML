import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
Item {
    enabled: loader_main.status == Loader.Null
    property bool versionChecked: false

    function otaRquest(request)
    {
        var Data={}
        Data.OTARquest = request
        setToServer(Data)
    }

    Connections { // 将目标对象信号与槽函数进行连接
        target: QmlDevState

        onStateChanged: { // 处理目标对象信号的槽函数
            console.log("PageSystemUpdate onStateChanged:",key)

            if("OTAState"==key)
            {
                if(value==1)
                {
                    versionChecked=false
                }
                else if(value==2)
                {
                    checkStatus.visible=false
                    versionChecked=false

                    showUpdateConfirm()
                }
                else if(value==3)
                {
                    showUpdate()
                }
                else if(value==8)
                {
                    showUpdateSuccess()
                }
            }
            else if(("OTAProgress"==key))
            {
                console.log("OTAProgress:",value)
                showUpdateProgress(value);
                if(value==100)
                {

                }
            }
            else if(("OTANewVersion"==key))
            {

            }
        }
    }
    Component.onCompleted: {


    }
    ToolBar {
        id:topBar
        width:parent.width
        anchors.bottom:parent.bottom
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
            text:qsTr("系统更新")
        }

    }
    //内容
    Rectangle{
        width:parent.width
        anchors.bottom:topBar.top
        anchors.top: parent.top
        color:"#000"

        Image{
            id:logo
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/images/icon_mars_fans_club_logo.png"
        }
        Button{
            id:version
            width: 250
            height: 50
            anchors.top: logo.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{

                color:"transparent"
            }
            Text{
                text:"当前版本V"+QmlDevState.state.SoftVersion+"    >"
                color:"#fff"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {
                load_page("pageReleaseNotes")
            }
        }
        Rectangle{
            id:checkStatus
            width: 180
            height: 50
            anchors.top: version.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
            color:"#000"
            Text{
                id:checkText
                text:versionChecked ?"正在检查":"已经是最新版本"
                color:"#fff"
                font.pixelSize: 30
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
            PageBusyIndicator{
                id:busy
                visible: versionChecked
                width: 40
                height: 40
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                running: visible
            }
        }

        Button{
            id:version_btn
            width: 150
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            background:Rectangle{
                radius: 30
                color:versionChecked ?"darkgray":"blue"
            }

            Text{
                text:"检查更新"
                color:"#fff"
                font.pixelSize: 30
                anchors.centerIn: parent
            }

            onClicked: {
                checkStatus.visible=true
                versionChecked=true
                otaRquest(0)

                //                showUpdateConfirm()
            }
        }
    }
    Component{
        id:component_updateConfirm
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

            Text{
                width:200
                color:"white"
                font.pixelSize: 40
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"系统更新"
            }
            Text{
                width:600
                color:"white"
                font.pixelSize: 35
                anchors.centerIn:parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"检测到最新版本V"+QmlDevState.state.OTANewVersion+"，是否升级系统"
            }

            Button {
                id:cancel_btn
                width: 120
                height: 50
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 200
                Text{
                    width:parent.width
                    color:"white"
                    font.pixelSize: 30

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"取消"
                }
                background: Rectangle {
                    color:"blue"
                    radius: 5
                }
                onClicked: {
                    closeLoaderMain()
                }
            }

            Button {
                id:confirm_btn
                width: 120
                height: 50
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 200
                Text{
                    width:parent.width
                    color:"white"
                    font.pixelSize: 30

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"升级"
                }
                background: Rectangle {
                    color:"blue"
                    radius: 5
                }
                onClicked: {
                    otaRquest(1)
                }
            }
        }
    }
    function showUpdateConfirm(){
        loader_main.sourceComponent = component_updateConfirm
    }

    Component{
        id:component_update
        Rectangle {
            anchors.fill: parent
            color: "#000"
            function updateProgress(value){
                updateBar.value=value
                updateCirBar.percent=value
                updateCirBar.updatePaint()
            }
            PageUpdateProgressBar{
                id:updateCirBar
                radius: 200
                anchors.centerIn: parent
                percent:0
            }
            ProgressBar {
                id:updateBar
                width: 600
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 80
                anchors.horizontalCenter: parent.horizontalCenter
                from:0
                to:100
                value: 0
            }

            Slider {
                id: slider
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                stepSize: 2
                to: 100
                value: 0
                onValueChanged: {
                    console.log("slider:",value)
                    updateBar.value=value
                    updateCirBar.percent=value
                    updateCirBar.updatePaint()

                }
            }
        }
    }
    function showUpdate(){
        loader_main.sourceComponent = component_update
    }
    function showUpdateProgress(value){
        loader_main.item.updateProgress(value)
    }
    Component{
        id:component_updateSuccess
        Rectangle {
            anchors.fill: parent
            color: "#000"
            radius: 10

            Text{
                width:600
                color:"white"
                font.pixelSize: 40
                anchors.centerIn:parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                wrapMode:Text.Wrap
                text:"系统已更新至最新版本V"+QmlDevState.state.OTANewVersion
            }

            Button {
                id:confirm_btn
                width: 150
                height: 50
                anchors.bottom:parent.bottom
                anchors.bottomMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    width:parent.width
                    color:"white"
                    font.pixelSize: 30

                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text:"知道了"
                }
                background: Rectangle {
                    color:"blue"
                    radius: 5
                }
                onClicked: {

                    backTopPage()
                    closeLoaderMain()
                }
            }
        }
    }
    function showUpdateSuccess(){
        loader_main.sourceComponent = component_updateSuccess
    }
}

