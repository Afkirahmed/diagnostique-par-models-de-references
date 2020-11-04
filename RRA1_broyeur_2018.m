function [parit,decisions]=RRA1_broyeur_2018(sauv_t,sauv_u,sauv_y,seuil,affichage)
%[parit,decisions]=RRA1_broyeur_2018(sauv_t,sauv_u,sauv_y,seuil,affichage)
close all
%parametres du broyeur
k1=0.5;
k2=0.3;
k3=0.1;
Ts=0.01;
C=[1-k3 1-k2 ; 1 0; 0 1; 0 k2; k3 0];
D=[0;0;0;k1;1-k1];
[m,q]=size(sauv_y);
%les RRAs dans une matrice r de dimensions appropriées
r=[-0.6371   -0.1911   -0.0411;
    0.5736    0.1721   -0.0627;
    0.4917   -0.1525    0.0264;
   -0.1525    0.9543    0.0079;
   -0.0020   -0.0006    0.9968];
%calcul du vecteur de parité
ybis=zeros(m,q);
[n,p]=size(r);
parit=zeros(m,p);
for i = 1:m
    ybis(i,:)=sauv_y(i,:)-sauv_u(i)*D';
    parit(i,:)=ybis(i,:)*r;
end;

%%détection des défauts
decisions=zeros(m,p);
for i=1:p
   %% ind= abs(parit(:,i))>seuil(i,1);
      ind=find(abs(parit(:,i))>seuil(i,1));
    decisions(ind,i)=1;
end;

if affichage==1,
    for i=1:p
        figure (i)
        subplot(2,1,1)
        plot(sauv_t, parit(:,i),'k-')
        title('Résidual ri')
        subplot(2,1,2)
        plot(sauv_t, decisions(:,i),'k-')
        axis([0 1000 0 1.2])
        title('Décision')
    end;
end;