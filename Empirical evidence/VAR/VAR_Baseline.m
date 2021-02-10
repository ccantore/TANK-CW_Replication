%%=========================================================================
% Replication code for "Workers, Capitalists, and the Government: 
% Fiscal Policy and Income (Re)Distribution"
% by C. Cantore and L. B. Freund
% Journal of Monetary Economics
% This file: compute impulse responses for US
% NB: I wrote this code early in my master's, so please forgive the terrible 
% coding style. We also kept a bunch of options that allow replicating
% the robustness checks contained in the Bank of England SWP version of the
% paper (e.g., different subsamples, different labor share proxies)
%%=========================================================================

%--------------------------HOUSEKEEPING----------------------------------------------
close all; clear; clc;
addpath('functions');

%--------------------------PRELIMINARIES------------------------------------------
Yraw=xlsread('Data/Data_US.xlsx','data_raw'); % starts in 1947:II

% Specify settings
constant = 3;           % baseline (constant, linear & quadratic trend)
ident_type='f14';       % baseline: f14 (alternative: bp)
sample_type='sample_6'; % baseline: sample 6
%sample_1 is 1948:I to 2007:IV, sample_2 is 1954:I-2007:IV (excl Korea War), sample_3 is 1947:II-2017:I (for BP, max period);
%sample_4 is 1947:II-2013:IV;  sample 5 is 1967:I-2007:IV; sample 6 is 1981:III to
%2007:IV. Note that SPF based shocks only available for sample_6. 
p = 2;                  % lag number            
hor = 15;               % horizon to compute impulse responses
ndraws = 10000;          % total number of draws (note: no burn-in given MC integration rather than Gibbs Sampling)
    
%--------------------------VARIABLE NAMES-----------------------------------------

if strcmp(ident_type,'bp')
if strcmp(ls_type,'components')
names{1}='Government Spending';
names{2}='Taxes';
names{3}='Labour Productivity';
names{4}='Real Wage';
names{5}='10y Real Yield';
else   
names{1}='Government Spending';
names{2}='Taxes';
names{3}='GDP';
names{4}='Labour Share';
names{5}='10y Real Yield';
end 
else
names{1}='Government Spending';
names{3}='Taxes';
names{4}='GDP';
names{5}='Consumption';
names{6}='Investment';
names{7}='Labor Share';
names{8}='Corporate Profits';
names{9}='Inflation Rate';
names{10}='10y Real Yield';
end

if strcmp(ident_type,'bp')
    % nothing needed
elseif strcmp(ident_type,'f14')
names{2}='F(1,4)' ;
end

%--------------------------DATA HANDLING------------------------------------------
%select based on sample period [need before rest to make conformable]
%first value in dataset is for 1947:II

if strcmp(sample_type,'sample_1')
    Yraw=Yraw(4:243,:);
elseif strcmp(sample_type,'sample_2')
    Yraw=Yraw(28:243,:);
elseif strcmp(sample_type,'sample_3')
    Yraw=Yraw(1:280,:);
elseif strcmp(sample_type,'sample_4')
    Yraw=Yraw(4:267,:);
elseif strcmp(sample_type,'sample_5')
Yraw=Yraw(80:243,:);     
elseif strcmp(sample_type,'sample_6')
    Yraw=Yraw(138:243,:); 
elseif strcmp(sample_type, 'sample_7') 
    Yraw=Yraw(4:137,:);  
elseif strcmp(sample_type, 'sample_8') 
 Yraw=Yraw(4:137,:);  
end 

% Key variables
gov=Yraw(:,1); tax=Yraw(:,2); gdp=Yraw(:,3); rint=Yraw(:,4); rr10=Yraw(:,5); ls1=Yraw(:,6);ls2=Yraw(:,7);ls3=Yraw(:,8);ls4=Yraw(:,9);
ls5=Yraw(:,10);ls6=Yraw(:,11); ls7=Yraw(:,12); f14_tot=Yraw(:,13); consumption=Yraw(:,14); investment=Yraw(:,15); pgdp_infl=Yraw(:,16); lCorpProfits=Yraw(:,17);

