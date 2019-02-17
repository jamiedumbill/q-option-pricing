/###############################################################################
/### Title       : Miscellaneous functions
/### Type        : Library
/### Author      : Jamie Dumbill
/### Location    : q/lib/q/misc.q
/### Description : An example function to show intended file structure and also 
/###               to show code consistancy
/###############################################################################

/### Print alert ###
/# Description: Prints a message to the q interpreter
/# Parameters : Message as a string
/# Returns    : Outputs message to q interpreter
alert:{[message]`$"" sv string "### ",`$message, " ###"}

/### Step ###
/# Description: Produces a list of values from x to y at intervals z
/# Parameters : x float - start point
/#              y float - end point
/#              z float - interval between items
/# Returns    :
step:{x+0+\0.0,z+("i"$(y-x)%z)#0}
