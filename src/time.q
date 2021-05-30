/##################################################
/### Time methods
/##################################################


/### Convert time format ###
/takes a time of hh:mm[pm/am] and turns it into a usable q time
.time.qt:{{t:string x; 		 		
	$[count t=6; 
		[t:"0",t];
		[]
	 ]; 		  			//If t doesn't have a preceding zero add it
	h:"I"$t[0 1];		 		//Take the hour component
	m:"I"$t[3 4];		 		//Take the minute component
	$[t[5]="p";                             //If the time is pm
		["t"$((h+12)*3.6e6)+(m*6e4)];   //Return time
		["t"$((h)*3.6e6)+(m*6e4)]	
	]} each x}

/### Generate a random time ###
.time.rt:{`time$(rand (24*60*60*1000)-1)}

/### Convert date format ###
.time.qd:  { {x:"-"vs string x;
	yr:("I"$x[0])-2000;
	"d"$((`int$("d"$("m"$(yr*12)+("I"$x[1])-1)))+("I"$x[2])-1)} each x}

/### Find leap years###
/Leap year from qidioms ->https://code.kx.com/trac/wiki/qidioms
.time.ly:{(sum 0=x mod/:4 100 400)mod 2}
