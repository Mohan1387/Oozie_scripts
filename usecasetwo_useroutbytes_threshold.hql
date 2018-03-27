DROP TABLE IF EXISTS usecase_twodb.user_outbytes_above_threshold;

SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
SET mapred.output.compression.type=BLOCK;

create table usecase_twodb.user_outbytes_above_threshold as
select a.attacker_username,a.eventtime,a.bytes,a.eventdate
from usecase_twodb.user_out_bytes a,(select cast(sqrt(variance(bytes))*2+percentile(cast(bytes as bigint),0.5) as double) as threshold from usecase_twodb.user_out_bytes) b
where a.bytes > b.threshold and 
a.eventdate = '${CURRENTDATE}';

