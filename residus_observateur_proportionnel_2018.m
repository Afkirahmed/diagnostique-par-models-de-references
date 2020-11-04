function [residus,decisions]=residus_observateur_proportionnel_2018_corrected(sauv_t,sauv_y,sauv_yo,seuil,affichage)
%[residus,decisions]=residus_observateur_proportionnel_2018_corrected(sauv_t,sauv_y,sauv_yo,seuil,affichage)
%seuil : vecteur des seuils � appliquer sur les r�sidus y -yo pour d�tecter les d�fauts

Seuil = [0.05; 0.2; 0.02]
close all
%parametres du broyeur
[m,q]=size(sauv_y);


%calcul des r�sidus
residus=sauv_y-sauv_yo;

%calcul de la d�cision
decisions=zeros(m,q);
for i=1:q
    ind=find(abs(residus(:,i))>seuil(i));
    decisions(ind,i)=1;
end;

if affichage==1,
    for i=1:q
        figure (i)
        subplot(2,1,1)
        plot(sauv_t, residus(:,i),'k-')
        title('R�sidu ri')
        subplot(2,1,2)
        plot(sauv_t, decisions(:,i),'k-')
        axis([0 1000 0 1.2])
        title('D�cision')
    end;
end;