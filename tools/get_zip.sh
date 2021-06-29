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
echo "Downloading $FILE_PATH..."

export PAYLOAD="tk=$TK&date=$YEAR&datemonth=$YEAR$MONTH&platform=MS&timeframe=M1&fxpair=$TICKER"
echo "Payload is $PAYLOAD"

CMD="
curl 'https://www.histdata.com/get.php' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
	-H 'Accept-Language: en-US,en;q=0.5' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H 'Referer: https://www.histdata.com/download-free-forex-historical-data/?/excel/1-minute-bar-quotes/eurusd/2021/6' \
	-H 'Origin: https://www.histdata.com' \
	-H 'Connection: keep-alive' \
	-H 'Cookie: cookielawinfo-checkbox-necessary=yes; cookielawinfo-checkbox-non-necessary=yes' \
	-H 'Upgrade-Insecure-Requests: 1' -H 'Sec-GPC: 1' \
	--compressed \
	--output '$FILE_PATH' \
	--data-raw '$PAYLOAD'"

echo "Running $CMD"
eval $CMD

if [[ -s $FILE_PATH ]]; then
    echo "Done!"
    exit 0
else
    echo "Failed to download, check year"
    exit 3
fi
