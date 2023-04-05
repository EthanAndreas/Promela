int array[5];

proctype max_array(int n)
{
	int i = 0;
	int max = array[0];
	do
	:: (i < n) ->
		if 
		:: (array[i] > max) ->
			max = array[i];
		:: else ->
			skip;
		fi;
		i = i + 1;
	:: else ->
		break;	
	od
}

init
{	
	array[0] = 3;
	array[1] = 5;
	array[2] = 1;
	array[3] = 7;
	array[4] = 4;
	run max_array(5)
}