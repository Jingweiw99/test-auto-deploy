#!/bin/sh
#记事本打开，修改编码格式为utf8，可解决上传centos后中文乱码问题
echo =================================
echo  自动化部署脚本启动
echo =================================

echo 停止原来运行中的工程
APP_NAME=springboot_hello
# 查询系统中正在运行的helloworld的进程，并停止进程
tpid=`ps -aux|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop Process...'
    kill -15 $tpid
fi
sleep 2
tpid=`ps -aux|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
# 停止后再次查询，如果还存在，则通过kill -9 强制杀死
if [ ${tpid} ]; then
    echo 'Kill Process!'
    kill -9 $tpid
else
    echo 'Stop Success!'
fi

echo 准备从Git仓库拉取最新代码
cd /usr/local/soft/test-auto-deploy

echo 开始从Git仓库拉取最新代码
# 拉取最新代码
git pull
echo 代码拉取完成

echo 开始打包
# 执行打包，跳过单元测试
output=`mvn clean package -Dmaven.test.skip=true`
# 切换到当前工程的target目录下
cd target

echo 启动项目
# 后台启动该项目
nohup java -jar helloWorld.jar &> helloWorld.log &
echo 项目启动完成
