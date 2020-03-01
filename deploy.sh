#!/usr/bin/env bash

source ./scripts/utils.sh

function naviBar() {
	show
	read -p "please choose  " ans
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
	echo "install JDK+maven"
	;;

	j | jdk)
	echo "install JDK"
	;;

	i | import)
	echo "import images"
	;;
	f | fabric)
	echo "install fabric"
	install_fabric
	;;
	exit | q)
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
	blue "$USER"
else
	byellow "WARMING!! Not ROOT"
fi

#查看系统版本
#`cat  /etc/*release*`
byellow "os is `uname -s`-`uname -m`"

}


#一键安装docker和docker compose
function install_dockerall(){
	
	showonline
	read -p "please choose  " ans
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
	read -p "please choose  " ans
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
	echo -e "\033[33m files not found... \033[0m"
	install_docker
	else
	echo -e "\033[34m begin install process... \033[0m"
	source ./scripts/install_docker_offline.sh $ans
	fi
	;;
	esac
}
#安装compose
function install_compose(){

	showonline
	read -p "please choose  " ans
	case "$ans" in
	on | o)
	source ./scripts/install_docker-compose.sh
	;;
	off | f)
	source ./scripts/install_docker-compose.sh ./docker/docker-compose-Linux-x86_64
	;;
	b | back)
	naviBar
	;;
	*)
	if [ ! -f $ans ]; then
	byellow "option or file not found... "
	install_compose
	else
	green "begin install process..."
	source ./scripts/install_docker-compose.sh  $ans
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
	echo -e "\033[34m please choose \033[0m"
	echo "【 o 】 online install"
	echo "【 f 】 offline install"
	echo "【 b 】 back"
}

function show(){
	echo -e "\033[34m please choose \033[0m"
	echo "【 a 】 all-in-one"
	echo "【 d 】 install docker"
	echo "【 c 】 install docker-compose"
	echo "【 e 】 environment"
	echo "【 m 】 install JDK+maven"
	echo "【 j 】 install JDK"
	echo "【 i 】 import images"
	red "【 exit 】exit"
}

precheck
naviBar


green "install success"
exit 0


