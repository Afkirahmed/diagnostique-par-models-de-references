function [sauv_xo,sauv_yo]=observateur_proportionnel_broyeur_2018(sauv_t,sauv_u,sauv_y,gain,affichage)
%[sauv_xo,sauv_yo]=observateur_proportionnel_2018(sauv_t,sauv_u,sauv_y,P,affichage)
%sauv_t,sauv_u,sauv_y : temps, entrées et sorties mesurées
%P : poles de l'observateur
%affichage = 1 : trace l'entrée et l'état du système

close all
%parametres du broyeur
T1=5;
T2=1;
k1=0.5;
k2=0.3;
k3=0.1;
Ts=0.01;

if  gain==1
    L = [-0.06 ; -1.2];
end
if  gain==2
    L = [0.1; -1.4];
end
if gain==3
    L = [1 ; -1];
end
if  gain==4
    L = [13940;-17637];
end

if  gain==5
    L = [-5423 -1538];
end

%Système
A=[-1/T1 k2/T1;k3/T2 -1/T2];
B=[k1/T1; (1-k1)/T2];
C=[1-k3 1-k2];
D=[0];
x0=[0;0];

%Observateur
[m,q]=size(sauv_t);
uo=[sauv_u(:,1) sauv_y(:,1)];
Ao1=A-L*C;
Bo1=[B L];
Co1=C;
eig(Ao1)

xo1=[0;0];
sauv_xo=[];
sauv_yo=[];
for i=1:1:m
    sauv_xo=[sauv_xo;xo1'];
    sauv_yo=[sauv_yo;(Co1*xo1)'];
    xo1=(eye(size(Ao1))+Ao1.*Ts)*xo1+(Bo1.*Ts)*(uo(i,:))';
end

if affichage==1
figure(1)
subplot(3,1,1)
plot(sauv_t, sauv_u,'k-')
title('Entrée du système ')
subplot(3,1,2)
plot(sauv_t, sauv_xo(:,1), 'r-')
title('Etat estimé 1 ')
subplot(3,1,3)
plot(sauv_t, sauv_xo(:,2), 'r-')
title('Etat estimé 2')

figure(2)
plot(sauv_t, sauv_y(:,1),'k--',sauv_t, sauv_yo(:,1),'r-')
title('Sortie y1 et sortie estimée correspondante')
end