#!/bin/sh
#author nings 
#删除文件夹
RedisHome="/Software/colonyRedis"
if [ ! -d  "${RedisHome}" ] ; then
   echo $RedisHome "不存在，正在创建...."
   exit
  else
     echo cd $RedisHome ...
      cd $RedisHome
      redisPort=('2222' '3333' '4444')
      for currRedisPort in ${redisPort[*]}
      do 
      currRedisHome=${RedisHome}"/Redis"${currRedisPort}
       if [ ! -d ${RedisHome}"/Redis"${currRedisPort} ] ; then
           echo $currRedisHome  "不存在，无法删除！"
           
         else
               echo "rm -rf " $currRedisHome ...
               rm -rf "Redis"${currRedisPort}
       fi
 done
fi
