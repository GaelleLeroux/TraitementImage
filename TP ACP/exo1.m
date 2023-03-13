clear variables;
close all;

t=0:0.1:6;
phi = pi/2;
epsi = -1;
taille = size(t);
s1 = epsi*sin(t)+0.05*randn(1,taille(1,2));
s2 = epsi*sin(t+phi)+0.05*randn(1,taille(1,2));

figure(1)
subplot(121);hold on;plot(t,s1,'r');plot(t,s2,'b');legend("s1","s2"); title("signaux");
subplot(122);plot(s1,s2,'om');grid on;title("nuage de points"); xlabel("s1"),ylabel("s2");

Y = [s1',s2'];
taille = size(Y);
n = taille(1,1);
m = taille(1,2);
X = Y - mean(Y);

M = (1/n)*X'*X;

[V,D] = eig(M);
d = sort(real(diag(D)));
lambda = flipud(d);
P = fliplr(V);


somme = ones(1,m)*lambda;
inertie_total = 100*(tril(ones(m,m))*lambda)/somme;
inertie_axe = 100*lambda / somme;

figure(2)
plot(lambda,'-*b');(1/n)*X'*X;
title("courbe valeur propre");

figure(3)
plot(inertie_total,'-*b');
title("Inertie total");

figure(4)
plot(inertie_axe,'-*b');
title("Inertie axe");

Xstar = X*P;

figure(5)
plot(Xstar(:,1),-Xstar(:,2),'*b');
grid on;
ylabel("axe e2");
xlabel("axe e1");
title("Plan factoriel(e1,e2)");
axis equal


theta = 0:0.01:2*pi;
x = cos(theta);
y = sin(theta);

z = X./(ones(n,1)*std(Y));

for j=1:m 
    xx = z(:,j)'*Xstar(:,1)./(n*sqrt(lambda(1)));
    yy = z(:,j)'*Xstar(:,2)./(n*sqrt(lambda(2)));
    figure(6)
    hold on;
    plot(xx,yy,'ro');
    plot(x,y);
    ylabel("axe e2");
    xlabel("axe e1");
    title("Plan factoriel(e1,e2)");
    axis equal;
    grid on;
end

Xrec = Xstar(:,1)*P(:,1)';

figure(7)
subplot(121);hold on;plot(t,s1,'r');plot(t,Xrec(:,1),'b');legend("s1","s1,rec"); title("Reconstructions de s1");
subplot(122);hold on;plot(t,s2,'r');plot(t,Xrec(:,2),'b');legend("s2","s2,rec"); title("Reconstructions de s2");

% chargement des signaux
load Ex2_signaux;
Y=D;
[n,m]=size(Y); % n=768 abscisses, m=20 signaux
% affichage des 20 signaux
figure(8);
for i=1:m
subplot(m,1,i);
title('Signaux originaux','interpreter','latex');
plot(Y(:,i));
axis off;
end

