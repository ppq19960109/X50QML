import QtQuick 2.2
import QtQuick.Controls 2.2

Item {
    //判断儿童锁(true表示锁定，false表示未锁定)
    property bool childLock:false

    property int childLockPressCount:0

    visible: true
//    width: parent.width
//    height: parent.height
//    anchors.fill: parent
    ToolBar {
        id:topBar
        width:parent.width
        anchors.top:parent.top
        height:96
        Image {
            anchors.fill: parent
            source: "images/main_menu/zhuangtai_bj.png"
        }
        //wifi图标
        TabButton {
            id:wifi
            width:130
            height:parent.height
            anchors.left:parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image{
                anchors.centerIn: parent
                source: "images/wifi/wifi.png"
            }
            background: Rectangle {
                opacity: 0
            }
            onClicked: {
                console.log("TabButton wifi")
                //                    mystackview.push(setting_page_network,StackView.Immediate)
            }
        }
        //闹钟图标
        Rectangle{
            id:alarmClock
            width:120
            height:parent.height
            anchors.left:wifi.right
            anchors.verticalCenter: parent.verticalCenter
            color:"transparent"
            visible: true
            Image{
                anchors.centerIn: parent
                source: "images/main_menu/naozhong.png"
            }
        }
        //时间展示
        Text{
            id:currentTime
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: fontSize
            color:"#9BABC2"
            text:getCurtime()

            //时间Timer
            Timer {
                interval: 30000
                running: true
                repeat: true
                onTriggered: {
                    currentTime.text = getCurtime()//此处即是让时间显示到文本中去
                }
            }
        }

        //水箱问题
        Rectangle{
            id:waterTank
            width:80
            height:parent.height
            anchors.right:childLockBtn.left
            color:"transparent"
            visible: true

            Image{
                anchors.centerIn: parent
                source: "images/main_menu/queshuitubiao.png"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("click waterTank")
                }
            }
        }

        //童锁按钮
        TabButton{

            id:childLockBtn
            width:105
            height:parent.height
            anchors.right:parent.right
            background:Rectangle{
                color:"transparent"
                Image{
                    anchors.right:parent.right
                    anchors.rightMargin: 50
                    anchors.verticalCenter: parent.verticalCenter
                    source: childLock ?"images/main_menu/tongsuokai_sz.png" : "images/main_menu/tongsuokai.png"
                }

            }

            Timer {
                id: longPressTimer
                interval: 1000
                repeat: true
                running: false

                onTriggered: {
                    ++childLockPressCount
                    console.log("childLockPressCount:"+childLockPressCount)
                }
            }

            onPressedChanged: {
                if (pressed) {
                    if(childLock == false)
                    {
                        childLockPressCount = 0
                        longPressTimer.running = true
                    }
                }
                else
                {
                    if(childLock == false)
                    {
                        longPressTimer.running = false
                        if(childLockPressCount < 2){
                            console.log("请长按童锁键启用童锁")
                        }
                        else
                        {
                            longPressTimer.running = false
                            childLock=true
                            console.log("童锁键启用")
                        }
                    }
                    else
                    {
                        console.log("取消童锁")
                        childLock=false
                    }
                }
            }
        }
    }

    Rectangle{
        width:parent.width
        anchors.top:topBar.bottom
        anchors.bottom: parent.bottom
        color:"#000"

        Image {
            id:botImg
            width:parent.width
            source: "images/main_menu/dibuyuans.png"
            anchors.bottom:parent.bottom
        }

        SwipeView {
            id: swipeview
            currentIndex:0
            width:parent.width

            interactive:true //是否可以滑动
            anchors.top:parent.top
            anchors.bottom: botImg.top
            Item {
                PageHomeFirst{}
            }
            Item {
                PageHomeSecond{}
            }
            Item {
                PageHomeThird{}
            }
        }

        PageIndicator {
            count: swipeview.count
            currentIndex: swipeview.currentIndex
            anchors.top: botImg.top
//            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            interactive: true
            delegate: Image {
                source:index===swipeview.currentIndex
                       ?"images/main_menu/user_active"+index+".png":"images/main_menu/user_normal"+index+".png"
                anchors.verticalCenter:parent.verticalCenter
            }
        }

    }
}
