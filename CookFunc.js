
function leftWorkModeFun(n)
{
    //    console.log("leftWorkModeFun",n)
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
    case 100:
        mode=leftWorkMode[9]
        break
    case 120:
        mode=leftWorkMode[10]
        break
    case 121:
        mode=leftWorkMode[11]
        break
    default:
        mode=leftWorkMode[0]
        break
    }
    return mode
}
function leftWorkModeNumberFun(n)
{
    //    console.log("leftWorkModeFun",n)
    var mode
    switch(n)
    {
    case 1:
        mode=1
        break
    case 2:
        mode=2
        break
    case 40:
        mode=3
        break
    case 42:
        mode=4
        break
    case 35:
        mode=5
        break
    case 38:
        mode=6
        break
    case 36:
        mode=7
        break
    case 72:
        mode=8
        break
    case 100:
        mode=9
        break
    case 120:
        mode=10
        break
    case 121:
        mode=11
        break
    default:
        mode=0
        break
    }
    return mode
}

function getCookType(cookSteps)
{
    var root=JSON.parse(cookSteps)
    if(root.length>1)
        return 2
    if(root[0].mode==1||root[0].mode==2)
        return 0
    return 1;
}
function getDefHistory()
{
    var param = {}
    param.dishName=""
    param.cookSteps=""
    param.timestamp=Math.floor(Date.now()/1000) //Date.parse(new Date())//(new Date().getTime())
    param.collect=0
    param.recipeid=0
    param.recipeType=0
    param.cookPos=0
    param.orderTime=0
    return param
}
function isSteam(cookSteps)
{
    for(var i = 0; i < cookSteps.length; i++)
    {
        if(cookSteps[i].mode==1||cookSteps[i].mode==2||cookSteps[i].mode==40)
        {
            return 1
        }
    }
    return 0
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
            dishName=leftWorkModeFun(root[i].mode)+"-"+root[i].temp+"℃-"+root[i].time+"分钟"
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
