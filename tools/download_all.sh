#!/bin/bash
# Downloads all ticker data from histdata.com
# Requires pup

export ALL_TICKERS=$(curl http://www.histdata.com/download-free-forex-data/?/ascii/1-minute-bar-quotes  | pup 'a attr{href}' | grep -i quotes | grep -o '......$')

for t in $ALL_TICKERS; do
    for i in `seq 2000 2017`; do
        echo "Downloading $t with $i..."
        ./download.sh --ticker="$t" --year="$i"
        rm -rf *.txt # I don't care about the gaps
        mv *.csv ../data/
    done
done
