#!/usr/bin/env bash

###!/bin/bash
source ./scripts/utils.sh

function naviBar() {
	show
	read -p "请选择  " ans
	case "$ans" in
	a | all)
	install_dockerall
	;;
	d | docker)
	install_docker
	;;
	c | docker-compose)
	install_compose
	;;
	e | enviroment)
	set_env
	;;
	m | maven)
	echo "安装JDK+maven"
	;;

	j | jdk)
	echo "安装JDK"
	;;

	i | import)
	echo "导入镜像"
	;;
	f | fabric)
	echo "安装fabric"
	install_fabric
	;;
	exit)
	echo "exiting..."
	exit 1
	;;
	*)
	naviBar
	;;
	esac
}

#检查环境，是否是64位，是否是root用户
function precheck(){

#判断是否为root用户，弹出提示
if [ $USER == "root" -o $UID -eq 0 ]; then
	echo "$USER"
else
    echo -e "\033[35m WARMING！！此用户非root用户，安装可能会失败！！\033[0m"
fi

#查看系统版本
#`cat  /etc/*release*`
byellow "操作系统为`uname -s`-`uname -m`"

}


#一键安装docker和docker compose
function install_dockerall(){
	
	showonline
	read -p "请选择  " ans
	case "$ans" in
	on | o)
	source ./scripts/install_docker_online.sh
	source ./scripts/install_docker-compose.sh
	;;
	off | f)
	source ./scripts/install_docker_offline.sh ./docker/docker-19.03.5.tgz
	source ./scripts/install_docker-compose.sh ./docker/docker-compose-Linux-x86_64
	;;
	*)
	naviBar
	;;
	esac
}

#安装docker
function install_docker(){

	showonline
	read -p "请选择  " ans
	case "$ans" in
	on | o)
	source ./scripts/install_docker_online.sh
	;;
	off | f)
	source ./scripts/install_docker_offline.sh ./docker/docker-19.03.5.tgz
	;;
	b | back)
	naviBar
	;;
	*)
	if [ ! -f $ans ]; then
	echo -e "\033[33m 选项或文件未找到，请重新输入... \033[0m"
	install_docker
	else
	echo -e "\033[34m 找到文件，启动安装... \033[0m"
	source ./scripts/install_docker_offline.sh $ans
	fi
	;;
	esac
}
#安装compose
function install_compose(){

	showonline
	read -p "请选择  " ans
	case "$ans" in
	on | o)
	source ./scripts/install-docker-compose.sh
	;;
	off | f)
	source ./scripts/install-docker-compose.sh ./docker/docker-compose-Linux-x86_64
	;;
	b | back)
	naviBar
	;;
	*)
	if [ ! -f $ans ]; then
	byellow "选项或文件未找到，请重新输入... "
	install_compose
	else
	green "找到文件，启动安装..."
	source ./scripts/install-docker-compose.sh  $ans
	fi
	;;
	esac
}

function install_fabric(){
	source ./scripts/install_fabric.sh
}

#配置docker阿里镜像
function set_env(){
	source ./scripts/set_docker_repository.sh

}

function showonline(){
	echo -e "\033[34m 请选择安装方式 \033[0m"
	echo "【 o 】 在线安装"
	echo "【 f 】 离线安装"
	echo "【 b 】 返回"
}

function show(){
	echo -e "\033[34m 请选择安装方式 \033[0m"
	echo "【 a 】 一键安装"
	echo "【 d 】 安装docker"
	echo "【 c 】 安装docker-compose"
	echo "【 e 】 配置必要环境"
	echo "【 m 】 安装JDK+maven"
	echo "【 j 】 安装JDK"
	echo "【 i 】 导入镜像"
	red "【 exit 】退出"
}

precheck
naviBar


green "成功"
exit 0


