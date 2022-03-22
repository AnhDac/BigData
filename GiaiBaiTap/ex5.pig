%declare INPUT_PATH 'hdfs:/Pig_Data/100linee.txt';
%declare OUTPUT_PATH 'hdfs:/Pig_Data/user/hadoopanhdac/output/ex5/';

RAW_DATA = LOAD '$INPUT_PATH'
        AS (ts:long, sport, dport, sip, dip,
                l3proto, l4proto, flags,
                phypkt, netpkt, overhead,
                phybyte, netbyte:long);

DATA = FOREACH RAW_DATA GENERATE sip, netbyte as upload;

DATA_UP = GROUP DATA BY sip;
FLOW_UP = FOREACH DATA_UP GENERATE group as ip, SUM(DATA.upload) as sum_upload;
FLOW_UP_SORTED = ORDER FLOW_UP BY sum_upload DESC;
FLOW_UP_TOP100 = LIMIT FLOW_UP_SORTED 100;

FLOW_JOIN = JOIN FLOW_UP_TOP100 BY ip, DATA BY sip;
FLOW_JOIN_GROUP = GROUP FLOW_JOIN BY ip;
RESULT = FOREACH FLOW_JOIN_GROUP GENERATE group, MAX(FLOW_JOIN.upload), (double)100 * MAX(FLOW_JOIN.upload) / MAX(FLOW_JOIN.sum_upload);

STORE RESULT INTO '$OUTPUT_PATH';
