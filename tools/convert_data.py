#!/usr/bin/python
# Convert Data will read all merged CSVs into a Pandas DataFrame
# then merge each bar into new bars based on minutes (within a day)
# default is 60 minutes

import os, sys
import pandas as pd
import errno
import datetime

verbose = False
window_minutes = 60
minute_path = os.path.join(os.getcwd(), "../data/1M/")
output_path = os.path.join(os.getcwd(), "../data/60M/")
files = os.listdir(minute_path)
epoch = datetime.datetime(1900, 1, 1, 0, 0)

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

def srange(start, stop, step):
    e = int((stop-start)/float(step))
    for i in range(e+1):
            yield start + i*step

def parse_file(source, source_path, dest_path):
    print("Reading %s" % source)
    
    df = pd.read_csv(os.path.join(source_path, source), sep=',')
    
    # Convert times into minute-based indexes (0 -> 1440)
    print("Converting times %s" % source)
    
    df.Time = df.Time.apply(lambda x: (datetime.datetime.strptime(str("%04d" % x), '%H%M') - epoch).seconds / 60)

    with open(os.path.join(dest_path, source), "w") as dest:
        dest.write("Date,Time,Open,High,Low,Close,Volume\n")

        # foreach date in the file
        dates = pd.Series(df.Date.ravel()).unique()
        print("Iterating over %s dates" % len(dates))

        for date in dates:
            # get all row for this date
            rowsD = df[df.Date == date]
            for t in srange(0, 1440, window_minutes):
                endT = t + window_minutes
                
                # all rows for this timeframe
                rowsT=rowsD[rowsD.Time >= t][rowsD.Time < endT]

                if len(rowsT) == 0:
                    continue

                Open=str(rowsT.iloc[0]['Open']) # First
                High=str(rowsT.High.max())
                Low=str(rowsT.Low.min())
                Close=str(rowsT.iloc[-1]['Close']) # Last
                Volume=str(rowsT.Volume.sum())
                Time = str((epoch + datetime.timedelta(0, endT * 60)).strftime('%H%M'))

                # Write new row
                line = ",".join([str(date), Time, Open, High, Low, Close, Volume])
                dest.write(line + "\n")

                if verbose and date % 5 == 0 and endT >= 1430:
                    print("For Date %s, Time %s; Parsed %s rows.\nOpen=%s,High=%s,Low=%s,Close=%s,Volume=%s" % (date, t, len(rowsT), Open, High, Low, Close, Volume))

    print("\033[94mDone.\033[0m Converted %s" % source)    

if __name__ == "__main__":
    mkdir_p(minute_path)
    mkdir_p(output_path)
    for file in files:
        if file.endswith(".csv") == False:
            continue
        parse_file(file, source_path=minute_path, dest_path=output_path)
    print("Finished processing %s files\n\033[92mCOMPLETE\033[0m")
