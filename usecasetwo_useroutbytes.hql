TRUNCATE TABLE usecase_twodb.user_out_bytes;

SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
SET mapred.output.compression.type=BLOCK;
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
INSERT into TABLE  usecase_twodb.User_out_bytes PARTITION(eventdate) 
select a.attacker_username,
a.eventtime,
sum(a.bytes_out) as bytes,
a.eventdate
from
(select attacker_username,
substr(end_date,1,10) as eventdate,
substr(end_time,1,2) as eventtime,
destination_host_name,
bytes_out
from masterlogdb.proxy 
where attacker_username != '-' and
substr(end_date,1,10) > '${ENDDATE}' and
dir > '${LIMITDATE}' and
request_method in ('PUT','POST') and
destination_host_name not in (select url_name from masterlogdb.whitelisted_url)) a
group by a.attacker_username,
a.eventdate,
a.eventtime;
