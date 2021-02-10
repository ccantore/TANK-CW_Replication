%%=========================================================================
% iMPCs in a partial equilibrium consumption-savings model with portfolio
% adjustment costs, based on analytical solution in Cantore & Freund (2020)

% This file computes and plots IRFs for a one-off income shock
% (a separate version implements the matching of empirical moments)

% Run on Matlab R2019b
% Last updated: September 2020
% For any questions please email lukas.beat.freund@gmail.com
%%=========================================================================

%% Housekeeping
%--------------------------------------------------------------------------
clear; close all; clc;

%% User choices
%---------------------------------------------------------------------------
optionPrint = 0;
optionModel = 'H'; % choose between 'H' (hand-to-mouth) and 'W' (worker)
s = 3;             % choose shock horizon (0 vs 3)

% Structural parameters 
switch optionModel
    case 'W'
        sPar.psi =  0.0742;           % strength of adjustment costs 
        sPar.lambda = 0.7967;         % share of constrained hhds (used in computation of averages)
        legendLabels = {'Average','Worker','Unconstrained'};      
    case 'H'
        sPar.psi = 999999999;         % hand-to-mouth modeled as corner case with psi->infinity
        sPar.lambda = 0.1861;
        legendLabels = {'Average','Hand-to-mouth','Unconstrained'};
end

% Shared structural parameters
sPar.R = 1/0.99;                        % gross real interest rate

% Design: using my standard settings, but adjust colors depending on H/W
load inputSettings
switch optionModel
    case 'W'
        sSettings.colors.list = {[0,0,90]/255,[0.23,0.23,0.63],[0.45,0.45,0.75], [0.68, 0.68,0.88]};
    case 'H'
         sSettings.colors.list = {[255 127 0]/255,[255,170,60]/255,[255,190,133]/255,[254,237,222]/255}; 
end

%% Analytical solution: roots 
%---------------------------------------------------------------------------
mu = roots([1, -(1+sPar.R+sPar.psi), sPar.R]);
mu1 = min(mu);
mu2 = max(mu);

% add check that mu1*mu2=sPar.R (by Vieta's formula)
% and mu1+mu2 = 1+sPar.R+sPar.psi

%% iMPCs for one-off income shock
%---------------------------------------------------------------------------
% Note that unlike in the paper here I use the 'unified' version that is 
% valid for any shock horizon s, including s = 0 

% Use analytical formulas for iMPCs 
vMPC = zeros(1,20);

% On impact 
vMPC(1) = mu2^(-s)*(1-mu2^(-1)); 

% 0<t<=s
n=1:s; 
X1 = (mu1/mu2).^(1-n); % helper
for iT = 1:s
    vMPC(iT+1) = (mu2^(-s))*(1-mu2^(-1))*(mu2^(iT) - (sPar.R-mu1)*mu1^(iT-1)*sum(X1(1:iT)));
end

% t>s
X2 = (mu1/mu2).^(n); % helper
for iT = s:19
    vMPC(iT+1) = mu1^(-(s+1)+iT)*(sPar.R-mu1)*(mu2^(-1)-(1-mu2^(-1))*sum(X2));
end

% Unconstrained 
vMPC_PIH = ones(1,20)*(1-(1/sPar.R))*((1/sPar.R)^s); % beta^s(1-beta)

% Average
vMPC_Average = sPar.lambda*vMPC+(1-sPar.lambda)*vMPC_PIH;

%% Plotting
%---------------------------------------------------------------------------

IrfHor = 9;
fig1=figure;
p1 = plot(0:IrfHor-1,vMPC_Average(1:IrfHor),sSettings.lines.list{1},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{1});
hold on
p2 = plot(0:IrfHor-1,vMPC(1:IrfHor),sSettings.lines.list{2},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{2});
p3 = plot(0:IrfHor-1,vMPC_PIH(1:IrfHor),sSettings.lines.list{3},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{3});
plot(0:IrfHor-1,zeros(1,IrfHor),sSettings.lines.zeros,'HandleVisibility','off','Color','k','Linewidth',0.05);
hold off
set(gca,'FontSize',sSettings.font.size.axis,'fontname',sSettings.font.name)
xlabel('Time t (quarters)','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
ylabel('MPC out of income windfall','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
switch optionModel
    case 'W'
        ylim([-0.01 0.25])
    case 'H'
         ylim([-0.04 1])
end
legend1 = legend([p1,p2,p3],legendLabels);
set(legend1,'Location','northeast','FontSize',sSettings.font.size.legend,'fontname',sSettings.font.name);
box on 

sSettings.plots.xSize = 17.5/2;  sSettings.plots.xCut = 0; sSettings.plots.ySize = 8.75; sSettings.plots.yCut = 0; 

set(gcf,'Units','centimeters','Position',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperSize',[sSettings.plots.xSize-sSettings.plots.xCut sSettings.plots.ySize-sSettings.plots.yCut],'PaperPositionMode','auto')

if optionPrint == 1
print('fig_iMPCs_Spec','-dpdf','-painters')
end

%% Done!
%----------------------------------------------------------------------------
