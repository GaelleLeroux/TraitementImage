clear variables;
close all;

% Lecture de l'image et transformation en niveaux de gris suivant rgb.
I = imread('palmier.tif');
I = im2double(I);

% Récupération de des valeurs de r,g et b et vectorisation de ces données
R =  I(:,:,1); 
r = R(:);
G =  I(:,:,2);
g = G(:);
B =  I(:,:,3);
b = B(:);

[u,v]=size(R);
Y = [r,g,b];
[n,m] = size(Y);

% Centrage des données
X = Y - mean(Y);

% Calcul de la matrice M, de ses vecteurs propres et de ses valeurs propres
M = 1/n*(X'*X); % M est la matrice de covariance
[V,D] = eig(M);
d = sort(real(diag(D))); % On réarrange les valeurs propres pour les mettres dans l'ordre décroissante 
lambda = flipud(d);
P = fliplr(V); % Comme les valeurs propres ont été réorganisées on réorganise aussi les colonnes (qui sont les vecteurs propre des M) de P
% afin de toujours avoir la même corrélation entre les vecteurs propres et
% les valeur prorpe

% Calcul de l'inertie total et de l'inertie par rapport à chaque axes
somme = ones(1,m)*lambda;
inertie_total = 100*(tril(ones(m,m))*lambda)/somme;
inertie_axe = 100*lambda / somme;

% Calcul de Xstar, la matrice associée au nouveau nuage de points
Xstar = X*P;

% Calcul du cercle unité
theta = 0:0.01:2*pi;
x = cos(theta);
y = sin(theta);

% Calcul de nos données initiales réduite
z = X./(ones(n,1)*std(Y));

% Calcul et affichage de la corrélation de nos variables suivant les axes (e1,e2)
for j=1:m 
    xx = z(:,j)'*Xstar(:,1)./(n*sqrt(lambda(1)));
    yy = z(:,j)'*Xstar(:,2)./(n*sqrt(lambda(2)));
    figure(1)
    hold on;
    plot(xx,yy,'r*');
    plot(x,y);
    if j==1
        text(xx+0.01,yy+0.01,'r');
    end
     if j==2
        text(xx+0.01,yy+0.01,'g');
     end
     if j==3
        text(xx+0.01,yy+0.01,'b');
    end
    ylabel("axe e2");
    xlabel("axe e1");
    title("Corrélation de nos variables suivant le axes (e1,e2)");
    axis equal;
    grid on;
end

% Affichage de nos courbes
figure(2)
plot(lambda,'-*b');
title("courbe valeur propre");
grid on;
xlabel('lambda');
ylabel('Valeur de lambda');

figure(3)
plot(inertie_total,'-*b');
title("Inertie total");
grid on;
xlabel("somme des axes (e1,e1+e2,e1+e2+e3,...)");
ylabel("pourcentage")

figure(4)
plot(inertie_axe,'-*b');
title("Inertie axiale");
grid on;
xlabel("numéro de l'axe(de e1 à e3)");
ylabel("pourcentage")

% On remet nos nouvelles données (calculées avec Xstar) dans le format
% d'une image
c1 = reshape(Xstar(:,1),u,v);
c2 = reshape(Xstar(:,2),u,v);
c3 = reshape(Xstar(:,3),u,v);

% On calcul l'image c4 qui contient 99.11% de notre information et c5 qui
% contient 100% de nos informations
c4 = c1+c2;
c5 = c4+c3;

% Affichage de nos images
figure(5)
subplot 231;
imshow(I);
title("Image d'origine");
subplot 232
imshow(c1);
title("Image correpondante à la 1ère composante principale");
subplot 233
imshow(c2);
title("Image correpondante à la 2ème composante principale");
subplot 234
imshow(c3);
title("Image correpondante à la 3ème composante principale");
subplot 235
imshow(c4);
title(["Image reconstruite correpondante à la somme" ; "des 2 premières composantes principales " ]);
subplot 236
imshow(c5);
title(["Image reconstruite correpondante à la somme" ; "des 3 premières composantes principales " ]);



