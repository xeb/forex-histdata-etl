#!/bin/bash
# Get all tickers
if [ -z "$SYMBOL" ]; then
    curl http://www.histdata.com/download-free-forex-data/?/ascii/1-minute-bar-quotes  | pup 'a attr{href}' | grep -i quotes | grep -o '......$'
else
    echo $SYMBOL
fi