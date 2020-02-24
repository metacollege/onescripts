#!/bin/sh



if [ $# -ne 1 ]; then
  echo "在线安装docker-compose"
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
else
  FILETARGZ="$1"
fi

if [ ! -f ${FILETARGZ} ]; then
  echo "下载docker-compose"
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
else
  echo -e "\033[34m 开始安装 DOCKER-COMPOSE \033[0m"
  cp ${FILETARGZ} /usr/local/bin/docker-compose
fi

#add Execute
chmod +x /usr/local/bin/docker-compose

#testing
docker-compose --version

if [ $? -ne 0 ]; then
  echo -e "\033[31m DOCKER-COMPOSE安装失败 \033[0m"
  exit 1
else
  echo -e "\033[32m DOCKER-COMPOSE安装成功 \033[0m"
fi

echo ""