x(1,:)= [1 1 1 -1 1 -1 -1 1 -1];
x(2,:)= [1 -1 -1 1 -1 -1 1 1 1];
y(1,:)=[1 -1 -1];
y(2,:)=[-1 -1 1];

w=x'*y;%%los pesos
epocmax=21;
s= zeros(size(x,2),epocmax); %%para las x
s2= zeros(size(y,2),epocmax); %%para las y
%%Patron de inicio:
sinit = [x(1,:)];
s2init=sign(sinit*w);

s(:,1)= sinit;
s2(:,1)= s2init;


for epoc=2 :1:epocmax
    s(:,epoc)=sign(w*s2(:,epoc-1));
    s2(:,epoc)=sign(s(:,epoc)'*w);
    if(sum(s(:,epoc)==s(:,epoc-1))==size(x,2))
        s(:,epoc)
        s2(:,epoc)
        break;
    end
end