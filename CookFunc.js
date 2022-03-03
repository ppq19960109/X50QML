
function leftWorkModeFun(n)
{
    console.log("leftWorkModeFun",n)
    var mode
    switch(n)
    {
    case 1:
        mode=leftWorkMode[1]
        break
    case 2:
        mode=leftWorkMode[2]
        break
    case 35:
        mode=leftWorkMode[3]
        break
    case 36:
        mode=leftWorkMode[4]
        break
    case 38:
        mode=leftWorkMode[5]
        break
    case 40:
        mode=leftWorkMode[6]
        break
    case 42:
        mode=leftWorkMode[7]
        break
    case 72:
        mode=leftWorkMode[8]
        break
    default:
        mode=leftWorkMode[0]
        break
    }
    return mode
}
function leftWorkModeNumberFun(n)
{
    console.log("leftWorkModeFun",n)
    var mode
    switch(n)
    {
    case 1:
        mode=1
        break
    case 2:
        mode=2
        break
    case 35:
        mode=3
        break
    case 36:
        mode=4
        break
    case 38:
        mode=5
        break
    case 40:
        mode=6
        break
    case 42:
        mode=7
        break
    case 72:
        mode=8
        break
    default:
        mode=0
        break
    }
    return mode
}

function getDefHistory()
{
    var param = {}
    param.dishName=""
    param.imgUrl=""
    param.details=""
    param.cookSteps=""
    param.timestamp=Math.floor(Date.now()/1000) //Date.parse(new Date())//(new Date().getTime())
    param.collect=0
    param.cookType=0
    param.recipeType=0
    param.cookPos=0
    return param
}

function getDishName(root,cookPos)
{
    var dishName=""

    if(root[0].dishName !== undefined)
    {
        return root[0].dishName
    }

    for(var i = 0; i < root.length; i++)
    {
        console.log(root[i].mode,root[i].temp,root[i].time,leftWorkModeFun(root[i].mode))
        if(root.length===1 && root[i].number == null)
        {
            if(leftDevice===cookPos)
                dishName=leftWorkModeFun(root[i].mode)+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
            else
                dishName=rightWorkMode+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
        }
        else
        {
            dishName+=leftWorkModeFun(root[i].mode)
            if(i!==root.length-1)
                dishName+="-"
        }
    }
    return dishName
}
