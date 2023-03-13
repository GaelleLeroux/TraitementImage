function [Xstar,Xrec,inertie_axe,inertie_total,lambda,z,P] = ACP(m,n,Y,i)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
X = Y - mean(Y);

M = (1/n)*X'*X;
[V,D] = eig(M);
d = sort(real(diag(D)));
lambda = flipud(d);
P = fliplr(V);


somme = ones(1,m)*lambda;
inertie_total = 100*(tril(ones(m,m))*lambda)/somme;
inertie_axe = 100*lambda / somme;
Xstar = X*P;

theta = 0:0.01:2*pi;
x = cos(theta);
y = sin(theta);

z = X./(ones(n,1)*std(Y));
nom = {'r'; 'g'; 'b'};

for j=1:m 
    xx = z(:,j)'*Xstar(:,1)./(n*sqrt(lambda(1)));
    yy = z(:,j)'*Xstar(:,2)./(n*sqrt(lambda(2)));
    figure(i)
    hold on;
    plot(xx,yy,'ro');
    text(xx,yy,nom');
    plot(x,y);
    ylabel("axe e2");
    xlabel("axe e1");
    title("Plan factoriel(e1,e2)");
    axis equal;
    grid on;
end

Xrec = Xstar(:,1)*P(:,1)';

end

