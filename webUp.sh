#!/bin/bash
##停止服务
APP_PATH=/opt/cc/OneBlog/blog-web/
APP_NAME=$APP_PATH"target/blog-web.jar"
GIT_URL=https://github.com/daphniscc/OneBlog
tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
if [ ${tpid} ]; then
    echo 'Stop Process...'
    kill -14 $tpid
fi
sleep 2
tpid=`ps -ef|grep $APP_NAME|grep -v grep|grep -v kill|awk '{print $2}'`
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
mvn -f $APP_PATH"pom.xml" clean package -Dmaven.test.skip=true
##运行服务
rm -f tpid

nohup java -Djava.security.egd=file:/dev/./urandom -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5051 -jar $APP_NAME --server.port=8443 > /dev/null 2>&1 >> ws.log &

echo $! > tpid

echo Start Success!