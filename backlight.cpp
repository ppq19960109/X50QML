#include "backlight.h"

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>

#define SYSFS_BL_DIR "/sys/devices/platform/backlight/backlight/backlight"
#define MAX_BUF 32

Backlight::Backlight()
{

}


/**
 * @brief backlightEnable屏背光-打开
 * 屏背光低有效
 */
int backlightEnable()
{
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
    return 0;
}

/**
* @brief backlightDisable屏背光－关闭
* 屏背光低有效
*/
int backlightDisable()
{
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
   return 0;
}

/**
 * @brief backlightConfig 设置背光亮度
 * @param value　亮度值0~255
 */
int backlightConfig(unsigned char value)
{
    int fd = -1;
    int data_size;
    char buf_brightness[MAX_BUF];

    data_size = snprintf(buf_brightness, sizeof(buf_brightness), "%d", value);
    fd = open(SYSFS_BL_DIR "/brightness", O_WRONLY);
    if (fd < 0)
    {
        perror("Open Backlight brightness Fail");
        return -1;
    }
    write(fd, buf_brightness, data_size);
    close(fd);
    return 0;
}

/**
 * @brief backlightGet 获取背光亮度
 * @return 　亮度值0~255
 */
int backlightGet()
{
    int fd = -1;
    char buff[3];
    int value = 200;//200为背光驱动初始值

    fd = open(SYSFS_BL_DIR "/brightness", O_RDONLY);
    if (fd < 0)
    {
        perror("Open Backlight brightness Fail");
        return -1;
    }
    read(fd, buff, sizeof(buff));
    close(fd);
    value = atoi(buff);
    return value;
}
