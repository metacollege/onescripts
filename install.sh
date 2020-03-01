#!/usr/bin/env bash

set -e

OFFLINE_FLAG=
DOCKER_BIN_FILE_PATH=
DOCKER_COMPOSE_PATH=
IMAGE_PATH='./images'
INSTALL_FILE_PATH='./package'


#检查环境，是否是64位，是否是root用户
function precheck(){

#判断是否为root用户，弹出提示
if [ $USER == "root" -o $UID -eq 0 ]; then
	echo "$USER"
else
	echo "WARMING!! Not ROOT"
fi

#查看系统版本
#`cat  /etc/*release*`
echo "os is `uname -s`-`uname -m`"

}

function installDockerOnline(){

###############################################################################
#
#VARS INIT
#
###############################################################################


###############################################################################
#
#Confirm Env
#
###############################################################################
date
echo "## Install Preconfirm"
echo "## Uname"
uname -r
echo
echo "## OS bit"
getconf LONG_BIT
echo

###############################################################################
#
#INSTALL yum-utils
#
###############################################################################
date
echo "## Install begins : yum-utils"
yum install -y yum-utils >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Install ends   : yum-utils"
echo

###############################################################################
#
#Setting yum-config-manager
#
###############################################################################
echo "## Setting begins : yum-config-manager"
yum-config-manager \
   --add-repo \
   https://download.docker.com/linux/centos/docker-ce.repo >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : yum-config-manager"
echo

###############################################################################
#
#Update Package Cache
#
###############################################################################
echo "## Setting begins : Update package cache"
yum makecache fast >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : Update package cache"
echo

###############################################################################
#
#INSTALL Docker-engine
#
###############################################################################
date
echo "## Install begins : docker-ce"
yum install -y docker-ce
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Install ends   : docker-ce"
date
echo

###############################################################################
#
#Stop Firewalld
#
###############################################################################
echo "## Setting begins : stop firewall"
systemctl stop firewalld
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
systemctl disable firewalld
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : stop firewall"
echo

###############################################################################
#
#Clear Iptable rules
#
###############################################################################
echo "## Setting begins : clear iptable rules"
iptables -F
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : clear iptable rules"
echo

###############################################################################
#
#Enable docker
#
###############################################################################
echo "## Setting begins : systemctl enable docker"
systemctl enable docker
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : systemctl enable docker"
echo


###############################################################################
#
#start docker
#
###############################################################################
echo "## Setting begins : systemctl restart docker"
systemctl restart docker
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : systemctl restart docker"
echo


###############################################################################
#
#confirm docker version
#
###############################################################################
echo "## docker info"
docker info
echo

echo "## docker version"
docker version


}

