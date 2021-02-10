%%=========================================================================
% iMPCs in a partial equilibrium consumption-savings model with portfolio
% adjustment costs, based on Cantore & Freund (2020)

% This file solves the model using the 
% linear time iteration (LTI) algorithm of Rendahl (2017)

% Run on Matlab R2019b
% Last updated: October 2020
% For any questions please email lukas.beat.freund@gmail.com
%%=========================================================================

%% Housekeeping
%--------------------------------------------------------------------------
clear; close all; clc;
TimeStart = tic;

%% User choices
%---------------------------------------------------------------------------
optionPrint = 1;
optionModel = 'H'; % choose between 'H' (hand-to-mouth) and 'W' (worker)
Tol = 1e-13;       % choose tolerance level for LTI algorithm, default: 1e-13
pShockSize = 0.01;
IrfHor = 9;

% Structural parameters 
switch optionModel
    case 'W'
        sPar.psi =  0.0742;           % strength of adjustment costs 
        sPar.lambda = 0.7967;         % share of constrained hhds (used in computation of averages)
        legendLabels = {'Average','Worker','Unconstrained'};      
        figName = '.\Output\fig_iMPCs_H_LTI_Spec';
    case 'H'
        sPar.psi = 999999999;         % hand-to-mouth modeled as corner case with psi->infinity
        sPar.lambda = 0.1861;
        legendLabels = {'Average','Hand-to-mouth','Unconstrained'};
        figName = '.\Output\fig_iMPCs_H_LTI_Spec';
end

% Shared structural parameters
sPar.sigma = 1;        % inverse EIS
sPar.beta  = 0.99;     % discount factor
sPar.hab = 0;        % external habit coefficient
sPar.YBar = 1;         % constant income 
sPar.BBar = 0;         % steady-state savings

% Design: using my standard settings, but adjust colors depending on H/W
load inputSettings
switch optionModel
    case 'W'
        sSettings.colors.list = {[0,0,90]/255,[0.23,0.23,0.63],[0.45,0.45,0.75], [0.68, 0.68,0.88]};
    case 'H'
         sSettings.colors.list = {[255 127 0]/255,[255,170,60]/255,[255,190,133]/255,[254,237,222]/255}; 
end

%% --------------------------Deterministic Steady State--------------------------------
RBar = 1/sPar.beta;
Bss = sPar.BBar;
Yss= sPar.YBar; 
Rss = 1/sPar.beta;               %gross real rate
Css= Yss+(Rss-1)*Bss;
UCss = (Css-sPar.hab*Css)^(-sPar.sigma);

% Summarize SS and get number of variables
Xss = [Css UCss Bss Yss Rss];
NumVar = size(Xss,2);

%% --------------------------Specify Stochastic System--------------------------------
% Specify symbolic variables 
syms C UC B Y R
syms lC lUC lB lY lR
syms fC fUC fB fY fR

% Specify equations (symbolic) 
e1 = C + B - (Y + R.*lB);
e2 = UC - (C-sPar.hab*lC).^(-sPar.sigma);
e3 = UC*(1+(sPar.psi/Css)*(B-Bss))-sPar.beta*R*fUC;
e4 = Y - Yss;                              % will get shocked
e5 = R - Rss;

%Put the equations together
system = [e1;e2;e3;e4; e5];

% Useful vectors 
vXl = [lC lUC lB lY lR];   %lagged variables
vX = [C UC B Y R];        %contemporaneous variables
vXf = [fC fUC fB fY fR];   %forward variables
vXss = repmat(Xss',1,3)'; 
vXss = vXss(:)';        %steady state values for all variables
vVars = reshape([vXl;vX;vXf],size(vXl,1),[]); %all variables (all periods)

%% --------------------------Linearization--------------------------------
% Linearised system: A x(t-1)+B  x(t)+C x(t+1) = 0
A = jacobian(system,vXl);       %symbolic NumVarxNumVar
A = double(subs(A,vVars,vXss)); %double NumVarxNumVar, evaluated at SS
B = jacobian(system,vX); 
B = double(subs(B,vVars,vXss));
C = jacobian(system,vXf); 
C = double(subs(C,vVars,vXss));

%% --------------------------Time Iteration Solver--------------------------------
% Initialize
Metric = 1;
F = zeros(size(C));
F(:,3) = [1/sPar.beta-1 -(1/sPar.beta-1) 1 0 1/sPar.beta];       % initialization

% Run the algorithm to find  y_t = F y_{t-1} + Q u_t
TimeStartLti=tic;
while Metric>Tol
    F = -(B+C*F)\A;
    Metric = max(max(abs([A+B*F+C*F*F])));
end
Q = -inv(B+C*F); 
TimeEndLTI=toc(TimeStartLti);
disp(['Algorithm run time was ',num2str(TimeEndLTI),' seconds']); 

%% --------------------------IRFs--------------------------------
% Some specifications based on what shock we're looking at 
ShockPos = 4; %this refers to the equation number that we're "shocking"
ShockSize = - pShockSize; 

% Generate the IRFs
vu = zeros(NumVar,1); 
vu(ShockPos) = 100*ShockSize; %ShockSize*abs(randn)
mIrf(:,1) = Q*vu;   
IrfHorAx = [1:IrfHor];

for t = 1:IrfHor-1
    mIrf(:,t+1) = F*mIrf(:,t); %iterate forward
end

%% Compute iMPCs
vMPCq = (mIrf(1,:)/100)/abs(ShockSize);
vMPCq_PIH = ones(1,length(vMPCq))*(Rss-1)/Rss; % this is true only for a single, unanticipated transfer
vMPCqAvg = sPar.lambda*vMPCq +(1-sPar.lambda)*vMPCq_PIH;
vMPSq = (mIrf(3,:)/100)/abs(ShockSize);

%% Plotting
%---------------------------------------------------------------------------

fig1=figure;
p1 = plot(0:IrfHor-1,vMPCq(1:IrfHor),sSettings.lines.list{1},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{1});
hold on
p2 = plot(0:IrfHor-1,vMPCqAvg(1:IrfHor),sSettings.lines.list{2},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{2});
p3 = plot(0:IrfHor-1,vMPCq_PIH(1:IrfHor),sSettings.lines.list{3},'linewidth',sSettings.lines.width,'color',sSettings.colors.list{3});
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
print(figName,'-dpdf','-painters')
end

%% Done!
%----------------------------------------------------------------------------
