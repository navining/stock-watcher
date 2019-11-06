# stock-watcher
[![stock-watcher](https://img.shields.io/badge/navining-stock--watcher-green)](https://github.com/navining/stock-watcher)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/navining/stock-watcher/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/navining/stock-watcher?style=social)](https://github.com/navining/stock-watcher)
[![GitHub followers](https://img.shields.io/github/followers/navining?label=Follow&style=social)](https://github.com/navining)

>A bash script to download and process historic stock price data.

This script establishes an interactive command line in which the user can input the year and month of a specific stock. Then it creates a txt file including the stock transaction prices of that month in the current folder.

This script use another bash script [get-yahoo-quotes](https://github.com/bradlucas/get-yahoo-quotes) to download Yahoo historical quotes using the new cookie authenticated site. Pay tribute to the author Brad Lucas.


## Usage
```
./stock-watcher.sh
```
This will bring up an interactive command line. Then enter the stock symbol, the month and the year, for example:
```
AAPL 10 2019
```
Then the script will create a txt file in the current folder including the stock transcation prices of Apple Inc. in 2019/10. The txt filename is in the format of `StockSymbol_Month_Year.txt`, for example `AAPL_10_2019.txt`.

The output file including two rows, first the *Date* and second the *Adjusted Closing Price* in EUR, for example:
```
Date		Adjusted Closing Price / ¢
2019-10-31	226.372
2019-10-30	221.367
2019-10-29	221.394
2019-10-28	226.636
2019-10-25	224.388
2019-10-24	221.658
2019-10-23	221.294
2019-10-22	218.364
2019-10-21	218.864
2019-10-18	215.133
2019-10-17	214.105
2019-10-16	213.277
2019-10-15	214.141
2019-10-14	214.642
2019-10-11	214.951
2019-10-10	209.382
2019-10-09	206.597
2019-10-08	204.204
2019-10-07	206.625
2019-10-04	206.579
2019-10-03	200.946
2019-10-02	199.254
2019-10-01	204.377


```

Press `Ctrl+C` to stop and exit at any time.
