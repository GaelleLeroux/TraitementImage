clear variables;
close all;
% Exercice 2 : habitudes alimentaires 
data=  [68	76	127	60	72	68	84	68	82;
        2	4	3	3	2	3	2	2	4;
        81	74	41	81	101	102	111	68	70;
        36	34	31	37	35	40	42	44	24;
        64	115	172	82	60	76	83	57	237;
        89	53	69	84	64	33	30	38	57;
        25	93	87	13	66	6	3	14	45;
        6	12	20	4	4	8	8	7	22;
        7	3	1	12	10	6	4	12	1;
        24	33	25	21	28	23	23	13	20;
        58	38	24	41	41	26	32	51	18;
        84	90	80	136	87	14	14	9	13;
        85	91	84	135	89	134	187	159	64;
        6	7	2	3	8	5	11	6	1;
        12	18	13	13	10	6	3	10	8;
        17	15	11	11	14	14	14	14	12];

% tab_1={ 'RFA' 3;
%         'France' 6;
%         'Italie' 6;
%         'Pays Bas' 8;
%         'Belg. Lux.' 10;	
%         'Russie' 6;
%         'Irlande' 7;
%         'Danemark' 8;	
%         'Grece' 5};  
tab_1={ 'RFA';
        'France';
        'Italie';
        'Pays Bas';
        'Belg. Lux.';	
        'Russie';
        'Irlande';
        'Danemark';	
        'Grece'};  
    
tab_2={ 'Cereales';
        'Riz';
        'Pommes de terre';
        'Sucre blanc';
        'Legumes';
        'Fruits';
        'Vin';
        'Huiles vegetales';
        'Margarine';
        'Viande bov.';
        'Viande porc.';
        'Volailles';
        'Lait et deriv.';
        'Beurre';
        'Fromages';
        'Oeufs' }; 


Y = data';
[n,m] = size(Y);

X = Y - mean(Y); % fait automatiquement la moyenne sur les colonnes


M = (1/n)*(X')*X;

[P,D] = eig(M);
lambda = real(diag(D)); % les valeurs propres sont dÃ©jÃ  "rangÃ©es" on admet que 
% lorsque les valeurs propres sont trÃ¨s petites elles sont rangÃ©es.


figure(1)
plot(lambda,'-*b');
title("courbe valeur propre");


somme = ones(1,m)*lambda;
inertie_total = 100*(tril(ones(m,m))*lambda)/somme;
inertie_axe = 100*lambda / somme;

figure(2)
plot(inertie_total,'-*b');
title("Inertie total");
ylabel("pourcentage");


figure(3)
plot(inertie_axe,'-*b');
title("Inertie axe");
grid on;


Xstar = X*P(:,1:3);

figure(4)
subplot(311);
plot(Xstar(:,1),-Xstar(:,2),'*b');
grid on;
ylabel("axe e2");
xlabel("axe e1");
title("Plan factoriel(e1,e2)");
text(Xstar(:,1)+0.01, -Xstar(:,2)+0.01, tab_1')
axis equal

subplot(312);
plot(Xstar(:,1),-Xstar(:,3),'*b');
grid on;
ylabel("axe e3");
xlabel("axe e1");
title("Plan factoriel(e1,e3)");
text(Xstar(:,1)+0.01, -Xstar(:,3)+0.01, tab_1')
axis equal

subplot(313);
plot(Xstar(:,2),-Xstar(:,3),'*b');
grid on;
ylabel("axe e3");
xlabel("axe e2");
title("Plan factoriel(e2,e3)");
text(Xstar(:,2)+0.01, -Xstar(:,3)+0.01, tab_1)
axis equal
 
z = X./(ones(n,1)*std(Y));

Xstar2 = X*P;

rho = (z'*Xstar2)./(n*sqrt(ones(m,1)*lambda'));

theta = 0:0.01:2*pi;
x = cos(theta);
y = sin(theta);


figure(7)
subplot(131);
hold on;
plot(rho(:,1),rho(:,2),'*b');
plot(x,y)
xlabel("axe e1");
ylabel("axe e2");
title("Corrélation de nos donnée par rapport à  l'axe e1 et e2");
text(rho(:,1),rho(:,2), tab_2')
grid on;
axis equal

subplot(132);
hold on;
plot(rho(:,1),rho(:,3),'*b');
plot(x,y)
xlabel("axe e1");
ylabel("axe e3");
title("Corrélation de nos donnée par rapport à  l'axe e1 et e3");
text(rho(:,1),rho(:,3), tab_2')
grid on;
axis equal

subplot(133);
hold on;
plot(rho(:,2),rho(:,3),'*b');
plot(x,y)
xlabel("axe e2");
ylabel("axe e3");
title("Corrélation de nos donnée par rapport à  l'axe e2 et e3");
text(rho(:,2),rho(:,3), tab_2')
grid on;
axis equal
