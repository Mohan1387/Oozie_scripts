#!/bin/bash
#
####################################
#
# Created by : Mohana kumar Manivannan
# Date : 29-10-2017
# Description : to run Oozie Exfilteration workflow and to export alerts to arcsight server
# 
####################################
export JAVA_HOME=/usr/java/jdk1.8.0_60
export PATH=$PATH:$JAVA_HOME/bin
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CLASSPATH=$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/
export PATH=$PATH:$HADOOP_CLASSPATH
export LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH

export HIVE_HOME=/usr/local/hive
export HIVE_CONF_DIR=$HIVE_HOME/conf
export HIVE_CLASS_PATH=$HIVE_CONF_DIR

export PATH=$PATH:$HIVE_HOME/bin
export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/native
#export CLASSPATH=$CLASSPATH:/usr/local/hive/lib
export HIVE_AUX_JARS_PATH=/usr/local/hive/lib
#export METASTORE_PORT=9084

export OOZIE_VERSION=4.3.0
export OOZIE_HOME=/usr/local/oozie
export PATH=$PATH:$OOZIE_HOME/bin

echo "calling Oozie job to run data Exfilter workflow"

oozie job -oozie http://localhost:11000/oozie -config /home/hduser/oozie_scripts/usecase_two/job.properties -run -D CURRENTDATE=$(date -d "-1 days"  +%Y-%m-%d) -D PRESENTDATE=$(date -d "-1 days"  +%Y%m%d) -D LIMITDATE=$(date -d "-8 days"  +%Y%m%d) -D ENDDATE=$(date -d "-7 days"  +%Y-%m-%d)

echo "Done Creating Aletrs"


#evdate=$(date -d "-1 days"  +%Y-%m-%d)
#evdateval=$(echo $evdate | sed 's/[\-]//g')
#folder=$(date -d "0 days"  +%Y%m%d)

#echo "Creating folder..."
#mkdir /home/hduser/Datapool/Exfilter/DataExfilter_user_outbytes/$folder"_user_outbytes"
#echo "folder Created."

#echo "Extracting Alerts..............."
#hive -e "select c.attacker_username,c.eventdate,c.destination_host_name,cast(c.totalout_bytes as BIGINT) as bytes_out from (select attacker_username,eventdate,destination_host_name,sum(url_bytes) as totalout_bytes from usecase_twodb.useroutbytes_above_threshold_url where eventdate = '$evdate' group by attacker_username,eventdate,destination_host_name) c where c.totalout_bytes > 10000000;" > /home/hduser/Datapool/Exfilter/DataExfilter_user_outbytes/$folder"_user_outbytes"/$evdateval"_Exfilteration_with_URL".tsv
#echo "Alerts Extracted."

#echo "Transfering Alerts to ArcSite syslogs02 ....."
#scp -r /home/hduser/Datapool/Exfilter/DataExfilter_user_outbytes/$(date -d "0 days" +"%Y%m%d")_"user_outbytes"/*_Exfilteration_with_URL.tsv smcadmin@meysocsyslog02:/home/smcadmin/BD_DataAnalytics/DataExfilter/Alerts
#echo "Done Transfering Alerts......"

