SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
SET mapred.output.compression.type=BLOCK;

INSERT INTO TABLE usecase_twodb.useroutbytes_above_threshold_url
select a.attacker_username,a.eventdate,'9999',b.destination_host_name,sum(b.bytes_out) as url_bytes
from usecase_twodb.user_outbytes_above_threshold a,
(select attacker_username,
substr(end_time,1,2) as eventhour,
substr(end_date,1,10) as eventdate,
bytes_in,
bytes_out,
request_method,
destination_host_name from masterlogdb.proxy
where dir = '${PRESENTDATE}'
and attacker_username != '-'
and request_method in ('POST','PUT')
and destination_host_name not in (select url_name from masterlogdb.whitelisted_url)) b
where a.attacker_username = b.attacker_username
and a.eventdate = b.eventdate
group by a.attacker_username,a.eventdate,b.destination_host_name;
