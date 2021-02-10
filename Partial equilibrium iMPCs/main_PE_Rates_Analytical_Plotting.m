%%=========================================================================
% Effects of interest rate changes in a partial equilibrium 
% consumption-savings model with portfolio adjustment costs,
% based on analytical solution in Cantore-Freund (2020)

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
optionModel = 'W'; % choose between 'H' (hand-to-mouth) and 'W' (worker)
s = 3;             % choose shock horizon

% Structural parameters 
switch optionModel
    case 'W'
        sPar.psi = 0.0742;           % strength of adjustment costs 
        sPar.lambda = 0.7967;         % share of constrained hhds (used in computation of averages)
        legendLabels = {'Worker','PIH'};      
    case 'H'
        sPar.psi = 999999999;         % hand-to-mouth modeled as corner case with psi->infinity

        sPar.lambda = 0.1861;
        legendLabels = {'Hand-to-mouth','PIH'};
end

% Shared structural parameters
sPar.beta = 0.99;
sPar.R = 1/sPar.beta;                        % gross real interest rate

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

%% Effects of an interest rate change, holding income process constant
%---------------------------------------------------------------------------
n=0:s; 
vC = zeros(1,20);

% Impact
vC(1) = -mu2^(-(s+1));

% 0<t<=s
X1 = (mu1/mu2).^(1-n);
for iT = 1:s
    vC(iT+1) = - mu2^(iT-(s+1)) + (1/sPar.beta-mu1)*mu1^(iT-1)*mu2^(-s+1)*sum(X1(1:iT));
end

% t>s
X2 = (mu1/mu2).^(n); % helper
for iT = s+1:19
    vC(iT+1) = mu1^(iT-(s+1))*(1/sPar.beta-mu1)*mu2^(-1)*sum(X2);
end


% If one wanted to spell this out a little bit more, with s=3
%c0 = -mu2^(-4);
%c1 = -mu2^(-3) + (1/sPar.beta-mu1)*mu2^(-4);
%c2 = -mu2^(-2) + (1/sPar.beta-mu1)*(mu1*mu2^(-4)+mu2^(-3));
%c3 = -mu2^(-1) + (1/sPar.beta-mu1)*(mu1^2*mu2^(-4)+mu1*mu2^(-3)+mu2^(-2))
%b3 = mu2^(-1)*sum(X2)
% mu1^3*mu2^(-4)+mu1^2*mu2^(-3)+mu1^1*mu2^(-2)+mu1^0*mu2^(-1)
%c4 = (1/sPar.beta-mu1)*b3

% In the paper, we look at an interest rate *cut*...
vC = -vC;

% Comparison to standard PIH (psi = 0, analytical solution not applicable)
vC_PIH = zeros(1,20);

for iT = 1:20
vC_PIH(iT) = +(iT<=(s+1))*1;
end

%% Plotting
%---------------------------------------------------------------------------

IrfHor = 9;
fig1=figure;
p1 = plot(0:IrfHor-1,vC(1:IrfHor),sSettings.lines.list{1},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{1});
hold on
p2 = plot(0:IrfHor-1,vC_PIH(1:IrfHor),sSettings.lines.list{3},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{3});
plot(0:IrfHor-1,zeros(1,IrfHor),sSettings.lines.zeros,'HandleVisibility','off','Color','k','Linewidth',0.05);
hold off
set(gca,'FontSize',sSettings.font.size.axis,'fontname',sSettings.font.name)
xlabel('Time t (quarters)','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
ylabel('Percent deviation','FontSize',sSettings.font.size.default,'fontname',sSettings.font.name);
%ylim([-0.01 0.25])
legend1 = legend([p1,p2],legendLabels);
set(legend1,'Location','northeast','FontSize',sSettings.font.size.legend,'fontname',sSettings.font.name);
box on 

sSettings.plots.xSize = 17.5/2;  sSettings.plots.xCut = 0; sSettings.plots.ySize = 8.75; sSettings.plots.yCut = 0; 

set(gcf,'Units','centimeters','Position',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 sSettings.plots.xSize sSettings.plots.ySize],'PaperSize',[sSettings.plots.xSize-sSettings.plots.xCut sSettings.plots.ySize-sSettings.plots.yCut],'PaperPositionMode','auto')

if optionPrint == 1
print('fig_Consumption_Spec','-dpdf','-painters')
end


%% Done!
%----------------------------------------------------------------------------
