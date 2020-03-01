# discuz

- ```
  wget  http://ahdx.down.chinaz.com/201712/Discuz_X3.4_SC_UTF8_0101.zip
  ```
- ```
  unzip
  ```
- ```
  docker-compose -f docker-compose-discuz.yml up -d --build
  ```
注意，docker-compose.yml中的volumes跟dockerfile中有冲突，使用时先注释掉。
安装过程中配置数据库： db：3306
  
