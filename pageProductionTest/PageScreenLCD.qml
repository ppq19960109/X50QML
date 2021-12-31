import QtQuick 2.2
import QtQuick.Controls 2.2

Button {
    property int step: 0
    background:Rectangle{
        id:bg
        color:"red"
    }
    onClicked: {
        console.log("color:",bg.color)
        if(step==0)
        {
            step=1
            bg.color="green"
        }
        else if(step==1)
        {
            step=2
            bg.color="blue"
        }
        else if(step==2)
        {
            backPrePage()
        }
    }
}
