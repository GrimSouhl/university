function h = plotcov2d(men, C, co)

if numel(men) ~= length(men), 
    error('M must be a vector'); 
end
if ~( all(numel(men) == size(C)) )
    error('Dimensionality of M and C must match');
end

men=men(:);
npts=50;
tt=linspace(0,2*pi,npts)';
x = cos(tt);
y=sin(tt);
ap = [x(:) y(:)]';
[v,d]=eig(C); 
sdwidth=1;
d = sdwidth * sqrt(d); % convert variance to sdwidth*sd
bp = (v*d*ap) + repmat(men, 1, size(ap,2)); 
h = plot(bp(1,:), bp(2,:), co);

