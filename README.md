[![stock-watcher](https://img.shields.io/badge/navining-stock--watcher-green)](https://github.com/navining/stock-watcher)

# stock-watcher
>A bash script to download and process historic stock price data.

This script establishes an interactive command line in which the user can input the year and month of a specific stock. Then it creates a txt file including the stock transaction prices of that month in the current folder.

This script use another bash script get-yahoo-quotes to download Yahoo historical quotes using the new cookie authenticated site. Pay tribute to the author Brad Lucas.


## Usage
```
./stock-watcher.sh
```