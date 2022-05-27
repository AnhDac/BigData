# clear local folder location & download spark ml project jar
rm -r artificial*
rm -r emotion*
wget http://$1:$2/download/artificial.jar
wget http://$1:$2/download/emotion.csv

# here execute Spark MLlib project jar with data file and client details
spark-submit --class cloudduggu.com.Artificial artificial.jar emotion.csv $1 $2

# export SPARK_HOME=/opt/spark
# export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
# sh spark-system.sh 192.168.0.104 9090
# spark-submit --class cloudduggu.com.Artificial artificial.jar emotion.csv 192.168.0.104 9090
