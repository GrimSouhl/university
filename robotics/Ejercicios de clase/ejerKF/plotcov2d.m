function h = plotcov2d(mean, C, co)

if numel(mean) ~= length(mean), 
    error('M must be a vector'); 
end
if ~( all(numel(mean) == size(C)) )
    error('Dimensionality of M and C must match');
end

mean=mean(:);
npts=50;
tt=linspace(0,2*pi,npts)';
x = cos(tt); y=sin(tt);
ap = [x(:) y(:)]';
[v,d]=eig(C); 
sdwidth=1;
d = sdwidth * sqrt(d); % convert variance to sdwidth*sd
bp = (v*d*ap) + repmat(mean, 1, size(ap,2)); 
h = plot(bp(1,:), bp(2,:), co);

