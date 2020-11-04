function [sauv_t,sauv_u,sauv_x,sauv_y]=simulateur_broyeur_2018(sortie,amplitude_defaut,affichage)
%[sauv_t,sauv_u,sauv_x,sauv_y]=simulateur_broyeur_2018(sortie,amplitude_defaut,affichage)

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
C=[1-k3 1-k2;1 0 ;0 1; 0 k2;k3 0] ;
D=[0;0;0;k1;1-k2];
F=[1 1 0;
   1 0 0;
   0 1 0;
   0 1 1;
   1 0 1];
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
bruit=[0.02.*randn(m,1) 0.02.*randn(m,1) 0.02.*randn(m,1) 0.02.*randn(m,1) 0.02.*randn(m,1)];

%incertitude de modèle (non prise en compte)
dk3=k3.*5/100.*randn(m,1);

%séquence de défaut capteur
dc=amplitude_defaut.*[0.*ones(round(30/100*tf/Ts),3); 
[1*ones(round(3/100*tf/Ts),1) 0*ones(round(3/100*tf/Ts),2)];
0*ones(round(17/100*tf/Ts),3);
[0*ones(round(3/100*tf/Ts),1) 1*ones(round(3/100*tf/Ts),1) 0*ones(round(3/100*tf/Ts),1)];
0*ones(round(17/100*tf/Ts),3);
[0*ones(round(3/100*tf/Ts),2) 1*ones(round(3/100*tf/Ts),1)];
0*ones(round(27/100*tf/Ts),3)];

Ad = [0.9980    0.0006;
    0.0010    0.9901];
Bd =[0.0010;
    0.0050];
Cd =[0.9000    0.7000;
    1.0000         0;
         0    1.0000;
         0    0.3000;
    0.1000         0];
Dd =[0;
         0;
         0;
    0.5000;
    0.5000];
TS = 0.0100;


x=x0;
sauv_x=[];
sauv_y=[];
sauv_t=[];
for i=1:1:m,
    sauv_x=[sauv_x;x'];
    sauv_y=[sauv_y;(Cd*x+Dd*u(i,1))'];
    sauv_t=[sauv_t;i-1];
    x=Ad*x+Bd*u(i,1);
end;
sauv_y=sauv_y+bruit+dc*F';
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

if sortie==3
figure (2)
subplot(5,1,1)
plot(sauv_t, sauv_y(:,1), 'k-')
title('Sortie y1')
subplot(5,1,2)
plot(sauv_t, sauv_y(:,2), 'k-')
title('Sortie y2')
subplot(5,1,3)
plot(sauv_t, sauv_y(:,3), 'k-')
title('Sortie y3')
subplot(5,1,4)
plot(sauv_t, sauv_y(:,4), 'k-')
title('Sortie y4')
subplot(5,1,5)
plot(sauv_t, sauv_y(:,5), 'k-')
title('Sortie y5')
end;

if sortie==2
figure (2)
subplot(3,1,1)
plot(sauv_t, sauv_y(:,1), 'k-')
title('Sortie y1')
subplot(3,1,2)
plot(sauv_t, sauv_y(:,2), 'k-')
title('Sortie y2')
subplot(3,1,3)
plot(sauv_t, sauv_y(:,3), 'k-')
title('Sortie y3')
sauv_y=sauv_y(:,1:3);
end;

if sortie==1
figure (2)
subplot(1,1,1)
plot(sauv_t, sauv_y(:,1), 'k-')
title('Sortie y1')
sauv_y=sauv_y(:,1);
end;

end;

