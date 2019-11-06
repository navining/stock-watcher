#!/bin/bash

## -------------------------------------------------------------------------
## A bash script to download and process historic stock price data
##
## Author: Navi Ning
## Latest: https://github.com/navining/stock-watcher
##
## Copyright (c) 2019 NaviNing
## -------------------------------------------------------------------------


function getYahooQuotes(){
## Script to download Yahoo historical quotes using the new cookie authenticated site.
##
## Usage: get-yahoo-quotes SYMBOL
##
##
## Author: Brad Lucas brad@beaconhill.com
## Latest: https://github.com/bradlucas/get-yahoo-quotes
##
## Copyright (c) 2017 Brad Lucas - All Rights Reserved
##
##
## History
##
## 06-03-2017 : Created script
##
## ----------------------------------------------------------------------------------------

SYMBOL=$1
if [[ -z $SYMBOL ]]; then
  echo "Please enter a SYMBOL as the first parameter to this script"
  exit
fi
echo "Downloading quotes for $SYMBOL"

function log () {
  # To remove logging comment echo statement and uncoment the :
  echo $1
  # :
}

# Period values are 'Seconds since 1970-01-01 00:00:00 UTC'. Also known as Unix time or epoch time.
# Let's just assume we want it all and ask for a date range that starts at 1/1/1970.
# NOTE: This doesn't work for old synbols like IBM which has Yahoo has back to 1962
START_DATE=0
END_DATE=$(date +%s)

# Store the cookie in a temp file
cookieJar=$(mktemp)

# Get the crumb value
function getCrumb () {
  # Sometimes the value has an octal character
  # echo will convert it
  # https://stackoverflow.com/a/28328480

  # curl the url then replace the } characters with line feeds. This takes the large json one line and turns it into about 3000 lines
  # grep for the CrumbStore line
  # then copy out the value
  # lastly, remove any quotes
  echo -en "$(curl -s --cookie-jar $cookieJar $1)" | tr "}" "\n" | grep CrumbStore | cut -d':' -f 3 | sed 's+"++g'
}

# TODO If crumb is blank then we probably don't have a valid symbol
URL="https://finance.yahoo.com/quote/$SYMBOL/?p=$SYMBOL"
#log $URL
crumb=$(getCrumb $URL)
crumbIsValid="False"
#log $crumb
#log "CRUMB: $crumb"
if [[ -z $crumb ]]; then
  echo "Find nothing about this stock, check the stock symbol"
  return
fi


# Build url with SYMBOL, START_DATE, END_DATE
BASE_URL="https://query1.finance.yahoo.com/v7/finance/download/$SYMBOL?period1=$START_DATE&period2=$END_DATE&interval=1d&events=history"
#log $BASE_URL

# Add the crumb value
URL="$BASE_URL&crumb=$crumb"
#log "URL: $URL"

# Download to
curl -s --cookie $cookieJar  $URL > $SYMBOL.csv

#echo "Data downloaded to $SYMBOL.csv"

crumbIsValid="True"
}


function getInput(){
## Get user input, judge its validity and store it into appropriate variables

echo "Please enter the stock symbol, the month and the year (Ctrl + C to exit):"
echo "For example: AAPL 09 2019"

dateIsValid="True"

IFS=' '
read -ra INPUT

# Check if the number of inputed parameters is correct
if [ ${#INPUT[@]} -ne 3 ]; then
    echo "Error: Unexpected number of parameters"
    dateIsValid="False"
else

    stockSymbol=${INPUT[0]}
    month=${INPUT[1]}
    year=${INPUT[2]}
    
    # Check if month and year are both integers
    expr $month "+" $year &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Invalid month or year"
        dateIsValid="False"
    else 
        # Check if the month is correct
	if [ `expr $month` -lt 1 ]||[ `expr $month` -gt 12 ]; then
    	    echo "Error: Invalid month or year"
    	    dateIsValid="False"
        else

	currentYear=`date +"%Y"`
	currentMonth=`date +"%m"`

        # Check if it is a future date
        if [ `expr $year` -gt `expr $currentYear` ]; then
	    echo "Error: No stock information for the future"
	    dateIsValid="False"
	fi

        if [ `expr $year ` -eq `expr $currentYear` ]&&[ `expr $month` -gt `expr $currentMonth` ];then
	    echo "Error: No stock information for the future"
	    dateIsValid="False"
        fi
      fi
    fi

    # If the user inputs a single digit for months, put a "0" ahead of it. 
    # For example: "8" -> "08"
    if [[ $month =~ ^[1-9]$ ]]; then
        month=0"$month"
    fi

fi
}

# --------------------------------------------------------Main-----------------------------------------------------------

while [ 1 -ne 0 ]; do
    
    # Get the user input
    getInput

    # Check if the inputed date is valid    
    if [[ $dateIsValid == "True" ]]; then 
        getYahooQuotes $stockSymbol

        # Check if the crumb for the inputed stock symbol is valid    
        if [ $crumbIsValid == "True" ]; then
            
            # Get the date and the adjusted closing price (convert Dollar into Euro as well)
            cat $stockSymbol.csv|grep $year-$month|awk -F ',' '{print $1"\t"$6*0.91}' > data.txt

	    # Check if input.txt is an empty file (which means no information about the stock on that date)
	    sizeOfInput=`wc -c data.txt|cut -f 1 -d ' '`
            if [ $sizeOfInput -eq 0 ]; then
        	echo "Find nothing about this stock at that time, try another date"

            else

	        # Include the header, invert the order of date and output the data into a named txt file 	
		echo -e "Date\t\tAdjusted Closing Price / ¢" >> data.txt 
               	fileName="$stockSymbol"_"$month"_"$year".txt
	    	tac data.txt > $fileName
            	echo "Data successfuly downloaded to $fileName" 
	    fi

            # Remove temporary files
	    rm $stockSymbol.csv
	    rm data.txt
        fi
    fi

    echo "----------------------------------------------------------------------"

done
