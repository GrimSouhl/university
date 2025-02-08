program Divide;

// a simple program to compute quotient and remainder

begin

   var x:= 27;
   var y:= 5;

   print 'computing ';
   print x;
   print ' divided by ';
   print y;
   print '\n';

   if !(y = 0) then  // do not divide by zero
      begin
         var q:= 0;
         var r:= 0;

         while y <= x do begin
            x:= x - y;
            q:= q + 1
         end;
         r:= x;

         print 'quotient: ';
         print q;
         print ' remainder: ';
         print r
      end
   else
      print 'cannot divide by zero'
end

// expected output:
// Program Divide finalized.
// computing 27 divided by 5
// quotient: 5 remainder: 2
// Memory dump: [(0,1)]
