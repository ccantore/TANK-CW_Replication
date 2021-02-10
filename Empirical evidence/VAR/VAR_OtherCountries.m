%%=========================================================================
% Replication code for "Workers, Capitalists, and the Government:
% Fiscal Policy and Income (Re)Distribution"
% by C. Cantore and L. B. Freund
% Journal of Monetary Economics
% This file: compute impulse responses for Australia/Canada/UK
%%=========================================================================

%--------------------------HOUSEKEEPING----------------------------------------------
close all; clear; clc;
addpath('Functions');

%--------------------------PRELIMINARIES------------------------------------------
Yraw=xlsread('Data\Data_AusCanUK.xlsx','can_data_raw'); % T (periods) rows by M (endogenous variables) columns

% Settings
constant = 3;        % 0: no det. variable; 1: constant, 2 if linear trend (in addition to constant), 3 if quadratic trend (ditto)
c=1;
sample_type='sample_9';
p = 2;               % Number of lags on dependent variables            
hor = 15;            % Horizon to compute impulse responses
ndraws = 10000;      % Total number of draws (note: no burn-in given MC integration rather than Gibbs Sampling)

%--------------------------VARIABLE NAMES-----------------------------------------
names{1}='GOV';
names{2}='TAX';
names{3}='GDP';
names{4}='LS';
names{5}='RINT';

%--------------------------DATA HANDLING------------------------------------------
% Select based on sample period [need before rest to make conformable]

if strcmp(sample_type,'sample_9')
    Yraw=Yraw(1:152,:);
elseif strcmp(sample_type,'sample_10')
    Yraw=Yraw(1:72,:);
end 

% Define variables
gov=Yraw(:,1); tax=Yraw(:,2); gdp=Yraw(:,3); ls=Yraw(:,4); rint=Yraw(:,5);
Y=Yraw;
[Traw M] = size(Y);  % Get initial dimensions of dependent variable
W=(1:Traw)';         % For linear trend
W2=W.^2;             % For quadratic trend

% Generate lagged Y matrix
Ylag = mlag2(Y,p); 

% Define final X matrix
if constant==3
X = [ones(Traw-p,1) W(1:Traw-p,:) W2(1:Traw-p,:) Ylag(p+1:Traw,:)];
elseif constant==2
X = [ones(Traw-p,1) W(1:Traw-p,:) Ylag(p+1:Traw,:)];
elseif constant==1
 X = [ones(Traw-p,1) Ylag(p+1:Traw,:)];
else
 X = Ylag(p+1:Traw,:);
end

K=size(X,2);  % size of final X matrix
n = K*M;      % total number of parameters (size of vector alpha)
Z = kron(eye(M),X); % block diagonal matrix Z
Y=Y(p+1:Traw,:); % form Y accordingly (delege first p (lag length) rows to match X-matrix dimensions)
T = Traw - p; % T is the actual time obs in Y and X (lose p lags)

% Preallocate
birf=zeros(M*p,M*p,hor);
irf=zeros(M,M,p,ndraws);

%-----------------------------ESTIMATION-----------
% Specify prior dummies
B0=0;
N0=0;
nu0=0;

% OLS estimates
A_OLS=(X'*X)\X'*Y;
a_OLS=vec(A_OLS);
res=Y-X*A_OLS;
SSE=res'*res;
S_OLS=cov(res);
sh=res*inv(chol(S_OLS));

% Initialize Bayesian posterior parameters using OLS values
nu=T+nu0; 
N=N0+X'*X; 
invN = inv(N); 
ALPHA= invN*(N0*B0+X'*X*A_OLS); 
S=nu0/nu+T/nu*S_OLS+(1/nu)*(A_OLS-B0)'*N0*invN*(X'*X)*(A_OLS-B0); 
V_OLS=diag(S);

for i=1:ndraws
    % Posterior of alpha|S,Data ~ Normal
    V_post=kron(S,invN);
    alpha=vec(ALPHA);
    Bet(:,i)=mvnrnd(alpha,V_post,1)';
     
    % Posterior of SIGMA|Data ~ iW
    Sigma(:,:,i)=wishrnd(inv(S)/nu,nu); 
    Sigma(:,:,i)=inv(Sigma(:,:,i));
     
    % Impulse Responses
    BigS=zeros(M*p,M*p);
    BigS(1:M,1:M)=chol(Sigma(:,:,i))'; % Cholesky identification
    for k=1:hor
    birf(:,:,k)=companion(Bet(:,i),p,M,constant)^(k-1)*BigS; % compute IRF
    irf(:,:,k,i)=birf(1:M,1:M,k);          
    end    
end

%{
%-----------------------------Plot individual country IRF-----------
% Not used in actual paper, ugly formatting

gnorm1=max(squeeze(prctile(irf(1,1,:,:),[50],4))); %max of v1 to shock 1;

figure(1)
for i=1:numel(names)
    imp=[squeeze(prctile(irf(i,1,:,:),[16],4)) squeeze(mean(irf(i,1,:,:),4)) squeeze(prctile(irf(i,1,:,:),[84],4))];
    subplot(3,2,i)
    plot(imp(:,1:3)/gnorm1)
    hold;
    plot(zeros(1,hor),'-')
    title(names{i})
    axis tight
    xlim([1 hor])
    set(gca,'XTick',0:5:hor)
end
%}