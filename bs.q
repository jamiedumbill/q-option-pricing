/###############################################################################
/### Title       : Black-Scholes option pricing and sensitivities
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/bs.q
/### Description : Functions to calculate option price and sensitivities for
/###               both call and put options
/###############################################################################

/### Common functions ###
/# Description: Common functions required by Black-Scholes equations
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : 
.bs.d1:{[S;K;t;v;r] ((log S%K)+t*r+0.5*v*v)%(v*sqrt(t))};
.bs.d2.c:{[S;K;t;v;r] .bs.d1[S;K;t;v;r]-v*sqrt(t)};
.bs.d2.p:{[S;K;t;v;r] (v*sqrt(t))-.bs.d1[S;K;t;v;r]};

/### Black-Scholes call price ###
/# Description: Calculate the price of a call option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float call option price
.bs.c.price:{[S;K;t;v;r] 
    (S * .math.ncdf[.bs.d1[S;K;t;v;r]])-
    ((K *exp (neg r*t))*.math.ncdf[.bs.d2.c[S;K;t;v;r]])
  }

/### Black-Scholes put price ###
/# Description: Calculate the price of a put option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float put option price
.bs.p.price:{[S;K;t;v;r] 
    ((neg S) * .math.ncdf[neg .bs.d1[S;K;t;v;r]])+
    ((K *exp (neg r*t))*.math.ncdf[.bs.d2.p[S;K;t;v;r]])
  }

/### Delta ###
/# Description: The sensitivity of an option's theoretical price to a change 
/#              in the price of the underlying contract
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float option delta
.bs.c.delta:{[S;K;t;v;r] 
    .math.ncdf[.bs.d1[S;K;t;v;r]]
  }

.bs.p.delta:{[S;K;t;v;r] 
    neg .math.ncdf[neg .bs.d1[S;K;t;v;r]]
  }

/### Gamma ###
/# Description: The sensitivity of an option's delta to a change in the price 
/#              of the underlying contract
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float option gamma
.bs.c.gamma:{[S;K;t;v;r] 
    .math.ndc[.bs.d1[S;K;t;v;r]]%((S*v)*sqrt(t))
  }

.bs.p.gamma::.bs.c.gamma

/### Theta ###
/# Description: The sensitivity of an option's theoretical value to a change in 
/#              the amount of time remaining to expiration 
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float option theta
.bs.c.theta:{[S;K;t;v;r] 
    neg ((S*v*.math.ndc[.bs.d1[S;K;t;v;r]])%(2*sqrt(t)))
    +((r*K*exp (neg r*t))*.math.ncdf[.bs.d2.c[S;K;t;v;r]])
  }

.bs.p.theta:{[S;K;t;v;r]
    neg ((S*v*.math.ndc[.bs.d1[S;K;t;v;r]])%(2*sqrt(t)))
    -((r*K*exp (neg r*t))*.math.ncdf[.bs.d2.p[S;K;t;v;r]])
  }

/### Vega ###
/# Description: The sensitivity of an option's theoretical value to a change 
/#              in volatility
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float option vega

.bs.c.vega:{[S;K;t;v;r] 
    (S*sqrt(t))*(.math.ndc[.bs.d1[S;K;t;v;r]])
  }

.bs.p.vega::.bs.c.vega

/### Rho ###
/# Description: The sensitivity of an option's theoretical value to a change 
/#              in interest rate
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/# Returns    : float option rho
 
.bs.c.rho:{[S;K;t;v;r] 
    (t*K*exp (neg r*t))
    *.math.ncdf[.bs.d2.c[S;K;t;v;r]]
  }

.bs.p.rho:{[S;K;t;v;r]
    ((neg t)*K*exp (neg r*t))
    *.math.ncdf[.bs.d2.p[S;K;t;v;r]]
  }
