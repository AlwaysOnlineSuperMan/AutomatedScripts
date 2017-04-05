#!/bin/sh
#autho nings
#自动搭建Redis哨兵模式

#卸载Redis
./delColonyRedis.sh
RedisHome="/Software/colonyRedis"
redisPort=('2222' '3333' '4444')
currIp=$(ifconfig -a |grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d addr:)
echo 当前IP为: ${currIp}
#sentinelPort('26370','26371','26372')
RedisZipPackage="redis-3.2.5.tar.gz"
redisMasterPort="2222"
echo RedisHome $RedisHome
if [ ! -d  "${RedisHome}" ] ; then
   echo $RedisHome "不存在，正在创建...."
   mkdir -p $RedisHome
  else
     echo $RedisHome "已经存在"
fi
currSentinelPort=26370
for currRedisPort in ${redisPort[*]}
 do 
  currRedisHome=${RedisHome}"/Redis"${currRedisPort}
  if [ ! -d ${RedisHome}"/Redis"${currRedisPort} ] ; then
     echo $currRedisHome  "不存在，正在创建...."
     mkdir -p  $currRedisHome
  else
    echo $currRedisHome "已经存在"
  fi
  echo "cd " ${RedisHome}...
  cd $RedisHome
  echo "tar -zxvf" $RedisZipPackage  " --strip-components=1  -C Redis"${currRedisPort}
  tar -zxf $RedisZipPackage   --strip-components=1  -C "Redis"${currRedisPort} 
  cd ${RedisHome}"/Redis"${currRedisPort}
  echo "make && make install "
   make && make install 
   #Redis配置
   echo $currRedisHome Redsi config  配置
   echo 配置端口为 port $currRedisPort  
   sed -i 's/port 6379/port '${currRedisPort}'/g' redis.conf ##配置端口
   #grep -n 'port' redis.conf
   echo 注释bind 127.0.0.1
   sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/g' redis.conf
   echo 关闭保护模式 protected-mode no
   sed -i 's/protected-mode yes/protected-mode no/g' redis.conf
   echo 设置后台模式
   sed -i 's/daemonize no/daemonize yes/g'  redis.conf
   echo 设置进程文件 
   #sed -i 's/pidfile \/var\/run\/redis_6379.pid/pidfile \"'${currRedisHome}'\"\/redis_\"'${currRedisPort}'\"\/.pid/g' redis.conf
   sed -i 's/pidfile \/var\/run\/redis_6379.pid/pidfile nings.pid/g' redis.conf
   echo 设置日志文件  
   sed -i 's/logfile \"\"/logfile redis_'${currRedisPort}'.log/g' redis.conf
   echo 设置持久化文件名称
   sed -i 's/dbfilename dump.rdb/dbfilename dump-nings.rdb/g' redis.conf
   echo 默认dir 为当前文件夹下
   echo 设置密码
   sed -i 's/# requirepass foobared/requirepass  nings/g' redis.conf
   echo 打开key时效监听notify-keyspace-events Ex
   sed -i 's/#  notify-keyspace-events Ex/notify-keyspace-events Ex/g' redis.conf
   if [ "$currRedisPort" == "$redisMasterPort" ]; then
         echo redis 主的port:$currRedisPort  配置
    else
         echo redis 从的port:$currRedisPort  配置
         echo 配置从连接主密码  masterauth nings
         sed -i 's/# masterauth <master-password>/masterauth nings/g' redis.conf
         echo 配置从连接主 slaveof ${currIp} $redisMasterPort
         sed -i 's/# slaveof <masterip> <masterport>/slaveof '${currIp}'  '${redisMasterPort}'/g' redis.conf
    fi
    echo  $currRedisHome 启动redis实例
    ./src/redis-server redis.conf
    echo $currRedisHome 配置哨兵 
    echo Sentinel-port:$currSentinelPort
    sed -i 's/port 26379/port '${currSentinelPort}'/g' sentinel.conf  && let currSentinelPort=$currSentinelPort+1
    echo 设置台模式 守护进程  daemonize yes
    echo daemonize yes >> sentinel.conf
    echo  指明日志文件名 logfile "./sentinel.log"
    echo logfile "./sentinel.log" >> sentinel.conf
    echo 工作路径，注意路径不要和主重复 dir ./
    sed -i 's/dir \/tmp/dir .\//g' sentinel.conf 
    echo 哨兵监控的sentinel monitor mymaster ${currIp} ${redisMasterPort} （主从配置一样）
    #length=${#redisPort[@]}
    sed -i 's/sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster '${currIp}'  '${redisMasterPort}'  3/g'  sentinel.conf
    echo 配置连接主数据库密码sentinel auth-pass master-name  password 
    sed -i 's/# sentinel auth-pass <master-name> <password>/sentinel auth-pass mymaster nings/g'  sentinel.conf
    echo 关闭保护模式 protected-mode no
    sed -i 's/# protected-mode no/protected-mode no/g' sentinel.conf
    echo  $currRedisHome  启动哨兵 ....
    ./src/redis-sentinel sentinel.conf
done
