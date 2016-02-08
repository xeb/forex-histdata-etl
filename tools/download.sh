#!/bin/bash

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
    -H 'Referer: http://www.histdata.com/download-free-forex-historical-data/?/ascii/1-minute-bar-quotes/eurusd/2000' \
    -H 'Connection: keep-alive' \
    -H 'DNT: 1' \
    --data 'tk=216a804365eccace285d20afed7acefe&date=2000&datemonth=2000&platform=ASCII&timeframe=M1&fxpair=EURUSD' \
    --compressed > output.zip
