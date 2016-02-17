#!/bin/bash
# Get all tickers
curl http://www.histdata.com/download-free-forex-data/?/ascii/1-minute-bar-quotes  | pup 'a attr{href}' | grep -i quotes | grep -o '......$'