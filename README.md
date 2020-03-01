# Overall
一些脚本程序，方便使用，不断补充中

目前，本项目主要面向docker进行，不断使用各种感兴趣的东西，目前包括

- docker的安装
- docker-compose的安装
- wordpress的docker-compose文件

## Docker安装脚本install的使用方法

```
cd onescripts/
sh install.sh

eg. sh install.sh -o
eg. sh install.sh -f
eg. sh install.sh -d XXXX/xxxx.tgz -c XXXX/bbbb -i XXX/
eg. sh -i XXXX/yyyy.tar

可用参数如下:
-o ：在线安装docker及docker-compose，暂不可指定版本
-f ：离线安装docker及docker-compose，默认加载./package/目录下的docker-**.**.tgz文件和docker-compose-***文件
-d ：离线安装docker，指定docker安装文件路径，默认同上
-c ：离线安装docker-compose，指定docker-compose安装文件路径，默认同上
-i ：docker images加载目录或文件路径，默认为./images/文件夹下所有*.tar文件
-h ：帮助

```
注意事项：因为脚本的相对路径，所以尽量cd到onescritps目录下。


# 欢迎大家拍砖
