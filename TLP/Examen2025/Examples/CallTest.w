program CallTest;

begin
   var y:= 10;
   var x:= 20;

   proc p(y) is x:= y * 2;

   proc q(x) is begin
      var t:= x - 2;
      call p(t)
   end;

   begin
      var x:= 5;
      var t:= 0;

      proc p(y) is x:= y + 1;

      t:= y * 3;
      call p(t);

      t:= 2 * x + 1;
      call q(t);

      y:= x;
      print 'inner x is ';
      print x;
      print '\n'
   end;

   print 'outer x is ';
   print x;
   print '\n';
   print 'outer y is ';
   print y
end

// expected output:
// Program CallTest finalized.
// inner x is 31
// outer x is 122
// outer y is 31
// Memory dump: [(0,1)]
