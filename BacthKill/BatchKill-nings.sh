#!/bin/sh
#author nings 
#批量关闭进程
echo "------------command: ps -ef|grep $1-----------begin------------------"
ps -ef|grep $1
echo "------------command: ps -ef|grep $1-----------end------------------"

echo "------------command: ps -ef|grep $1|grep -v 'grep'|awk '{print $2}'-----------begin------------"
PID=$(ps -ef|grep $1|grep -v "grep"|awk '{print $2}')
echo  "PIDS:"
echo   $PID
echo "------------command: ps -ef|grep $1|grep -v 'grep'|awk '{print $2}'-----------begin------------"
echo "input is  Kill All PIDS or Kill Option PIDS(a:All o:Option)"
read isOption
if [ "${isOption}" = "a" ] ; then
      echo "Kill All Begin......"
  for id in $PID
     do
		 kill -9 $id
		 echo "is killing $id"
         done
  echo "Kill All End......"
else 
	echo "Kill Option Begin......"
 	for id in $PID
       do
               echo "is killing $id （y on n ?）"
	        read isKill
               if [ "${isKill}" = "y" ] ;
                 then
				 kill -9 $id
                  	echo "is killing $id..OK"
                  else
			echo "not is Kill $id"
                 fi
            done
		echo "Kill Option End......"
fi
