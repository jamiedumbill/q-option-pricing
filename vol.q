/###############################################################################
/### Title       : Volatility functions
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/vol.q
/### Description : Calculation of various types of volatility
/###############################################################################

/### Historical Volatility ###
/# Description: Volatility of previous data 
/# Parameters : x list float
/#              y atom float data range in years
/# Returns    : atom float
.vol.hist:{(sqrt(365%y))*.math.ssd[log(1_x)%(-1_x)]}


/### Black-Scholes implied volatility - Call ###
/# Description: Newton-Raphson method for estimating implied volatility
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : atom float
.vol.bs.c:{[S;K;t;r;C]
    .vol.S :S;
    .vol.K :K;
    .vol.t :t;
    .vol.r :r;
    .vol.C :C;
    n: 100;
    v: (C%S)%(0.398*sqrt(t));
    f:{x+
     ((.vol.C-.bs.c.price[.vol.S;.vol.K;.vol.t;x;.vol.r])%
      .bs.c.vega[.vol.S;.vol.K;.vol.t;x;.vol.r])};
    R:f/[n;v];
    delete S,K,t,r,C from `.vol; // Clean up
    R
  }

/### Black-Scholes implied volatility - Put ###
/# Description: Newton-Raphson method for estimating implied volatility
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : atom float
.vol.bs.p:{[S;K;t;r;C]
    .vol.S :S;
    .vol.K :K;
    .vol.t :t;
    .vol.r :r;
    .vol.C :C;
    n: 100;
    v: (C%S)%(0.398*sqrt(t));
    f:{x+
        ((.vol.C-.bs.p.price[.vol.S;.vol.K;.vol.t;x;.vol.r])%
         .bs.p.vega[.vol.S;.vol.K;.vol.t;x;.vol.r])};
    R:f/[n;v];
    delete S,K,t,r,C from `.vol;
    R
  }
