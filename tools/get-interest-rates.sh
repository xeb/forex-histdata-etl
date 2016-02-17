#!/bin/bash
curl 'https://fx1.oanda.com/mod_perl/user/interestrates.pl' \
  -H 'Origin: http://www.oanda.com' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Accept-Language: en-US,en;q=0.8,mt;q=0.6' \
  -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Script' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
  -H 'Cache-Control: max-age=0' \
  -H 'Referer: http://www.oanda.com/forex-trading/analysis/historical-rates' \
  -H 'Connection: keep-alive' -H 'DNT: 1' \
  --data 'startdate=01%2F01%2F2000&enddate=01%2F01%2F2018&currency=AUD&currency=GBP&currency=CAD&currency=CNY&currency=CZK&currency=DKK&currency=EUR&currency=HUF&currency=HKD&currency=INR&currency=JPY&currency=MXN&currency=TWD&currency=NZD&currency=NOK&currency=PLN&currency=SAR&currency=SGD&currency=ZAR&currency=SEK&currency=CHF&currency=THB&currency=TRY&currency=USD&currency=XAU&currency=XAG&currency=US30&currency=NAS100&currency=SPX500&currency=UK100&currency=DE30&currency=HK33&currency=JP225&currency=BCO&currency=CORN&currency=WHEAT&currency=NL25&currency=FR40&currency=EU50&currency=SUGAR&currency=SOYBN&currency=NATGAS&currency=WTICO&currency=XCU&currency=USB02Y&currency=USB05Y&currency=USB10Y&currency=USB30Y&currency=CH20&currency=DE10YB&currency=US2000&currency=UK10YB' \
  --compressed \
| sed 's/<[^>]*>/,/g' | sed 's/,,/,/g'| sed 's/,,/,/g' | sed 's/^..//' | sed 's/.$//g'