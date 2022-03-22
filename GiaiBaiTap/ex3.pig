%declare INPUT_PATH 'hdfs:/Pig_Data/100linee.txt';
%declare OUTPUT_PATH 'hdfs:/Pig_Data/user/hadoopanhdac/output/ex3/';

RAW_DATA = LOAD '$INPUT_PATH'
        AS (ts:long, sport, dport, sip, dip,
                l3proto, l4proto, flags,
                phypkt, netpkt, overhead,
                phybyte, netbyte:long);


DATA = FOREACH RAW_DATA GENERATE sip, dip, netbyte;

DATA_UP = GROUP DATA BY sip;
FLOW_UP = FOREACH DATA_UP GENERATE group as id_up, SUM(DATA.netbyte) as upload;
DATA_DOWN = GROUP DATA BY dip;
FLOW_DOWN = FOREACH DATA_DOWN GENERATE group as id_down, SUM(DATA.netbyte) as download;

FLOW_JOIN = JOIN FLOW_UP by id_up FULL, FLOW_DOWN by id_down;

SUMMARY = FOREACH FLOW_JOIN GENERATE 
	(id_up is null?id_down:id_up) AS IP,
	(upload is null?0:upload) as upload,
	(download is null?0:download) as download,
	((upload is null?0:upload)+(download is null?0:download)) as total;


STORE SUMMARY INTO '$OUTPUT_PATH';

