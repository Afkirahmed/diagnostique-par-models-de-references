function [parit,decisions]=RRA2_broyeur_2018(sauv_t,sauv_u,sauv_y,seuil,affichage)
close all
%parametres du broyeur
k1=0.5;k2=0.3;k3=0.1;Ts=0.01;
C=[1-k3 1-k2 ; 1 0; 0 1; 0 k2; k3 0]; D=[0;0;0;k1;1-k1];
F=[1 1 0;
   1 0 0;
   0 1 0;
   0 1 1;
   1 0 1];
%calcul de la matrice de changement de base P
C1=C(1:2,:);
C2=C(3:5,:);
P=[-inv(C1')*C2';eye(3,3)]

%calcul de la RRA permettant d'évaluer r1
Fm1=F(:,1);
Fp1=[F(:,2) F(:,3)];
A1=P'*Fm1*Fm1'*P;
B1=P'*Fp1*Fp1'*P;
[v1,d1]=eig(A1,B1);
w1=P*v1';
w11=w1(:,3);


%calcul de la RRA permettant d'évaluer r2
Fm2=F(:,2);
Fp2=[F(:,1) F(:,3)];
A2=P'*Fm2*Fm2'*P;
B2=P'*Fp2*Fp2'*P;
[v2,d2]=eig(A2,B2);
w2=P*v2';
w22=w2(:,3);

Fm3=F(:,3); Fp3=[F(:,1) F(:,2)]; A3=P'*Fm3*Fm3'*P; B3=P'*Fp2*Fp2'*P; [v3,d3]=eig(A3,B3);
w3=P*v3'; w33=w3(:,3);


r=[w11 w22 w33]

%calcul du vecteur de parité
[m,q]=size(sauv_y);
ybis=zeros(m,q);
[n,p]=size(r);
parit=zeros(m,p);
for i = 1:m
    ybis(i,:)=sauv_y(i,:)-sauv_u(i)*D';
    parit(i,:)=ybis(i,:)*r;
end;

%détection des défauts
decisions=zeros(m,p);
for i=1:p
    ind=find(abs(parit(:,i))>seuil(i,1));
    decisions(ind,i)=1;
end;

if affichage==1,
    for i=1:p
        figure (i)
        subplot(2,1,1)
        plot(sauv_t, parit(:,i),'k-')
        title('Résidu ri')
        subplot(2,1,2)
        plot(sauv_t, decisions(:,i),'k-')
        axis([0 1000 0 1.2])
        title('Décision')
    end;
end;