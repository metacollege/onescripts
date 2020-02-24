#!/bin/bash

function set_docker_env(){
echo "修改daemon.json"
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://upnh1630.mirror.aliyuncs.com"]
}
EOF
echo "重启docker.service"
systemctl restart docker.service

}

set_docker_env