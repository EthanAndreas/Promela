proctype random(chan c)
{
    int a;

    if 
        :: a = 1;
        :: a = 0;
    fi   

    c!a;
}

init {

    int a;
    chan c = [0] of {int};
    run random(c); 
    c?a;
    printf("Rand : %d\n\n", a)
}