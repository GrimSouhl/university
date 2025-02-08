program MinMax;

begin

   var x:= 0;
   var y:= 0;
   var minimum:= 0;
   var maximum:= 0;

  proc min_max(x, y, min, max) is begin
      if x <= y then begin
         min:= x;
         max:= y
      end
      else
         call min_max(y, x, min, max)
   end;
 
   proc show() is begin
      print '  x = '; print x;
      print '  y = '; print y;
      print '  minimum = '; print minimum;
      print '  maximum = '; print maximum;
      print '\n'
   end;

   x:= 12;
   y:= 8;
   call show();
   call min_max(x, y, minimum, maximum);
   call show();

   print '----------\n';

   x:= 6;
   y:= 75;
   call show();
   call min_max(x, y, minimum, maximum);
   call show()

end

// expected output:
// Program MinMax finalized.
//  x = 12  y = 8  minimum = 0  maximum = 0
//  x = 12  y = 8  minimum = 8  maximum = 12
// ----------
//  x = 6  y = 75  minimum = 8  maximum = 12
//  x = 6  y = 75  minimum = 6  maximum = 75
//
// Memory dump: [(0,1)]
