#!/bin/bash
# HistData.com Downloader
# you can specify --ticker or --year to get a specific example

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "$0 - download a specific timeframe of data from histdata.com"
                        echo " "
                        echo "$0 [arguments]"
                        echo " "
                        echo "arguments:"
                        echo "-h, --help                show brief help (this)"
                        echo "--ticker=TICKER       specify an action to use"
                        echo "--year=YEAR           the year to download"
                        echo "--month=MONTH         the month to download"
                        exit 0
                        ;;
                --ticker*)
                        export TICKER=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                --year*)
                        export YEAR=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                --month*)
                        export MONTH=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done
if [[ -z "$TICKER" ]]; then
    echo "Ticker not set"
    exit 1
fi
if [[ -z "$YEAR" ]]; then
    echo "Year not set"
    exit 2
fi

# Get the special "TK" token value...
export TK_URL="http://www.histdata.com/download-free-forex-historical-data/?/metastock/1-minute-bar-quotes/${TICKER}/${YEAR}"

if [[ -z "$MONTH" ]]; then
    # we are assuming that with no month, we use the year-based scheme for downloading
    export MONTH=""
    #echo "No month specified!!!"
else
    # Month was set, so use it in the URL
    export MONTH=`printf "%02d\n" ${MONTH}`
    #echo "Month is $MONTH now; resetting TK URL"
    export TK_URL="http://www.histdata.com/download-free-forex-historical-data/?/metastock/1-minute-bar-quotes/${TICKER}/${YEAR}/${MONTH}"
fi

# echo "Using ticker '$TICKER' and year of '$YEAR' and month of '$MONTH'"
export TK=$(curl -s ${TK_URL} | grep "name=\"tk\"" | head -n 1 | sed -e "s/.* value=\"\(.*\)\".*/\1/")

if [[ -z "$TK" ]]; then
    echo "No data for $TICKER-$YEAR-$MONTH; Could not get TK value"
    exit 3
fi

# echo "TK value is $TK"

export FILE_PATH="output-$TICKER-$YEAR-$MONTH.zip"
#echo "Downloading $FILE_PATH..."

export PAYLOAD="tk=$TK&date=$YEAR&datemonth=$YEAR$MONTH&platform=MS&timeframe=M1&fxpair=$TICKER"
#echo "Payload is $PAYLOAD"

curl 'http://www.histdata.com/get.php' \
    -H 'Cookie: __cfduid=d310948951de3b4be8511fb6402eef8f31454966770; __cfduid=d310948951de3b4be8511fb6402eef8f31454966770; complianceCookie=on; gsScrollPos=' \
    -H 'Origin: http://www.histdata.com' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Accept-Language: en-US,en;q=0.8,mt;q=0.6' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko)
Chrome/48.0.2564.97 Safari/537.36' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: max-age=0' \
    -H 'Referer: http://www.histdata.com/download-free-forex-historical-data/?/metastock/1-minute-bar-quotes/eurusd/2000' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    --data "$PAYLOAD" \
    --compressed > $FILE_PATH
if [[ -s $FILE_PATH ]]; then
    echo "Done!"
    exit 0
else
    echo "Failed to download, check year"
    exit 3
fi
