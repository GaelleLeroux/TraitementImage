clear variables;
close all;

% Lecture de nos 6 images satellites
I1 = imread('i1.tif');
I1 = im2double(I1);

I2 = imread('i2.tif');
I2 = im2double(I2);

I3 = imread('i3.tif');
I3 = im2double(I3);

I4 = imread('i4.tif');
I4 = im2double(I4);

I5 = imread('i5.tif');
I5 = im2double(I5);

I6 = imread('i6.tif');
I6 = im2double(I6);

% Création de notre matrice Y comprenant en colonnes nos pixels de chaque
% images
Y = [I1(:),I2(:),I3(:),I4(:),I5(:),I6(:)];
[n,m] = size(Y);

% Centrage de nos données
X = Y - mean(Y);

% Calcul de la matrice M, de ses vecteurs propres et de ses valeurs propres
M = (1/n)*(X'*X); % M est la matrice de covariance
[V,D] = eig(M);
d = sort(real(diag(D)));% On réarrange les valeurs propres pour les mettres dans l'ordre décroissante 
lambda = flipud(d);
P = fliplr(V);% Comme les valeurs propres ont été réorganisées on réorganise aussi les colonnes (qui sont les vecteurs propre des M) de P
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
nom = {'1'; '2'; '3';'4';'5';'6'};

% Calcul et affichage de la corrélation de nos variables suivant les axes (e1,e2)
for j=1:m 
    xx = z(:,j)'*Xstar(:,1)./(n*sqrt(lambda(1)));
    yy = z(:,j)'*Xstar(:,2)./(n*sqrt(lambda(2)));
    figure(1)
    hold on;
    plot(xx,yy,'r*');
    text(xx,yy,nom(j));
    plot(x,y);
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
xlabel("somme des axes(e1,e1+e2,...)");
ylabel("pourcentage")

figure(4)
plot(inertie_axe,'-*b');
title("Inertie axe");
grid on;
xlabel("numéro de l'axe");
ylabel("pourcentage")

% On remet nos nouvelles données (calculées avec Xstar) dans le format
% d'une image
[u,v]=size(I6);
c1 = reshape(Xstar(:,1),u,v);
c2 = reshape(Xstar(:,2),u,v);
c3 = reshape(Xstar(:,3),u,v);
c4 = reshape(Xstar(:,4),u,v);
c5 = reshape(Xstar(:,5),u,v);
c6 = reshape(Xstar(:,6),u,v);

% On affiche tous nos nouvelles images contenant une partie de
% l'information
figure(5)
subplot 231;
imshow(c1);
title("c1");
subplot 232
imshow(c2);
title("c2");
subplot 233
imshow(c3);
title("c3");
subplot 234
imshow(c4);
title("c4");
subplot 235
imshow(c5);
title("c5");
subplot 236
imshow(c6);
title("c6");

% On affiche l'image finale reconstruite contenant 94.06% de l'information
figure(6)
imshow(c1+c2);
