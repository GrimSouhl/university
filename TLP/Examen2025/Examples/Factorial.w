program Factorial;

// a simple program to compute the factorial of n

begin
   var n:= 6;
   var fact:= 1;
   var i:= 0;

   i:= n;

   while 1 <= i do begin
      fact := fact * i;
      i := i - 1
   end;

   print 'the factorial of ';
   print n;
   print ' is ';
   print fact
end

// expected output:
// Program Factorial finalized.
// the factorial of 6 is 720
// Memory dump: [(0,1)]
