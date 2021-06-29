#!/bin/bash
# Downloads all ticker data from histdata.com

export ALL_TICKERS=$(`pwd`/get_tickers.sh)

STATE_YEAR=${START_YEAR:=2000}
START_YEAR=2000
END_YEAR=${END_YEAR:=(date +%Y)}
END_YEAR=$(date +%Y)

# Ensure we have a data directory

RAW_PATH="../data/RAW"
mkdir -p $RAW_PATH

#ALL_TICKERS="EURUSD"
for t in ${ALL_TICKERS}; do
    echo "Downloading data ${t} for years ${START_YEAR} - ${END_YEAR}"
    for i in `seq ${START_YEAR} ${END_YEAR}`; do
    	if [ $i == $(date +%Y) ]; then
    		# Download each month
    		echo "CURRENT YEAR; Downloading up to month $(date +%m)..."
    		for j in `seq 1 $(date +%m)`; do
    			echo "Downloading $t for $i (month $j)..."
    			FILE="$RAW_PATH/$t$i`printf "%02d\n" ${j}`.csv"

    			# if it's the current month, delete the existing raw file
    			if [[ "$j" -eq $(date +%m | sed 's/^0*//') ]]; then
				echo "Deleting $FILE"
    				rm -f $FILE
    			fi
    			if [[ -s $FILE ]]; then
		    		echo "File $FILE exists, skipping..."
		    	else
				echo "Getting t=$t,year=$i,month=$j"
        			./get_zip.sh --ticker="$t" --year="$i" --month="$j"
    			fi
    		done
        else
        	# Download a single year
	        echo "Downloading $t with $i..."
	        FILE="$RAW_PATH/$t$i.csv"
	    	if [[ -a $FILE ]]; then # a vs s;
	    		echo "File $FILE exists, skipping..."
	    	else
			echo "Getting t=$t,year=$i"
	        	./get_zip.sh --ticker="$t" --year="$i"
	        	EXIT_CODE=$?
	        	if [ $EXIT_CODE == 3 ]; then
	        		touch $FILE
	        		echo "Touching file when no token is present for the combo ($FILE)"
	        	fi
    		fi
    	fi
    done
done

# Unzip everything
unzip -u \*.zip 2> /dev/null

# Delete all zips files
rm -rf *.zip 2> /dev/null

# Delete all gap files
rm -rf *.txt  2> /dev/null

# Move all CSVs to the data directory
mv -f *.csv $RAW_PATH/ 2> /dev/null

# Change the names
# install rename with "(brew|apt-get|yum) install rename"
rename -d DAT_ASCII_ $RAW_PATH/* 2> /dev/null
rename -d DAT_MS_ $RAW_PATH/* 2> /dev/null
rename -d _M1_ $RAW_PATH/* 2> /dev/null
GRN='\033[0;32m'
NC='\033[0m' # No Color
printf "\n${GRN}DOWNLOAD COMPLETE${NC}\n"
