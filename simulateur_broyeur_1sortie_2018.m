function [sauv_t,sauv_u,sauv_x,sauv_y]=simulateur_broyeur_1_sortie_2018(defaut,affichage)
%[sauv_t,sauv_u,sauv_x,sauv_y]=simulateur_broyeur_1_sortie_2018(defaut,affichage)
%affichage = 1 : trace l'entrée et l'état du système
%defaut = 0 : pas de défaut
%defaut = 1 : pas de capteur
%defaut = 2 : pas d'actionneur


close all
%parametres du broyeur
T1=5;
T2=1;
k1=0.5;
k2=0.3;
k3=0.1;
Ts=0.01;

A=[-1/T1 k2/T1;k3/T2 -1/T2];
eig(A)
B=[k1/T1; (1-k1)/T2];
C=[1-k3 1-k2] ;
D=[0;0;0;k1;1-k2];
H=[1 0 ; 0 1;0 0];
Da=[0;-1];

x0=[0.2;0.3];
tf=10;
%séquence d'entrée
u=[1.*ones(round(2/10*tf/Ts),1); 
0.3*ones(round(1/10*tf/Ts),1);
1.2*ones(round(1/10*tf/Ts),1);
0.6*ones(round(1/10*tf/Ts),1);
0.8*ones(round(2/10*tf/Ts),1);
0.3*ones(round(1/10*tf/Ts),1);
1*ones(round(2/10*tf/Ts),1)];
[m,q]=size(u);

%séquence de bruit de mesure
bruit=[0.02.*randn(m,1)];

%sequence sans défaut
if defaut==0
dy=0.*ones(round(tf/Ts),1);
du=0.*ones(round(tf/Ts),1);
end

%séquence de défaut capteur
if defaut==1
dy=[0.*ones(round(30/100*tf/Ts),1); 0.2*ones(round(30/100*tf/Ts),1); 0*ones(round(40/100*tf/Ts),1)];
du=0.*ones(round(tf/Ts),1);
end

%séquence de défaut actionneur (fuite constante en sortie du second broyeur, dérivée de la fuite négligée)
if defaut==2
du=[0.*ones(round(45/100*tf/Ts),1); 
0.3*ones(round(18/100*tf/Ts),1);
0*ones(round(37/100*tf/Ts),1)]./T2;
dy=0.*ones(round(tf/Ts),1);
end
u=u+du;

Ad = [0.9980    0.0006;
    0.0010    0.9901];
Bd =[0.0010;
    0.0050];
Cd =[0.9000    0.7000];
Dd =[0];
TS = 0.0100;

x=x0;
sauv_x=[];
sauv_y=[];
sauv_t=[];
for i=1:1:m,
    sauv_x=[sauv_x;x'];
    sauv_y=[sauv_y;(Cd*x)'];
    sauv_t=[sauv_t;i-1];
    x=Ad*x+Bd*u(i,1);
end;
sauv_y=sauv_y+bruit+dy;
sauv_u=u;

if affichage==1
figure(1)
subplot(3,1,1)
plot(sauv_t, u,'k-')
title('Entrée du système ')
subplot(3,1,2)
plot(sauv_t, sauv_x(:,1), 'k-')
title('Etat x1 du système ')
subplot(3,1,3)
plot(sauv_t, sauv_x(:,2), 'k-')
title('Etat x2 du système')

figure (2)
subplot(1,1,1)
plot(sauv_t, sauv_y(:,1), 'k-')
title('Sortie y')
end
end

