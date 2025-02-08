program CallByReference;

begin
   var x:= 5;
   var y:= 23;

   proc up_down(a, b) is begin
      a:= a + 1;
      b:= b - 1
   end;

   print 'before calling up_down():\n';
   print '  x= '; print x;
   print '  y= '; print y;
   print '\n';
   
   call up_down(x, y);

   print 'after calling up_down():\n';
   print '  x= '; print x;
   print '  y= '; print y;
   print '\n'  
end

// expected output:
// Program CallByReference finalized.
// before calling up_down():
//   x= 5  y= 23
// after calling up_down():
//   x= 6  y= 22
//
// Memory dump: [(0,1)]
