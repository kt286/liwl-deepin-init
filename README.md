# 1. 关于mydeepin
不是deepin折腾我，就是我折腾deepin。

《我的deepin变形记》是我折腾deepin的经验。它主要应用在新安装或者重新安装操作系统以后，根据个人使用习惯与爱好需要做的个性化环境部署。

按照《我的deepin变形记》指导方针一步一步做肯定没错，比做什么都不清楚要节省很多时间。

但是相对于自动化部署来说，还是太慢了。于是我整了这个一键变形，以后折腾就不用那么慢了，前后20分钟左右(主要看网络给力不给力了)就可以使用了。

很多操作也在继续学习和探索之中，目前的版本在全新安装的20.5中能够工作正常。

# 2. 已经完成的工作
1. 系统瘦身(自带应用卸载，壁纸屏保卸载，多余主题，图片删除)
2. 微软雅黑,Consolas字体安装,更换
3. 桌面壁纸，背景图片，用户图像更换，锁屏界面字体更换
4. fcitx5安装，配置
5. 常用应用安装(Edge浏览器，微信，WPS，网易云音乐，坚果云，百度网盘，为知笔记，Typora编辑器，vscode)
6. 自编译的deepin-terminal替换
7. 右键新建Markdown模板
8. 控制中心调整(电源，圆角，字体，主题，快捷键)
9. 任务栏调整(启动器，托盘显隐，驻留应用，日期格式)
10. 引导界面无主题无延迟(注意双系统时这个不会显示windows系统)

# 3. 还未完成的工作
1. 右键发送到(博客园，为知笔记，语雀)
2. 终端光标下划线样式加粗
3. 文件管理器的设置

# 4. 使用方式
下载zip文件，解压到mydeepin;
+ cd mydeepin;
+ python3 init.py (交互执行)
+ python3 init.py y (非交互执行)
