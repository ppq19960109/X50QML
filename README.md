#X50BCZ UI
##安装
安装QT Creator,插件要选择qml相关的
##编译
###QT Creator交叉环境搭建
解压交叉编译工具链
1、
![qtgcc](qtgcc.png)
2、
![qtversion](qtversion.png)
3、
![qtkit](qtkit.png)
4、
编译目录下添加libqrencode二维码生成库
编译生成可执行文件X50QML
###运行程序
在X50QML同级目录下添加如下文件
1、recipes：菜谱图片
2、themes：UI显示需要本地图片
3、RecipesDetails.json：菜谱详情文件
4、SourceHanSansCN-Regular.ttf：字体文件