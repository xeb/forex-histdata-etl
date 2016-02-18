#!/bin/bash
# Merge data

export ALL_TICKERS=$(./get_tickers.sh)

RAW_PATH="../data/RAW"
DATA_PATH="../data/1M"

mkdir -p $DATA_PATH
mkdir -p $RAW_PATH

for t in $ALL_TICKERS; do
	printf "Processing $t..." -n
	FILES=$(ls $RAW_PATH/$t* | sort)
	cat $FILES > $DATA_PATH/$t.tmp
	cut -d, -f2,3,4,5,6,7,8 $DATA_PATH/$t.tmp | sed 's/......../&,/' > $DATA_PATH/$t.csv
	sed -i '.old' '1i\
Date,Time,Open,High,Low,Close,Volume\
' $DATA_PATH/$t.csv
	rm -f $DATA_PATH/$t.tmp
	rm -f $DATA_PATH/$t.csv.old
	printf "Done!\n"
done

GRN='\033[0;32m'
NC='\033[0m' # No Color
printf "\n${GRN}MERGING COMPLETE${NC}\n"