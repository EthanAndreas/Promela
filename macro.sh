promel-sim(){
        spin -p -s -r -X -v -n123 -l -g -u10000 $1
}

promel-verif() {
        spin -a $1 .
        gcc -w -o pan pan.c
        ./pan -m10000
        rm pan*
}
