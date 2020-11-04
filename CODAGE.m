function [ W ] = CODAGE(G,i)
[nb_colonesG,nb_lignesG]=size(G);
for j=1 :nb_colonesG
    C=G(:,j);
    P=i.*C;
    if mod(sum(P),2)==0
        W(j)=0;
    else W(j)=1;
    end
end
end
