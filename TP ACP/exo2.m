clear variables;
close all;

t=0:0.1:6;
phi = pi;
epsi = -1;
taille = size(t);
s1 = epsi*sin(t)+0.05*randn(1,taille(1,2));
s2 = epsi*sin(t+phi)+0.05*randn(1,taille(1,2));

Y = [s1',s2'];
taille = size(Y);
n = taille(1,1);
m = taille(1,2);
X = Y - mean(Y);

[Xstar,Xrec,inertie_axe,inertie_total,lambda,z,P] = ACP(m,n,Y,1);

figure(2)
subplot(121);hold on;plot(t,s1,'r');plot(t,s2,'b');legend("s1","s2"); title("signaux");
subplot(122);plot(s1,s2,'om');grid on;title("nuage de points"); xlabel("s1"),ylabel("s2");

figure(3)
plot(lambda,'-*b');
title("courbe valeur propre");

figure(4)
plot(inertie_total,'-*b');
title("Inertie total");

figure(5)
plot(inertie_axe,'-*b');
title("Inertie axe");

figure(6)
plot(Xstar(:,1),-Xstar(:,2),'*b');
grid on;
ylabel("axe e2");
xlabel("axe e1");
title("Plan factoriel(e1,e2)");
axis equal

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


[Xstar,Xrec,inertie_axe,inertie_total,lambda,z,P] = ACP(m,n,Y,13);

figure(9)
plot(lambda,'-*b');
title("courbe valeur propre");

figure(10)
plot(inertie_total,'-*b');
title("Inertie total");

figure(11)
plot(inertie_axe,'-*b');
title("Inertie axe");

figure(12)
plot(Xstar(:,1),-Xstar(:,2),'*b');
grid on;
ylabel("axe e2");
xlabel("axe e1");
title("Plan factoriel(e1,e2)");
axis equal

theta = 0:0.01:2*pi;
x = cos(theta);
y = sin(theta);

for j=1:m 
    xx = z(:,j)'*Xstar(:,1)./(n*sqrt(lambda(1)));
    yy = z(:,j)'*Xstar(:,3)./(n*sqrt(lambda(2)));
    figure(14)
    hold on;
    plot(xx,yy,'ro');
    plot(x,y);
    ylabel("axe e3");
    xlabel("axe e1");
    title("Plan factoriel(e1,e3)");
    axis equal;
    grid on;
end % tracer du plan factoriel avec le cercle pr e1 et e3

figure(15)
plot(Xstar(:,1),-Xstar(:,3),'*b');
grid on;
ylabel("axe e3");
xlabel("axe e1");
title("Plan factoriel(e1,e3)");
axis equal

Xrec = Xstar(:,3)*P(:,3)';

figure(16);
for i=1:m
    subplot(m,1,i);
    hold on;
    plot(Xrec(:,i));
    title('Signaux reconstruit','interpreter','latex');
    plot(Y(:,i));
    axis off;
end


Xrec = Xstar(:,20)*P(:,20)';

figure(17);
for i=1:m
    subplot(m,1,i);
    hold on;
    plot(Xrec(:,i));
    title('Signaux reconstruit2','interpreter','latex');
    plot(Y(:,i));
    axis off;
end