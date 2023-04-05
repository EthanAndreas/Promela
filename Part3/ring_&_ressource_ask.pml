// Exercice 1

// tous les codes passent "syntax check"

// 1.1 & 2.2

#define N 4
#define ELU 1
#define NON_ELU 0

typedef tabcan {
    chan to[N] = [1] of {short}
}

tabcan from[N];

proctype electeur(short numproc; chan em1, em2, em3, rec1, rec2, rec3)
{
    byte m1, m2, m3, min, role, somme_role, fin;

   end :do
    :: 
        // on transmet son numéro au 3 autres processus
        em1!numproc; em2!numproc; em3!numproc;
        rec1?m1; rec2?m2; rec3?m3;

        // si le processus courant a le plus petit numéro, il est élu
        if
            :: numproc < m1 && numproc < m2 && numproc < m3 -> role = ELU;
            :: else -> role = NON_ELU;
        fi;

        // on indique à tous les processus son rôle
        em1!role; em2!role; em3!role;
        // on attend la réponse de tous les processus
        rec1?m1; rec2?m2; rec3?m3;

        // on doit vérifier qu'un seul processus est élu
        somme_role = m1 + m2 + m3 + role;

        if
        :: somme_role == 1 -> 
            em1!fin; em2!fin; em3!fin;
            break;
        :: else -> skip;
        fi;
    od; 

    // vérifier qu'il y a qu'un processus élu et qu'il est le minimum des numéros de proc
    rec1?m1; rec2?m2; rec3?m3;
    
    if
    :: m1 == fin && m2 == fin && m3 == fin ->
        assert(somme_role == 1);
    fi;

    if 
        :: role == ELU -> printf("Le processus %d est élu\n", numproc);
        :: else -> skip;
    fi;
}

init
{ 
    atomic 
    {
        run electeur(1,from[0].to[1],from[0].to[2],from[0].to[3],from[1].to[0],from[2].to[0],from[3].to[0]);
        run electeur(2,from[1].to[0],from[1].to[2],from[1].to[3],from[0].to[1],from[2].to[1],from[3].to[1]);
        run electeur(3,from[2].to[0],from[2].to[1],from[2].to[3],from[0].to[2],from[1].to[2],from[3].to[2]);
        run electeur(4,from[3].to[0],from[3].to[1],from[3].to[2],from[0].to[3],from[1].to[3],from[2].to[3]);
    }
}


// Exercice 2
// 2.1 & 2.2

/*

mtype = {ing_farine, ing_sucre, ing_oeuf, inf_farine, inf_sucre, inf_oeuf};

chan INGREDIENT = [3] of {byte};
chan INFO = [3] of {byte};

proctype fournisseur() {

    // permet de savoir quand est-ce que les patissiers ont finis
    int count = 0;

    // on ajoute les ingrédients
    INGREDIENT!ing_farine;
    INGREDIENT!ing_sucre;
    INGREDIENT!ing_oeuf;

    do
    :: count < 3 ->
        if 
            :: INFO?inf_farine ->
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
            :: INFO?inf_sucre ->
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
            :: INFO?inf_oeuf -> 
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
        fi;
    od;
}

proctype patissierFarine() {
    do
    :: 
        if
        :: INGREDIENT?ing_sucre -> 
            if 
            :: INGREDIENT?ing_oeuf -> 
                INFO!inf_farine;
                break;
            fi;
        fi;
    od;
}

proctype patissierSucre() {
    do
    :: 
        if
        :: INGREDIENT?ing_farine -> 
            if 
            :: INGREDIENT?ing_oeuf -> 
                INFO!inf_sucre;
                break;
            fi;
        fi;
    od;
}
proctype patissierOeuf() {
    do
    ::
        if
        :: INGREDIENT?ing_farine -> 
            if 
            :: INGREDIENT?ing_sucre -> 
                INFO!inf_oeuf;
                break;
            fi;
        fi;
    od;
}

init 
{
    run fournisseur();
    run patissierFarine();
    run patissierSucre();
    run patissierOeuf();
}

*/

// 2.3
/*
L'algorithme est bloquant dans le cas ci-contre :
le premier patissier récupère le sucre et demande l'oeuf
le deuxième patissier récupère la farine et demande l'oeuf
le troisième patissier récupère l'oeuf et demande la farine
Les deux premiers attendent l'oeuf pour finir et le troisième qui a réquisitionné l'oeuf attend la farine 
pour finir qui est elle même réquisitionnée par le deuxième patissier.
*/

// 2.4
/*
mtype = {ing_farine, ing_sucre, ing_oeuf, inf_farine, inf_sucre, inf_oeuf};

chan INGREDIENT = [3] of {byte};
chan INFO = [3] of {byte};

proctype fournisseur() {

    // permet de savoir quand est-ce que les patissiers ont finis
    int count = 0;

    // on ajoute les ingrédients
    INGREDIENT!ing_farine;
    INGREDIENT!ing_sucre;
    INGREDIENT!ing_oeuf;

    do
    :: count < 3 ->
        if 
            :: INFO?inf_farine ->
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
            :: INFO?inf_sucre ->
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
            :: INFO?inf_oeuf -> 
                count = count + 1;
                INGREDIENT!ing_farine;
                INGREDIENT!ing_sucre;
                INGREDIENT!ing_oeuf;
        fi;
    od;
}

proctype patissierFarine() {
    do
    :: 
        if
            :: INGREDIENT?ing_sucre -> 
                if
                    :: INGREDIENT?ing_oeuf -> 
                        INFO!inf_farine;
                        break;
                fi;
            :: INGREDIENT?ing_oeuf -> 
                if
                    :: INGREDIENT?ing_sucre -> 
                        INFO!inf_farine;
                        break;
                fi;
        fi;
    od;
}

proctype patissierSucre() {
    do
    ::
        if
            :: INGREDIENT?ing_farine -> 
                if
                    :: INGREDIENT?ing_oeuf -> 
                        INFO!inf_sucre;
                        break;
                fi;
            :: INGREDIENT?ing_oeuf -> 
                if
                    :: INGREDIENT?ing_farine -> 
                        INFO!inf_sucre;
                        break;
                fi;
        fi;
    od;
}
proctype patissierOeuf() {
    do
    ::
        if
            :: INGREDIENT?ing_farine -> 
                if
                    :: INGREDIENT?ing_sucre -> 
                        INFO!inf_oeuf;
                        break;
                fi;
            :: INGREDIENT?ing_sucre -> 
                if
                    :: INGREDIENT?ing_farine -> 
                        INFO!inf_oeuf;
                        break;
                fi;
        fi;
    od;
}

init 
{
    run fournisseur();
    run patissierFarine();
    run patissierSucre();
    run patissierOeuf();
}
*/

/*
Dans le cas où il choisit un ordre aléatoire, le patissier va prendre l'ingrédient choisit
aléatoirement et va vérifier si l'autre ingrédient est disponible, si oui il va le prendre,
si non il va attendre que l'autre ingrédient soit disponible. Cela laisse ainsi une possiblité
d'interblocage. Si nous voulions supprimer cet interblocage, nous pourrions vérifier si les deux
ingrédients sont disponibles avant de prendre l'un d'entre eux, on utiliserait un mécanisme de
prévention.
*/