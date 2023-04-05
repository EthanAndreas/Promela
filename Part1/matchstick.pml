mtype = {play, stop}

int matches = 10;
int matches_removed;
int matches_left = matches;

proctype player(byte id; chan game)
{
    int n;

    do 
    :: game?play,n ->
        printf("Player %d turn, it left : %d\n", id, n);

        int a = 0;
        if 
        :: n == 1 ->
            a = 1;
        :: n == 2 ->
            if 
                :: a = 1;
                :: a = 2;
            fi;
        :: n >= 3 ->
            if 
                :: a = 1;
                :: a = 2;
                :: a = 3;
            fi;
        fi; 

        n = n - a;

        if 
        :: n <= 0 ->
            matches_left = matches_left - a;
            matches_removed = matches_removed + a;
            game!stop, n;
            break;
        :: else ->
            matches_removed = matches_removed + a;
            matches_left = matches_left - a;
            game!play, n;
        fi;

    :: game?stop,n ->
        printf("Player %d wins\n", id);
        break;
    od;
}

proctype verif()
{
    assert(matches_left + matches_removed == matches);
}

init 
{
    chan game = [0] of {byte, int};
    run player(1,game);
    run player(2,game);
    run verif();
    game!play,matches;
}