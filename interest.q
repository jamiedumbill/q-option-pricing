/##################################################
/### Interest methods
/##################################################

/### Basic interest ###
/.math.interest:{[principal;rate;years] principal*((1+rate) xexp years)}
.intr.bi:{x*((1+y) xexp z)}

/### Compounded interest ###
/.math.cinterest:{[principal;rate;years;compounds] principal*((1+(rate%compounds)) xexp (compounds*years))}
.intr.ci:{[p;r;y;c] p*((1+(r%c)) xexp (c*y))}

/### Continually compounded interest ###
/.math.ccinterest:{[principal;rate;years] principal * (exp (rate*years))}
.intr.cci:{x*(exp(y*z))}