# FOREX HistData.com ETL Tools

## Quick Note
The good people at [HistData.com](http://www.histdata.com) have setup the infrastructure necessary to provide FOREX data for free.  This is awesome & if possible, you should donate or purchase some of their services if you are going to use the data.  The tools contained herein will download, merge and convert the datasets so they are usable, but not (yet) easily updateable.  The entire sets have to be rebuilt when updates occur (but not downloaded in their entirety).

## Quick Start
A Makefile is included for some common operations.  They are documented below.

### make download
```make download```

This will get all files from HistData.com as MetaTrader CSVs and put the contents in ```../data/RAW```.

### make merge
```make merge```

This will combine all the yearly & monthly files into a single CSV per instrument (e.g. *AUDUSD.csv*).  Since the data from HistData.com have provided 1 minute data, the contents of merged data is in ```../data/1M```.

### make convert
```make convert```

Using [Pandas](http://pandas.pydata.org/), this will invoke the *convert_data.py* script and by default create 60 minute data sets.  The end result will be stored in ```../data/60M```.

## Requirements
The following are required:
* bash
* [pup](https://github.com/ericchiang/pup)
* rename
* cURL
* sed
* unzip
* Python (2.7 or greater)
* Pandas

## Yeah, yeah, how do I get FOREX Data working in Pandas as DataFrames!???
If you want to just get some FOREX data as Pandas DataFrames, just do this:

```
$ make download 
$ make merge
```
In Python:
```
import pandas as pd 
source_path="./data/60M/" 
source="EURUSD.csv" 
df = pd.read_csv(os.path.join(source_path, source), sep=',')
```

## Why do this?
I wanted to try some ML models on FOREX data but didn't have a great data source at the time.  I am publishing this because distributing public data should be easier than writing bash scripts to get random tokens in order to download data about the world's currencies.  Why isn't exchange rate data completely public? 

## Maybe in the future
At some point, I may do the following:
* ```make update``` should do daily updates
* stop using bash, this can all be in Python... should have started there
* create pickled versions of various time-series
* incorporate the gaps found -- those are ignored / deleted at the moment