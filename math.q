/##################################################
/### Math methods
/##################################################

/###############################################################################
/### Title       : Mathematical functions
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/math.q
/### Description : General mathematical functions
/###############################################################################

/### Define pi ###
/# Description: Declare global constant pi
/# Parameters : None
/# Returns    : Constant pi
pi:3.1415926535897931

/### Mean ###
/# Description: Calculate the mean value for a list of numbers
/# Parameters : x list float
/# Returns    : Mean float
.math.mean:{[x] (sum x where x<>0N)%(count x where x<>0N)}

/### Median ###
/# Description: Calculates the median value for a list of numbers 
/# Parameters : x list float
/# Returns    : Median float
.math.median:{[x] 
    x:asc x; 
    $[((count x) mod 2)<>0b;
      [x[floor((count x)%2)]];
      [(x[floor((count x)%2)] + x[floor((count x)%2)-1])%2]
    ]
  };

/### Moving average ###
/# Description: Calculate the moving average of a list of numbers
/# Parameters : n subset size integer
/#              x list float
/# Returns    : list float
.math.movingavg:{[n;x] y:(n#0),x; each[.math.mean]y[n+(til (count x))-\:til n]}

/### Difference mean ###
/# Description: Calculates the difference between each value and the mean
/#              of a list of numbers
/# Parameters : x list float
/# Returns    : list float
.math.meandiff:{x-.math.mean[x]}

/### Variance ###
/# Description: Calculate the variance for a list of numbers
/# Parameters : x list float
/# Returns    : atom float
.math.vari:{x:"f"$x; (sum(x-.math.mean[x]) xexp 2)%(count x)}

/### Standard deviation population ###
/# Description: Standard deviation where the sample is the entire population
/# Parameters : x list float
/# Returns    : atom float
.math.sd:{x:"f"$x; sqrt(var[x])}

/### Standard deviation sample ###
/# Description: Standard deviation where the sample is part of the entire 
/#              population
/# Parameters : x list float
/# Returns    : atom float
.math.ssd:{x:"f"$x; sqrt((sum(x-.math.mean[x]) xexp 2)%((count x)-1))}

/### Skewness and kurtosis ###
/# Description: Skewness and kurtosis of probability function
/# Parameters : x list float
/# Returns    : atom float
m2:{var[x]}
m3:{(sum(x-.math.mean[x]) xexp 3)%(count x)}
m4:{(sum(x-.math.mean[x]) xexp 4)%(count x)}
.math.sk:{m3[x]%(m2[x]*(sqrt(m2[x])))}
.math.ku:{(m4[x]%(m2[x] xexp 2))-3}

/### beta ###
/# Description: The beta of two lists
/# Parameters : x list float
/#              y list float
/# Returns    : atom float
.math.beta:{cov[.math.perchng[x];.math.perchng[y]%var[.math.perchng[y]]]};

/################# CHANGE & RETURN  #################

/### Percentage change ###
/# Description: Percentage change between each item in a list
/# Parameters : x list float
/# Returns    : list float
.math.perchng:{neg 1-.math.greturn[x]}

/### Gross return ###
/# Description: Gross return of each item in a list
/# Parameters : x list float
/# Returns    : list float
.math.greturn:{(-1_x)%(1_x)}

/### Simple return ###
/# Description: Simple return of each item in a list
/# Parameters : x list float
/# Returns    : list float
.math.sreturn:{((-1_x)-(1_x))%(1_x)}

/### Log return ###
/# Description: Logarithmic return of each item in a list
/# Parameters : x list float
/# Returns    : list float
.math.lreturn:{log .math.greturn[x]}

/### Simple rate of return ###
/# Description: Simple rate of return for each item in a list
/# Parameters : x list float
/#              y atom float time periods
/# Returns    : list float
.math.sarr:{((sreturn[x]+1) xexp y)-1}

/### Log rate of return ###
/# Description: Log rate of return for each item in a list
/# Parameters : x list float
/#              y atom float time periods
/# Returns    : list float
/Where x is price and y is the number of returns in a year 
.math.larr:{y*lreturn[x]}

/################# PROBABILITY #################

/### Cumulative normal density function ###
/# Description: Calculates cumulative normal density function
/# Parameters : x list float
/# Returns    : list float
.math.ncdf:{
    {
    b1: 0.319381530;
    b2:-0.356563782;
    b3: 1.781477937;
    b4:-1.821255978;
    b5: 1.330274429;
    p:  0.2316419;
    c:  0.39894228;
    $[x>=0;
      [t:1%(1+(p*x));1.0-c*(exp 0.5*neg x*x)*t*b1+t*b2+t*b3+t*b4+t*b5];
      [t:1%(1-(p*x));    c*(exp 0.5*neg x*x)*t*b1+t*b2+t*b3+t*b4+t*b5]
    ]}each x
  }

/### Normal distribution curve ###
/# Description: Normal distribution curve
/# Parameters : list x float
/# Returns    : list float
.math.ndc:{
    (1%sqrt 2*pi)*exp(neg 0.5*x*x)
  }

/################# RANDOM NUMBERS #################

/### Normally distributed random numbers, Box-Muller transform ###
/# Description: Box-Muller transform
/# Parameters : x atom integer, number of randoms required
/# Returns    : list float
.math.randn:{
    // 4%pi uniformly distributed randoms are thrown away
    // therefore produce more in anticipation of this
    xn: ceiling x*4%pi;     
    r1:-1+2*xn?1.000000;
    r2:-1+2*xn?1.000000;
    w:(r1*r1)+(r2*r2);
    n:x#where w <= 1.0;
    w:w[n];
    r1:r1[n];
    w:sqrt((-2.0 * log w)%w);
    r1*w
  }
