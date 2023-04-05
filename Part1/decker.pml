#define true 1
#define false 0
#define Aturn false
#define Bturn true
bool x, y, t;
int count = 0;

proctype A()
{ 
	x = true;
	t = Bturn;
	(y == false || t == Aturn);
	/* critical section */
	count = count + 1;
	count = count - 1;
	x = false
}
	
proctype B()
{ 
	y = true;
	t = Aturn;
	(x == false || t == Bturn);
	/* critical section */
	count = count + 1;
	count = count - 1;
	y = false
}

proctype Monitor()
{
	assert(count<=1)
}
	
init 
{
	run Monitor();
	run A(); 
	run B()
}
