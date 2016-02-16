#!/bin/bash
# Downloads all ticker data from histdata.com

export ALL_TICKERS=$(curl http://www.histdata.com/download-free-forex-data/?/ascii/1-minute-bar-quotes  | pup 'a attr{href}' | grep -i quotes | grep -o '......$')

# Ensure we have a data directory
mkdir -p ../data/

for t in $ALL_TICKERS; do
    for i in `seq 2014 $(date +%Y)`; do
    	if [ $i == $(date +%Y) ]; then
    		# Download each month
    		# echo "CURRENT YEAR; Downloading up to month $(date +%m)..."
    		for j in `seq 1 $(date +%m)`; do
    			# echo "Downloading $t for $i (month $j)..."
    			FILE="../data/$t$i`printf "%02d\n" ${j}`.csv"
    			if [[ -s $FILE ]]; then
		    		echo "File $FILE exists, skipping..."
		    	else
        			./get_zip.sh --ticker="$t" --year="$i" --month="$j"
    			fi
    		done
        else
        	# Download a single year
	        # echo "Downloading $t with $i..."
	        FILE="../data/$t$i.csv"
	    	if [[ -a $FILE ]]; then # a vs s;
	    		echo "File $FILE exists, skipping..."
	    	else
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
unzip \*.zip 2> /dev/null

# Delete all zips files
rm -rf *.zip 2> /dev/null

# Delete all gap files
rm -rf *.txt  2> /dev/null

# Move all CSVs to the data directory
mv *.csv ../data/ 2> /dev/null

# Change the names
# install rename with "(brew|apt-get|yum) install rename"
rename -d DAT_ASCII_ ../data/* 2> /dev/null
rename -d _M1_ ../data/* 2> /dev/null
GRN='\033[0;32m'
NC='\033[0m' # No Color
printf "\n${GRN}COMPLETE${NC}\n"