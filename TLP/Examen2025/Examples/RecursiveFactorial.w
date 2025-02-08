program RecursiveFactorial;

begin
   var x:= 6;
   var y:= 1;

   proc factorial(x) is
   begin
      if x <= 0 then
         skip
      else begin
         y:= y * x;
         x:= x - 1;
         call factorial(x)
      end
    end;

    print 'factorial of ';
    print x;
    print ' is ';
    call factorial(x);
    print y
end

// expected output:
// Program RecursiveFactorial finalized.
// factorial of 6 is 720
// Memory dump: [(0,1)]
