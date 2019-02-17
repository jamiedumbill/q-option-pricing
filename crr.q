/###############################################################################
/### Title       : Binomial tree pricing functions
/### Type        : Library
/### Author      : A Developer
/### Description : Cox-Ross-Rubenstein binomial model for calculating call and
/###               put option price
/###############################################################################

/### Binomial call price ###
/# Description: Calculate the price of a call option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/#              steps integer - number of nodes in the probability tree
/# Returns    : float call option price
.crr.c.price:{[S;K;t;v;r;steps]
    dt:         t % steps;
    vDt:        v * sqrt(dt);
    rDt:        r * dt;

    //Per-step interest and discount factors
    If:         exp(rDt);
    Df:         exp(neg rDt);

    //Values and pseudoprobabilities of upward and downward moves
    u:          exp(vDt);
    d:          exp(neg vDt);
    pu:         (If - d) % (u - d);
    pd:         1.0 - pu;
    .crr.puByDf: pu * Df;
    .crr.pdByDf: pd * Df;

    //Calculate the leaf nodes
    call:(`key`val)!(til (steps+1);(steps+1)#0);
    call.val:(S*exp(vDt*((2*call[`key])-steps)))-K;
    call.val[where call.val<=0]:0.0; // Negative price makes no sense

    //Backward iteration to calculate internal nodes
    // Prob of up path plus prob of down path equals prob of
    // current node, therefore we can calc price at each node

    {call.val[til x]: (.crr.puByDf * call.val[(til x)+1])  // prob of up path
                    + (.crr.pdByDf * call.val[til x])      // prob of down path
    } each ((reverse til (steps)+1));                     // do for each node
    delete .crr.puByDf, .crr.pdByDf from `.;
    first call.val
  }

/### Binomial put price ###
/# Description: Calculate the price of a call option
/# Parameters : S float - current stock price
/#              K float - option exercise price
/#              t float - time until expiry in years (e.g. 0.5 = 182.5 days)
/#              v float - implied volatility
/#              r float - risk free rate of return
/#              steps integer - number of nodes in the probability tree
/# Returns    : float put option price
.crr.p.price:{[S;K;t;v;r;steps]
    dt:         t % steps;
    vDt:        v * sqrt(dt);
    rDt:        r * dt;

    //Per-step interest and discount factors
    If:         exp(rDt);
    Df:         exp(neg rDt);

    //Values and pseudoprobabilities of upward and downward moves
    u:          exp(vDt);
    d:          exp(neg vDt);
    pu:         (If - d) % (u - d);
    pd:         1.0 - pu;
    .crr.puByDf: pu * Df;
    .crr.pdByDf: pd * Df;

    //Calculate the leaf nodes
    put:(`key`val)!(til (steps+1);(steps+1)#0);
    put.val:K-(S*exp(vDt*((2*put[`key])-steps)));
    put.val[where put.val<=0]:0.0; // Negative price makes no sense

    //Backward iteration to calculate internal nodes
    // Prob of up path plus prob of down path equals prob of
    // current node, therefore we can calc price at each node

    {put.val[til x]: (.crr.puByDf * put.val[(til x)+1])  // prob of up path
                    + (.crr.pdByDf * put.val[til x])     // prob of down path
    } each ((reverse til (steps)+1));                   // do for each node
    first put.val
  }

