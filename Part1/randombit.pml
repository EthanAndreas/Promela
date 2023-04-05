byte count = 5;

proctype random(chan c) 
{ 
    byte b=0;
    byte r=0;
    
    do
        :: count > 0 -> 
            if
	            :: b=0
	            :: b=1
	        fi;
	    
        r = r * 2 + b;
	    count = count - 1

        :: else -> break
    od;

    c!r
}

init 
{ 
    byte a; 
    chan c = [1] of { byte }
    run random(c); 
    c?a; 
    printf("Rand : %d\n", a) 
} 