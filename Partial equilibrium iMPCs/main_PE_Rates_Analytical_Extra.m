%%=========================================================================
% iMPCs in a partial equilibrium consumption-savings model with portfolio
% adjustment costs, based on analytical solution in Cantore & Freund (2020)

% This file provides some extra figures for interest rate effects

% Run on Matlab R2019b
% Last updated: September 2020
% For any questions please email lukas.beat.freund@gmail.com
%%=========================================================================

%% Housekeeping
%--------------------------------------------------------------------------
clear; close all; clc;
load inputSettings

%% User choices
%---------------------------------------------------------------------------
sPar.R = 1/0.99;            % gross real interest rate 

%% Analysis
%--------------------------------------------------------------------------
N = 1000;
Hor = 5;
vpsi = linspace(0.01,0.5,N);
vMPC00 = zeros(1,N);
vHorizons = 0:1:Hor;
mMPC0S = zeros(N,Hor+1);
mMu = zeros(N,2);

for iP = 1:length(vpsi)

    sPar.psi = vpsi(iP); 
    mu = roots([1, -(1+sPar.R+sPar.psi), sPar.R]);
    mu1 = min(mu);
    mu2 = max(mu);
    vMPC00(iP) = 1-mu2^(-1);
    mMu(iP,:) = mu;
    for iH = 1:length(vHorizons)
        mMPC0S(iP,iH) = (1-mu2^(-1))*mu2^(-vHorizons(iH));
        mIntRateElasticity(iP,iH) = mu2^(-vHorizons(iH)-1);
    end
       
end

% Plot interest rate elasticity against psi

fig1=figure;
p1 = plot( [0 vpsi],[1; mIntRateElasticity(:,1)],sSettings.lines.list{1},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{1});
hold on
hold off
set(gca,'FontSize',sSettings.font.size.axis,'fontname',sSettings.font.name)
xlabel('$\psi^W$','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name,'interpreter','latex');
ylabel('Interest rate elaticity of consumption','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
box on 
sSettings.plots.xSize = 17.5/2;  sSettings.plots.xCut = 0; sSettings.plots.ySize = 8.75; sSettings.plots.yCut = 0; 

set(gcf,'Units','centimeters','Position',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperSize',[sSettings.plots.xSize-sSettings.plots.xCut sSettings.plots.ySize-sSettings.plots.yCut],'PaperPositionMode','auto')

%print('fig_Spec','-dpdf','-painters')

% Plot interest rate effect for different horizons, but a fixed psi
sPar.psi =  0.0742;  
mu = roots([1, -(1+sPar.R+sPar.psi), sPar.R]);
mu1 = min(mu);
mu2 = max(mu);
vIntRateElasticity =  mu2.^(-vHorizons-1);

fig2=figure;
p1 = plot(vHorizons,vIntRateElasticity,sSettings.lines.list{1},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{1});
hold on
hold off
set(gca,'FontSize',sSettings.font.size.axis,'fontname',sSettings.font.name)
xlabel('Horizon of interest rate shock','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
ylabel('Interest rate elaticity of consumption','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
box on 

set(gcf,'Units','centimeters','Position',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperSize',[sSettings.plots.xSize-sSettings.plots.xCut sSettings.plots.ySize-sSettings.plots.yCut],'PaperPositionMode','auto')

