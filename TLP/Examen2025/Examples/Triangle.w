program Triangle;

begin
   var n:= 10;
   var i:= 1;

   proc print_line(i) is begin
      var j:= 1;
      while j <= i do begin
        print '*';
        j:= j + 1
      end;
      print '\n'
   end;

   while i <= n do begin
      call print_line(i);
      i:= i + 1
   end
end

// expected output:
// *
// **
// ***
// ****
// *****
// ******
// *******
// ********
// *********
// **********
//
// Memory dump: [(0,1)]