function installDockerOffline(){

echo -e "\033[34m 开始安装 DOCKER... \033[0m"
SYSTEMDDIR=/usr/lib/systemd/system
SERVICEFILE=docker.service
DOCKERDIR=/usr/bin
DOCKERBIN=docker
SERVICENAME=docker
if [ $# -ne 1 ]; then
echo "param error"
exit 1
else
FILETARGZ="$1"
fi

if [ ! -f ${FILETARGZ} ]; then
echo "Docker binary tgz files does not exist, please check it"
echo "Get docker-ce binary from: https://download.docker.com/linux/static/stable/x86_64/"
echo "eg: wget https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz"
exit 1
fi

echo "##unzip : tar xvpf ${FILETARGZ}"
tar xvpf ${FILETARGZ}
echo

echo "##binary : ${DOCKERBIN} copy to ${DOCKERDIR}"
cp -p ${DOCKERBIN}/* ${DOCKERDIR} >/dev/null 2>&1
which ${DOCKERBIN}

echo "##systemd service: ${SERVICEFILE}"
echo "##docker.service: create docker systemd file"
cat >${SYSTEMDDIR}/${SERVICEFILE} <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
[Service]
Type=notify
EnvironmentFile=-/run/flannel/docker
WorkingDirectory=/usr/local/bin
ExecStart=/usr/bin/dockerd \
				-H tcp://0.0.0.0:4243 \
				-H unix:///var/run/docker.sock \
				--selinux-enabled=false \
				--log-opt max-size=1g
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target

EOF

echo ""

systemctl daemon-reload
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}
echo "##Service restart: ${SERVICENAME}"
systemctl restart ${SERVICENAME}
echo "##Service status: ${SERVICENAME}"
systemctl status ${SERVICENAME}

echo "##Service enabled: ${SERVICENAME}"
systemctl enable ${SERVICENAME}

echo "## docker version"
docker version

if [ $? -ne 0 ]; then
echo -e "\033[31m DOCKER安装失败 \033[0m"
exit 1
else
echo -e "\033[32m DOCKER安装成功 \033[0m"
fi
}

function installDockerCompose(){
	if [ $# -ne 1 ]; then
	echo "在线安装docker-compose"
	curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
	else
	FILETARGZ="$1"
		if [ ! -f ${FILETARGZ} ]; then
		echo "下载docker-compose"
		curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
		else
		echo -e "\033[34m 开始安装 DOCKER-COMPOSE \033[0m"
		cp ${FILETARGZ} /usr/local/bin/docker-compose
		fi
	fi

	chmod +x /usr/local/bin/docker-compose

	docker-compose --version

	if [ $? -ne 0 ]; then
	echo -e "\033[31m DOCKER-COMPOSE安装失败 \033[0m"
	exit 1
	else
	echo -e "\033[32m DOCKER-COMPOSE安装成功 \033[0m"
	fi

	echo ""
}

function findDocker(){
        if [[ $# -eq 1  &&  -d "$1" ]]; then
        DOCKER_BIN_FILE_PATH=`find $1 -name "docker*.tgz" | sed -n '1p'`
		fi
}
function findDockerCompose(){
        if [[ $# -eq 1  &&  -d "$1" ]]; then
        DOCKER_COMPOSE_PATH=` find $1 -name "docker-compose*"|sed -n '1p'`
		fi
}

function loadImages(){
        if [[ $# -eq 1  &&  -d "$1" ]]; then
         images=`find $1 -name "*.tar"`
          for im in $images;do
           docker load -i $im
		   echo "Import $im succeed!"
          done
		elif [[ $# -eq 1  &&  -f "$1" ]]; then
         docker load -i $1
		fi
}
function printHelp(){
	echo "Welcome to OneScripts"
	echo "-o online mode , install DOCKER from internet"
	echo "-f offline mode [default use package/]"
	echo "-d docker bin tgz filepath [default use one in package/]"
	echo "-c docker-compose bin filepath [default use one in package/]"
	echo "-i docker images foundpath [default use images/]"
	echo ""
	echo "eg. sh install.sh -d package/docker-19.05.tgz -c package/docker-compose-X86_64 -i images/  "
	echo "eg. sh install.sh -o -i"
	echo "eg. sh install.sh -f -i images/nginx.tar"
	echo ""
}

precheck

while getopts "h?fd:c:i:os" opt; do
  case "$opt" in
  h | \?)
    printHelp
	exit 0
	;;
   o)
    OFFLINE_FLAG=0
	;;
  f)
    OFFLINE_FLAG=1
	;;
  d)
    OFFLINE_FLAG=1  
	DOCKER_BIN_FILE_PATH=$OPTARG
	;;
  c)
    OFFLINE_FLAG=1
    DOCKER_COMPOSE_PATH=$OPTARG
	;;
  i)
	IMAGE_PATH=$OPTARG
  ;;
  esac
done
    
if [ -z $OFFLINE_FLAG  ];then
echo "no install"
elif [ "$OFFLINE_FLAG" == "0" ];then
  echo "online install"
  installDockerOnline
  installDockerCompose
elif [ "$OFFLINE_FLAG" == "1" ];then
  if [ -z $DOCKER_BIN_FILE_PATH ];then
    findDocker $INSTALL_FILE_PATH
  fi
  if [ -z $DOCKER_COMPOSE_PATH ];then
    findDockerCompose $INSTALL_FILE_PATH	
  fi
  echo "offline install"
  installDockerOffline $DOCKER_BIN_FILE_PATH
  installDockerCompose $DOCKER_COMPOSE_PATH
fi

if [ ! -z $IMAGE_PATH ];then
  echo "load image..."
  loadImages $IMAGE_PATH
  docker images
  echo "load images finish!"
fi
echo -e "\033[32m 安装成功 \033[0m"
exit 0


