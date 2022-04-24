
function [G,Gd]= gausswin(L,sigma)
%L=800; sigma = 134;
if(mod(L,2)==0)
    L=L-1;
end

j=1;

for n=-L/2:L/2
   
G(j)=(1/(sqrt(2*pi)*sigma))*(exp(-((n^2)/(2*sigma^2))));

j=j+1;

end

Gd=diff(G);