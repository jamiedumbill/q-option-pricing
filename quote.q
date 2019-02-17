/###############################################################################
/### Title       : Retrieve price information
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/quote.q
/### Description : Functions to retrive price information from yahoo finance
/###############################################################################

/### Batch live quotes ###
/# Description: Split live quote request into smaller groups and submit
/# Parameters : s list symbols
/# Returns    : table of live quotes
.quote.batch.live:{[s]
    // Returns live prices from a list of symbols list 
    // is processed in groups of 50 due to yahoo limit

    s:distinct s,(); //No dupicates ensure list
    c:count s;
    i:distinct 0|c&1_step[0; c+50;c%c%50];
    batch:"i"$0{step[y;x-1;1]}':i;
    R::();
    {R::R,.quote.live[x]} each s[batch];
    return:R;
    delete R from `.;
    return
  }

/### Live quote ###
/# Description: Make request for live quote data from yahoo
/# Parameters : s list symbols
/# Returns    : table of live quotes
.quote.live:{[s]
    // Fields required from Yahoo!
    f:`s`n`l1;
    
    // Symbols in list form without duplicates
    s:distinct s,();

    // Make request for data
    data:`:http://download.finance.yahoo.com
      "GET /d/quotes.csv?s=",("," sv string s),
      "&f=",("" sv string f)," http/1.0\r\n",
      "host:download.finance.yahoo.com:80\r\n\r\n";

    // Look for first quote
    pattern:"\"",(string first s),"\"";

    // Cut off html header text
    data:(data ss pattern)_ data;
    -1_flip("SSF";",")0:data
  }

/### Batch historical quotes ###
/# Description: Splits a request for a large number of symbols
/# Parameters : s list symbols
/#              d integer number of days
/# Returns    : table of historical quotes
.quote.batch.hist:{[d;s]
    s:distinct s,(); //No dupicates ensure list
    data:d{.quote.hist[x;y]}/:s;
    //data
    {x:x,y}/[data]
  }


/### Batch historical quotes ###
/# Description: Splits a request into quarters of a year to reduce returned 
/#              string length
/# Parameters : s list symbols
/#              d integer number of days
/# Returns    : table of historical quotes
.quote.hist:{[d;s]
    // Symbols in list form without duplicates
    .quote.symbol:distinct s,();
    show s;

    // Dates to get in quarter year groups, taking first day of month
    // stops overflow of string length in returned data
    ed   : "d"$(("m"$.z.d)+1);
    sd   : ed-d;
    sds :: distinct "d"$"m"$step[sd;ed;90];
    eds :: distinct ("d"$("m"$sds))-1;

    // Get data sets
    data :(-1_sds){.quote.get.hist[x;y]}'(1_eds);

    // Join data and clean, no blanks, no repeats
    data : {x:x,y}/[data];
    data : select distinct from data where not null Date;
    data : update Sym:s from data;
    delete sds,eds from `.;

    // Return table
    `Date xdesc data
  }

/### Historical quote ###
/# Description: Make request for historical quote data from yahoo
/# Parameters : sd date - start date
/#              ed date - end date
/#              .quote.symbol - list of symbols to retrieve
/# Returns    : table of historical quotes
.quote.get.hist:{[sd;ed]
    // Parameters required by yahoo
    p  : "&d=" ,     (string -1+`mm$ed), / end month
         "&e=" ,     (string `dd$ed),    / end day
         "&f=" ,     (string `year$ed),  / end year
         "&g=m",                         / time interval
         "&a=" ,     (string -1+`mm$sd), / start month
         "&b=" ,     (string `dd$sd),    / start day
         "&c=" ,     (string `year$sd),  / start year
         "&ignore=.csv";

    // Make http request returning data
    data:`:http://ichart.finance.yahoo.com
         "GET /table.csv?s=",("" sv string .quote.symbol,p," http/1.0\r\n"),
         "host:ichart.finance.yahoo.com\r\n\r\n";

    // Cut off html header text
    pattern:"Date,Open";
    data:(data ss pattern)_ data;

    // Return data set
    ("DEEEEIE";enlist ",")0:data
  }
