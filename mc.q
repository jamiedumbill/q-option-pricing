/##################################################
/### Monte Carlo option pricing
/##################################################

/###############################################################################
/### Title       : Monte Carlo option pricing functions
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/mc.q
/### Description : Functions to calculate call and put option price using
/###               monte carlo simulation
/###############################################################################

/### Call price ###
/# Description: Calculate the price of a call option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/#              sims integer - number of paths for simulation
/# Returns    : float call option price
.mc.c.price:{[S;K;t;v;r;sims]
    R:(r- 0.5*(v xexp 2))*t;
    sd:v*sqrt(t);

    // Generate normally distributed random numbers
    randn:.math.randn[sims];

    // Take symmetrical price moves
    S1:S* exp(R+sd*randn);
    S2:S* exp(R+sd* neg randn);

    // Join price moves, discard prices less than 0.0
    pay:(S1-K),(S2-K);
    pay[where pay<0.0]:0.0;
    (exp(neg r*t))*((sum pay)%(2*sims))
  }

/### Put price ###
/# Description: Calculate the price of a put option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/#              sims integer - number of paths for simulation
/# Returns    : float put option price
.mc.p.price:{[S;K;t;v;r;sims]
    R:(r- 0.5*(v xexp 2))*t;
    sd:v*sqrt(t);

    / Generate normally distributed random numbers
    randn:.math.randn[sims];

    / Take symmetrical price moves
    S1:S* exp(R+sd*randn);
    S2:S* exp(R+sd* neg randn);

    / Join price moves, discard prices less than 0.0
    pay:(K-S1),(K-S2);
    pay[where pay<0.0]:0.0;

    / Return
    (exp(neg r*t))*((sum pay)%(2*sims))
  }