% Select based on identification method 
if strcmp(ident_type,'bp')
    Y=gov;
elseif strcmp(ident_type,'f14')
    Y=[gov f14_tot]; 
end

% Select variables 
% (note that 'ls7' corresponds to the baseline; the numbering
% is a legacy issue, but I don't want to change it in case we'd want to look
% back at previous analyses)
Y=[Y tax gdp consumption investment ls7 lCorpProfits pgdp_infl rr10]; 

[Traw M] = size(Y); % get initial dimensions of dependent variable
W=(1:Traw)';        % for linear trend
W2=W.^2;            % for quadratic trend

% Generate lagged Y matrix. This will be part of the X matrix
Ylag = mlag2(Y,p); % Y i s [T x M]. ylag is [T x (M*p)] 

%Define final X matrix
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

%-----------------------------ESTIMATION SETUP-----------
%Specify prior dummies
B0=0;
N0=0;
nu0=0;

%OLS estimates
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
ALPHA=invN*(N0*B0+X'*X*A_OLS);
S=nu0/nu+T/nu*S_OLS+(1/nu)*(A_OLS-B0)'*N0*invN*(X'*X)*(A_OLS-B0);

%--------------------------ESTIMATE-----------------------------------------

for i=1:ndraws
    %Posterior of alpha|S,Data ~ Normal
    V_post=kron(S,invN);
    alpha=vec(ALPHA);
    Bet(:,i)=mvnrnd(alpha,V_post,1)';
     
    % Posterior of SIGMA|Data ~ iW
    Sigma(:,:,i)=wishrnd(inv(S)/nu,nu); 
    Sigma(:,:,i)=inv(Sigma(:,:,i));
     
    % Impulse Responses
    BigS=zeros(M*p,M*p);
    BigS(1:M,1:M)=chol(Sigma(:,:,i))'; 
    for k=1:hor
    birf(:,:,k)=companion(Bet(:,i),p,M,constant)^(k-1)*BigS; 
    irf(:,:,k,i)=birf(1:M,1:M,k);
             
    end
end

%--------------------------IRFs------------------------------------------
%Scaling
gnorm1=max(squeeze(prctile(irf(1,1,:,:),[50],4))); %max of v1 to shock 1;

% Collect IRFs with confidence bands into matrix
% mIRF(Horizon,[low median high],Variable)
mIRF = zeros(hor,3,numel(names));

for i=1:numel(names)
mIRF(:,:,i) =[squeeze(prctile(irf(i,1,:,:),[16],4)) squeeze(prctile(irf(i,1,:,:),[50],4)) squeeze(prctile(irf(i,1,:,:),[84],4))]/gnorm1;
end

% Alternative
mIRF_Median = reshape(mIRF(:,2,:),[hor numel(names)])';
mIRF_SE = reshape(mIRF(:,2,:),[hor numel(names)])'-reshape(mIRF(:,1,:),[hor numel(names)])';

% Store, use in VAR_Plotting.m
save VarIrf_Spec irf mIRF mIRF_Median mIRF_SE names

%{
%-----------------------------Plot-----------
% Not used in actual paper
figure(1)
for i=1:numel(names)
    imp=[squeeze(prctile(irf(i,1,:,:),[16],4)) squeeze(prctile(irf(i,1,:,:),[50],4)) squeeze(prctile(irf(i,1,:,:),[84],4))];
    subplot(3,4,i)
    plot(imp(:,1:3)/gnorm1) 
    hold;
    plot(zeros(1,hor),'-')
    title(names{i})
    axis tight
    xlim([1 hor])
    set(gca,'XTick',0:5:hor)
  end

xSize = 17.5; ySize = 12.5;  xCut = 1; yCut = 1; 

 set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-xCut ySize-yCut],'PaperPositionMode','auto')
%}