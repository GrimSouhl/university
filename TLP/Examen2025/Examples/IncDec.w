program IncDec;

begin

  var x:= 5;
  var y:= 9;

  proc print_x_y() is begin
     print 'x = ';
     print x;
     print '  y= ';
     print y;
     print '\n'
  end;

  proc inc(x) is x:= x + 1;

  proc dec(x) is x:= x - 1;

  print 'original values:\n';
  call print_x_y();
    
  call inc(x);
  call inc(y);
  print 'after increment:\n';
  call print_x_y();

  
  call inc(x); call dec(x); call dec(x);  // x:= x - 1
  call dec(y); call dec(y); call dec(y);  // y:= y - 3
  print 'final values:\n';
  call print_x_y()

end

// expected output:
// Program IncDec finalized.
// original values:
// x = 5  y= 9
// after increment:
// x = 6  y= 10
// final values:
// x = 5  y= 7
//
// Memory dump: [(0,1)]
