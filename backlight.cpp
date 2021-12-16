#include "backlight.h"

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>

#define SYSFS_BL_DIR "/sys/devices/platform/backlight/backlight/backlight"

Backlight::Backlight(QObject *parent) : QObject(parent)
{

}


/**
 * @brief backlightEnable屏背光-打开
 * 屏背光低有效
 */
int Backlight::backlightEnable()
{
    printf("backlightEnable\n");
#ifdef USE_RK3308
    int fd = -1;
    fd = open(SYSFS_BL_DIR "/bl_power", O_WRONLY);
    if (fd < 0)
    {
        perror("Open Backlight bl_power Fail");
        return -1;
    }
    printf("Lcd Backlight Open\n");
    write(fd, "0", 2);
    close(fd);
#endif
    return 0;
}

/**
* @brief backlightDisable屏背光－关闭
* 屏背光低有效
*/
int Backlight::backlightDisable()
{
    printf("backlightDisable\n");
#ifdef USE_RK3308
    int fd = -1;
    fd = open(SYSFS_BL_DIR "/bl_power", O_WRONLY);
    if (fd < 0)
    {
        perror("Open Backlight bl_power Fail");
        return -1;
    }
    printf("Lcd Backlight Close\n");
    write(fd, "1", 2);
    close(fd);
#endif
    return 0;
}

/**
 * @brief backlightConfig 设置背光亮度
 * @param value　亮度值0~255
 */
int Backlight::backlightSet(unsigned char value)
{
    printf("backlightSet\n");
#ifdef USE_RK3308
    int fd = -1;
    char buf[8]={0};

    sprintf(buf, "%d", value);
    fd = open(SYSFS_BL_DIR "/brightness", O_WRONLY);
    if (fd < 0)
    {
        perror("Open Backlight brightness Fail");
        return -1;
    }
    write(fd, buf, strlen(buf));
    close(fd);
#endif
    return 0;
}

/**
 * @brief backlightGet 获取背光亮度
 * @return 　亮度值0~255
 */
int Backlight::backlightGet()
{
    printf("backlightGet\n");
    int value = 200;//200为背光驱动初始值
#ifdef USE_RK3308
    int fd = -1;
    char buf[8]={0};

    fd = open(SYSFS_BL_DIR "/brightness", O_RDONLY);
    if (fd < 0)
    {
        perror("Open Backlight brightness Fail");
        return -1;
    }
    read(fd, buf, sizeof(buf));
    close(fd);
    value = atoi(buf);
#endif
    return value;
}

QVariantList Backlight::getAllFileName(QString path)
{
    QVariantList pathList;
//    QDir *dir=new QDir(path);
    QDir dir(path);
    QStringList filter;
    QList<QFileInfo> *fileInfo=new QList<QFileInfo>(dir.entryInfoList(filter));
    for(int i = 0;i<fileInfo->count(); ++i)
    {
        const QFileInfo info_tmp = fileInfo->at(i);
        QString path_tmp = info_tmp.filePath();
        if( info_tmp.fileName()==".." || info_tmp.fileName()=="." )
        {
        }else if(info_tmp.isFile() ){
            pathList.append(path_tmp);
        }else if(info_tmp.isDir()){
            pathList.append(getAllFileName(path_tmp));
        }
    }
    qDebug() << "getAllFileName:" <<pathList << "size:" << pathList.size() <<endl;
    return pathList;
}

