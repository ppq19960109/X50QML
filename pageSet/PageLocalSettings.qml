import QtQuick 2.12
import QtQuick.Controls 2.5
import "../"
Item {
    Component {
        id: pageClock
        PageClock {}
    }
    Item {
        id:localSet
        anchors.fill: parent
        anchors.margins: 40
        ScrollView{
            id:scrollView
            anchors.fill: parent
            contentWidth :availableWidth
            contentHeight:500
            clip: true
            ScrollBar.vertical: ScrollBar {
                parent: scrollView.parent
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.right
                anchors.leftMargin: 20

                background:Rectangle{
                    implicitWidth: 4
                    color:"#313131"
                    radius: implicitWidth / 2
                }
                contentItem: Rectangle {
                    implicitWidth: 4
                    radius: implicitWidth / 2
                    color: themesTextColor
                }
            }

            Item{
                id:light
                width:parent.width
                height: 100
                anchors.top: parent.top
                Text{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color:"#fff"
                    text:qsTr("亮度")
                    font.pixelSize:30
                }
                Image{
                    asynchronous:true
                    source: themesPicturesPath+"icon_light_small.png"
                    anchors.right: lightSlider.left
                    anchors.rightMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageSlider {
                    id:lightSlider
                    width: 590
                    anchors.left:parent.left
                    anchors.leftMargin: 150
                    anchors.verticalCenter: parent.verticalCenter
                    stepSize: 2
                    from: 1
                    to: 255
                    value: Backlight.backlightGet()
                    onValueChanged: {
                        systemSettings.brightness=value
                    }
                }
                Image{
                    asynchronous:true
                    source: themesPicturesPath+"icon_light_big.png"
                    anchors.left: lightSlider.right
                    anchors.leftMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Item{
                id:screenSwitch
                width:parent.width
                height: 100
                anchors.top: light.bottom
                Text{
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color:"#fff"
                    text:qsTr("息屏")
                    font.pixelSize:30
                }
                PageSwitch {
                    anchors.left:parent.left
                    anchors.leftMargin: 720
                    anchors.verticalCenter: parent.verticalCenter
                    checked:true

                    onClicked: {
                        console.log("onCheckedChanged:", checked)
                        systemSettings.sleepSwitch=checked
                    }
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Item{
                id:screen
                visible: systemSettings.sleepSwitch
                width:parent.width
                height: 100
                anchors.top: screenSwitch.bottom

                Text{
                    color:"#fff"
                    text:qsTr( systemSettings.sleepTime+"分钟")
                    font.pixelSize:30
                    anchors.right: screenSlider.left
                    anchors.rightMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageSlider {
                    id:screenSlider
                    width: 590
                    anchors.left:parent.left
                    anchors.leftMargin: 150
                    anchors.verticalCenter: parent.verticalCenter
                    stepSize: 1
                    from: 1
                    to: 5
                    value: systemSettings.sleepTime
                    displayText:value+"分钟"
                    onValueChanged: {
                        console.log("screenSlider:",value)
                        systemSettings.sleepTime=value
                    }
                }
                Text{
                    color:"#fff"
                    text:qsTr("5分钟")
                    font.pixelSize:30
                    anchors.left: screenSlider.right
                    anchors.leftMargin:15
                    anchors.verticalCenter: parent.verticalCenter
                }
                PageDivider{
                    anchors.bottom: parent.bottom
                }
            }
            Button{
                id:time
                width: parent.width
                height: 100
                anchors.top: screen.bottom

                PageDivider{
                    anchors.bottom: parent.bottom
                }
                background:null
                Text{
                    text:"时间"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                }
                Text{
                    text:gTimeText
                    color:wifiConnected?"#fff":themesTextColor2
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 70
                }
                Image {
                    visible: wifiConnected == false
                    asynchronous:true
                    smooth:false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    source: themesPicturesPath+"icon_more.png"
                }
                onClicked: {
                    if(wifiConnected==false)
                        loaderManual.sourceComponent = pageClock
                }
            }
            Button{
                width: parent.width
                height: 100
                anchors.top: time.bottom

                PageDivider{
                    anchors.bottom: parent.bottom
                }
                background:null
                Text{
                    text:"屏保"
                    color:"#fff"
                    font.pixelSize: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left

                }
                Image {
                    asynchronous:true
                    smooth:false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 35
                    source: themesPicturesPath+"icon_more.png"
                }

                onClicked: {
                    localSet.visible=false
                    screen_saver.visible=true
                }
            }
        }
    }
    Item{
        id:screen_saver
        visible: false
        anchors.fill: parent
        Button {
            id:backBtn
            width:80
            height:40
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: grid.left
            background: Image{
                asynchronous:true
                smooth:false
                anchors.centerIn: parent
                source: themesPicturesPath+"back_button_background.png"
            }
            onClicked: {
                screen_saver.visible=false
                localSet.visible=true
            }
        }
        Text{
            anchors.left:backBtn.right
            anchors.verticalCenter: backBtn.verticalCenter
            color:"#fff"
            font.pixelSize: 30
            text: qsTr("屏保")
        }
        Grid{
            property int currentIndex:systemSettings.screenSaverIndex
            id:grid

            width: 418*2+columnSpacing
            height: 115*2+rowSpacing
            anchors.top: parent.top
            anchors.topMargin: 74
            anchors.horizontalCenter: parent.horizontalCenter
            rows: 2
            columns: 2
            rowSpacing: 18
            columnSpacing: 45
            Repeater {
                model: ["screen_saver0_narrow.png","screen_saver1_narrow.png","screen_saver2_narrow.png","screen_saver3_narrow.png"]
                Button{
                    width:418
                    height: 116
                    background: null
                    Image {
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+modelData
                    }
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        asynchronous:true
                        smooth:false
                        source: themesPicturesPath+(grid.currentIndex==index?"icon_checked.png":"icon_unchecked.png")
                    }
                    onClicked: {
                        systemSettings.screenSaverIndex=index
                    }
                }
            }
        }
    }
}

