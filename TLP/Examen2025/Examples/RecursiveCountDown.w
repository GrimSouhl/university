program RecursiveCountDown;

begin

   var x:= 4;
   var dummy:= 12;

   proc countdown() is begin
      var dummy:= 0;
      
      print 'x = ';
      print x;
      print '\n';

      if x <= 0 then
         skip
      else begin
         x:= x - 1;
         call countdown()
      end
   end;

   call countdown();

   print '----------\n';
   print 'x = ';
   print x;
   print ',  dummy = ';
   print dummy

end

// expected output:
// Program RecursiveCountDown finalized.
// x = 4
// x = 3
// x = 2
// x = 1
// x = 0
// ----------
// x = 0,  dummy = 12
// Memory dump: [(0,1)]
