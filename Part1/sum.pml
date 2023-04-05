int i, sum;

proctype sum_func(int n) 
{
	i = 1;
	sum = 0;
	do
	:: i <= n ->
		sum += i;
		i++;
	:: else ->
		skip;
	od;
	printf("Sum of %d = %d", n, sum)
}

init
{
	run sum_func(10)
}
