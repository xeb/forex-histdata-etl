import pandas as pd
import numpy as np
import os


def get_dataframe(symbol):
    filename = os.path.join(
        os.path.dirname(__file__),
        'data/1M/{}.csv'.format(symbol)
    )

    dateparse = lambda date, time: pd.to_datetime("{} {}".format(date, time), format="%Y%m%d %H%M")

    if os.path.isfile(filename):
        return pd.read_csv(filename,
                           parse_dates={'datetime': ['Date', 'Time']},
                           date_parser=dateparse,
                           index_col=['datetime'])
    else:
        print("Data for {} does not exists in data/1M folder".format(symbol))
