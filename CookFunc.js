
function workModeName(mode)
{
    let name
    switch(mode)
    {
    case 1:
        name=workModeEnum[1]
        break
    case 3:
        name=workModeEnum[2]
        break
    case 4:
        name=workModeEnum[3]
        break
    case 35:
        name=workModeEnum[4]
        break
    case 36:
        name=workModeEnum[5]
        break
    case 38:
        name=workModeEnum[6]
        break
    case 40:
        name=workModeEnum[7]
        break
    case 42:
        name=workModeEnum[8]
        break
    case 65:
        name=workModeEnum[9]
        break
    case 66:
        name=workModeEnum[10]
        break
    case 68:
        name=workModeEnum[11]
        break
    case 120:
        name=workModeEnum[12]
        break
    default:
        name=workModeEnum[0]
        break
    }
    return name
}
function leftWorkModeToIndex(mode)
{
    let index
    switch(mode)
    {
    case 40:
        index=0
        break
    case 35:
        index=1
        break
    case 42:
        index=2
        break
    case 4:
        index=3
        break
    case 36:
        index=4
        break
    case 38:
        index=5
        break
    default:
        index=mode
        break
    }
    return index
}
function getWorkModeModel(mode)
{
    let modeModel
    switch(mode)
    {
    case 1:
        modeModel=rightWorkModeModelEnum[0]
        break
    case 3:
        modeModel=rightWorkModeModelEnum[2]
        break
    case 4:
        modeModel=rightWorkModeModelEnum[1]
        break
    case 65:
        modeModel=rightAssistWorkModeModelEnum[1]
        break
    case 66:
        modeModel=rightAssistWorkModeModelEnum[0]
        break
    case 68:
        modeModel=rightAssistWorkModeModelEnum[2]
        break
    case 120:
        modeModel=rightAssistWorkModeModelEnum[3]
        break
    default:
        modeModel=rightWorkModeModelEnum[0]
        break
    }
    return modeModel
}
function getCookTimeIndex(time)
{
    if(time <= 120)
    {
        return time-1
    }
    else
    {
        return (time - 120)/5+120-1
    }
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
function getDefCookItem()
{
    var cookItem = {}
    cookItem.dishName=""
    cookItem.cookSteps=""
    cookItem.recipeid=0
    cookItem.cookPos=0
    cookItem.orderTime=0
    return cookItem
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
    var step
    for(var i = 0; i < cookSteps.length; ++i)
    {
        step=cookSteps[i]
        if(step.mode===1||step.mode===3||step.mode===4||step.mode===65||step.mode===66||step.mode===68||step.mode===120)
        {
           return 1
        }
    }
    return 0
}
function getDishName(root)
{
    var dishName=""
    if(root[0].dishName !== undefined)
    {
        return root[0].dishName
    }
    var step
    for(var i = 0; i < root.length; ++i)
    {
        step=root[i]
//        console.log(step.mode,step.temp,step.time,workModeName(step.mode))
        if(root.length===1 && step.number == null)
        {
            dishName=workModeName(step.mode)+"-"+step.temp+"℃-"+step.time+"分钟"
        }
        else
        {
            dishName+=workModeName(step.mode)
            if(i!==root.length-1)
                dishName+="-"
        }
    }
    return dishName
}
