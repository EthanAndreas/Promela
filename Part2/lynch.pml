mtype = {ack, nack, err}

proctype transfer(chan inc, outc, chin, chout)
// inc and out are the channel between the process and the application
// chin and chout are the channel between two process
{
    int d, n;
    inc?d;

    end :do
    :: chin?ack,n ->
        outc!n;
        end :inc?n;
        chout!ack,n;

    :: chin?nack,n ->
        outc!n;
        chout!ack,d;
    
    :: chin?err,n ->    
        chout!nack,d;
    od;
}

init
{ 
    chan incA = [2] of {int}; 
    chan outcA = [2] of {int};
    chan incB = [2] of {int}; 
    chan outcB = [2] of {int};
    chan chin = [2] of {byte, int};
    chan chout = [2] of {byte, int};
    atomic {
    run transfer(incA, outcA, chin, chout);
    run transfer(incB, outcB, chout, chin);
    incA!1;
    incA!2;
    incB!3;
    incB!4;
    chin!err,0;
    }
}
