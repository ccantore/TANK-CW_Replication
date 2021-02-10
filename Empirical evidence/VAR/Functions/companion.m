% Construct the companion representation of a state space model
% with state vector theta p lags in the VAR representation and 
% n variables and c=1 constant c=0 no constant.


function C = companion(theta,p,n,c)
np = (n*p+c);
theta = theta';
for i = 1:n
    M(i,1:np) = theta((i-1)*np+1:i*np);
end
if c>0;
    M = M(:,1+c:end);
end
C = [M ; eye(n*(p-1)) zeros(n*(p-1),n)];


%Fcomp = [F(:,1+const:nvar*nlag+const); eye(nvar*(nlag-1)) zeros(nvar*(nlag-1),nvar)];
%Fcomp=[F(:,1+const:M*p+const);eye(M*(p-1))
