program Swap;

// the swap program in WHILE

begin
   var x:= 5;
   var y:= 7;
   var z:= 0;

   print 'before swap:\n';
   print 'x= ';
   print x;
   print ', ';
   print 'y= ';
   print y;

   z:= x;
   x:= y;
   y:= z;

   print '\nafter swap:\n';
   print 'x= ';
   print x;
   print ', ';
   print 'y= ';
   print y
end

// expected output:
// Program Swap finalized.
// before swap:
// x= 5, y= 7
// after swap:
// x= 7, y= 5
// Memory dump: [(0,1)]
