#!/bin/bash

module=$1
item=$2
accesslog=$3
servicename=$4

if ! [ -x "$(command -v logtail)" ]; then
  echo 'Error: logtail is not installed. run "sudo apt install logtail"'
  exit 1
fi

function usage(){
        name=$(basename $0)
        echo "Nginx show 50x,40x errors count script, and optionaly restart some service."
        echo "${name} <type> <502|50x|40x> <path_to_logfile> <service name>"
        exit
}

function service_restart(){
        if [ -z ${servicename} ]; then
           echo "$errorresult"
           exit
        fi
        systemctl restart $servicename
        exit
}

if [ -z ${module} ]; then
        usage
fi

if [ ${module} == "type" ]; then
        if [ ${item} == "502" ]; then
                errorresult=`logtail -f $accesslog -o $accesslog.502.logtail | grep 'HTTP\/1\.." 502' | wc -l`
                [ "$errorresult" == "0" ] && echo 0 || service_restart
        elif [ ${item} == "50x" ]; then
                errorresult=`logtail -f $accesslog -o $accesslog.50x.logtail | grep 'HTTP\/1\.." 50.' | wc -l`
                [ "$errorresult" == "0" ] && echo 0 || service_restart
        elif [ ${item} == "40x" ]; then
                errorresult=`logtail -f $accesslog -o $accesslog.40x.logtail | grep 'HTTP\/1\.." 40.' | wc -l`
                [ "$errorresult" == "0" ] && echo 0 || service_restart
        fi
else 
        usage
fi

exit 0

