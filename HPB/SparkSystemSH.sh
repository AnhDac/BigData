# run script in loop
for i in {1..100}
do
    # wait loop here for 5 second
	sleep 5

    # checking here, client has add request query for spark system or not.
	if curl -s --head  --request GET http://$1:$2/getQuery | grep "200" > /dev/null; then
		echo "client request found..."

		rm -r analysis.jar*
		rm -r data.csv*
		wget http://$1:$2/download/analysis.jar
		wget http://$1:$2/download/data.csv
	
        # here execute spark project jar with data file and client details
		spark-submit --class cloudduggu.com.MovieAnalysis analysis.jar data.csv $1 $2
		curl http://$1:$2/deleteQuery
		
	else
		echo "client request not found..."
	fi

	echo "LOOP"-$i

done

# sh runSparkSystem.sh 192.168.0.101 9090
# spark-submit --class cloudduggu.com.MovieAnalysis analysis.jar data.csv 192.168.0.101 9090