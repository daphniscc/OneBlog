#!/bin/bash
##停止服务
APP_PATH=/opt/cc/OneBlog/
APP_NAME_WEB=$APP_PATH"blog-web/target/blog-web-2.2.1.jar"
APP_NAME_ADMIN=$APP_PATH"blog-admin/target/blog-admin-2.2.1.jar"
GIT_URL=https://github.com/daphniscc/OneBlog
#停止web服务
tpid=`ps -ef|grep $APP_NAME_WEB|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop blog-web...'
    kill -14 $tpid
fi
sleep 2
tpid=`ps -ef|grep $APP_NAME_WEB|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Kill Process!'
    kill -9 $tpid
else
    echo 'Stop Success!'
fi
#停止后台服务
tpid2=`ps -ef|grep $APP_NAME_WEB|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop blog-web...'
    kill -14 $tpid
fi
sleep 2
tpid2=`ps -ef|grep $APP_NAME_WEB|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Kill Process!'
    kill -9 $tpid
else
    echo 'Stop Success!'
fi

##git更新
cd $APP_PATH
git pull

##maven编译部署
#cd $APP_PATH
#mvn -f $APP_PATH"pom.xml" clean package -Dmaven.test.skip=true
mvn clean
mvn install
##运行服务
rm -f tpid
rm -f tpid2

nohup java -Djava.security.egd=file:/dev/./urandom -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5051 -jar $APP_NAME_WEB --server.port=8443 > /dev/null 2>&1 >> ws.log &

echo $! > tpid

echo Start blog-web Success!

nohup java -Djava.security.egd=file:/dev/./urandom -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5052 -jar $APP_NAME_ADMIN --server.port=8085 > /dev/null 2>&1 >> ws.log &

echo $! > tpid

echo Start blog-admin Success!