#define p 0
#define v 1
chan sema = [0] of {bit};
int count = 0;

proctype dijkstra()
{
	do
	:: sema!p ->
		sema?v;
	od
}

proctype user()
{
	do
	:: sema?p ->
		count = count + 1;
		skip; /* critical section */
		count = count - 1;
		sema!v;
		skip; /* non critical section */
	od
}

proctype Monitor()
{
	assert(count<=1)
}

init
{ 
	run Monitor();
	atomic 
	{ 
	run dijkstra();
	run user(); run user(); run user()
	} 
}