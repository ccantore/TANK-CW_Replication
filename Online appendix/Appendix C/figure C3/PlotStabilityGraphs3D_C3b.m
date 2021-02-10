%%=========================================================================
% This code creates stability maps based on the Dynare toolbox, i.e.,
% regions of saddle path stability, indeterminacy and instability.
% Runs on Dynare 4.4.3 and higher
% Last updated: November 2019
%%=========================================================================
 
% Attempt to have 3-D plots

%% Information
%--------------------------------------------------------------------------
% This approach uses the following output from Dynare's built-in resol function:
%   info(1) = 0     =>    No error.
%   info(1) = 3     =>    Blanchard & Kahn conditions are not satisfied: no stable equilibrium.
%   info(1) = 4     =>    Blanchard & Kahn conditions are not satisfied: indeterminacy.
%   info(1) = 1     =>    The model doesn't determine the current variables uniquely.

%% Housekeeping
%--------------------------------------------------------------------------
clear;
close all;
clc;
TimeStart = tic;

%% User Choices
%--------------------------------------------------------------------------

% Select printing options
OptionPrint = 1;        
FigName = 'Fig_C3b';
TargetPath = '.\Output\';   

% Choose model (name of .mod file)
ModelName = 'tank_cw';

% Set parameter space to be evaluated
Parameter1 = 'phi'; 
Parameter1String = '$\varphi$';
%Parameter1String = horzcat('\',Parameter1); % assumes Parameter1 is written consistent w/ latex notation, else choose manually
Parameter1Min = 0.01;
Parameter1Max = 20;
Parameter1Steps = 15;

Parameter2 = 'lambda';
Parameter2String = '$\lambda$';

Parameter2Min = 0.01;
Parameter2Max = 0.99;
Parameter2Steps = 15;

%Parameter3 = 'psiH';
%Parameter3String = horzcat('\psi^W'); 
%Parameter3Min = 0.01;
%Parameter3Max = 2;
%Parameter3Steps = 15;
Parameter3 = 'phi_pi';
Parameter3String = horzcat('\phi^{\pi}'); 
Parameter3Min = 0.01;
Parameter3Max = 2;
Parameter3Steps = 15;
% Parameter3 = 's_prices_duration';
% Parameter3String = 'Calvo duration'; 
% Parameter3Min = 0.01;
% Parameter3Max = 8;
% Parameter3Steps = 15;
%Parameter3 = 'sigma_c';
%Parameter3Min = 0.01;
%Parameter3Max = 2;
%Parameter3Steps = 15;

% Axes labels


%% Run Dynare
%--------------------------------------------------------------------------
%dynare TANKs_linear noclearall 
Model=['dynare ' ModelName ' noclearall'];
eval(Model)

%% Compute Stability Regions
%--------------------------------------------------------------------------
% Create parameter vectors
vParameter1 = linspace(Parameter1Min,Parameter1Max,Parameter1Steps);
vParameter2 = linspace(Parameter2Min,Parameter2Max,Parameter2Steps);
vParameter3 = linspace(Parameter3Min,Parameter3Max,Parameter3Steps);

[aParameter1,aParameter2,aParameter3] = meshgrid(vParameter1,vParameter2,vParameter3); % matrix version
test= meshgrid(vParameter1,vParameter2,vParameter3);
% Initialize
Iter = 0;
options_.qz_criterium = 1+1e-6;
aStability = NaN(size(aParameter1));

% Compute stability regions
for iP1 = 1:length(vParameter1)
    for iP2 = 1:length(vParameter2)
        for iP3 = 1:length(vParameter3)
       Iter = Iter+1;
       set_param_value(Parameter1,aParameter1(iP1,iP2,iP3)); 
       set_param_value(Parameter2,aParameter2(iP1,iP2,iP3)); 
       set_param_value(Parameter3,aParameter3(iP1,iP2,iP3)); 
       [dr,info] = resol(0,M_,options_,oo_); % compute perturbation based decision rules 
       aStability(iP1,iP2,iP3) = info(1);        % store stability info
        end
    end
end

%% Plot
%--------------------------------------------------------------------------
%% Design defaults 
OptionGreycolor = 0;    % if want grey colorscheme instead of standard colors
vLinestyle = {'-','-.','--',':'};
FontsizeDefault = 10;
FontsizeAxis = 10;
FontSizeLegend = 8;
FontsizeAxisticks = 8;
Fonttype = 'times';
LinewidthDefault = 1.6;
LinewidthAlt = 1;
ColorZeros = 'k';
StyleZeros = '-';
if OptionGreycolor == 0
vColors = {[0,0,90]/255,[255 127 0]/255,[128,128,128]/255,[114,47,55]/255};
%  vColors = {[4,30,150]/255,[1 0.5 0],[152,58,68]/255,[30,144,250]/255};
elseif OptionGreycolor == 1
vColors = {[0.2,0.2,0.2],[0.46,0.46,0.46],[0.6,0.6,0.6],[0.7 0.7 0.7]};
end


%% NEW PLOT: 3D
%   info(1) = 0     =>    No error.
%   info(1) = 3     =>    Blanchard & Kahn conditions are not satisfied: no stable equilibrium.
%   info(1) = 4     =>    Blanchard & Kahn conditions are not satisfied: indeterminacy.

aDetplot = zeros(size(aStability));
aDetplot(aStability==0)=1; % cases when there's no error


markersize = 30;


Fig1 = figure(1);
scatter3(aParameter1(:),aParameter2(:),aParameter3(:),markersize,aDetplot(:),'filled');
% draw the scatter plot
ax = gca; % 'MarkerEdgeColor','k',
%ax.ZDir = 'reverse'; % CAREFUL, NEED TO CHECK THIS!
view(-31,14)
xlabel(horzcat('$\varphi$'),'fontsize',FontsizeAxis,'interpreter','latex'); 
%ylabel(horzcat('$',Parameter2String,'$'),'fontsize',FontsizeAxis,'interpreter','latex');   
%ylabel(horzcat('$',Parameter2String,'$'),'fontsize',FontsizeAxis,'interpreter','latex');   
ylabel(horzcat('$\lambda$'),'fontsize',FontsizeAxis,'interpreter','latex'); 
%zlabel(horzcat('$',Parameter3String,'$'),'fontsize',FontsizeAxis,'interpreter','latex');  
zlabel(horzcat('$\phi^{\pi}$'),'fontsize',FontsizeAxis,'interpreter','latex'); 

box on
set(gca,'xticklabel',get(gca,'xticklabel'),'FontSize',FontsizeAxis,'fontname',Fonttype); 
set(gca,'yticklabel',get(gca,'yticklabel'),'FontSize',FontsizeAxis,'fontname',Fonttype); 
set(gca,'zticklabel',get(gca,'zticklabel'),'FontSize',FontsizeAxis,'fontname',Fonttype); 

% Change labels manually for now
xlabel(horzcat('Inverse Frisch elasticity ','($\varphi$)'),'fontsize',FontsizeAxis,'interpreter','latex'); 
ylabel(horzcat('Worker share ','($\lambda$)'),'fontsize',FontsizeAxis,'interpreter','latex'); 
zlabel(horzcat('Taylor rule coefficient on inflation ','($\phi^{\pi}$)'),'fontsize',FontsizeAxis,'interpreter','latex'); 



 % Define rgb colors manually: 
%colors = reshape(cell2mat(vColors),3,4); colors=colors(:,1:3)';    
%colors = reshape(cell2mat(vColors),3,4); colors=colors(:,1:2)';    
colors = reshape(cell2mat(vColors),3,4); colors=colors(:,1:2)';  colors=flip(colors); % FOR 1/0 setting

colormap(colors);       
cb = colorbar; 
caxis([-0.5 1.5])
set(cb,'ytick',0:1) % careful, order of legend here is different b/c ordered 
%set(cb,'yticklabel',{'Determinacy','Instability','Indeterminacy'},'fontname','times')
%set(cb,'yticklabel',{'Determinacy','Indeterminacy'},'fontname','times')
set(cb,'yticklabel',{'Indeterminacy','Determinacy'},'fontname','times'); % THIS IS FOR PLOTTING ONLY 0 (INDET) / 1 (DET)
%newPosition = [0.2316    0.9474    0.5518    0.0417];
%newUnits = 'normalized';
%set(cb,'Position', newPosition,'Units', newUnits,'Orientation','horizontal');


% Legend
% legend1 = legend('Determinacy','Indeterminacy','Instability');
% set(legend1,'fontname','times','Location','best','FontSize',FontSizeLegend,'Orientation','horizontal');
% newPosition = [0.2316    0.9474    0.5518    0.0417];
% newUnits = 'normalized';
% set(legend1,'Position', newPosition,'Units', newUnits,'Orientation','horizontal');
% %{
%% FIGURES BELOW ARE for 2D!
%{
%% Figure 1: Simple contour plot focusing just on stability vs. not (not printed, just for illustration)
Fig1 = figure(1);
mDetplot = zeros(size(aStability));
mDetplot(aStability==0)=1; % cases when there's no error
figure(1)
contour(aParameter1,aParameter2,mDetplot,1,'k','Linewidth',LinewidthDefault)
xlabel(horzcat('$',Parameter1String,'$'),'fontsize',FontsizeAxis,'interpreter','latex'); 
ylabel(horzcat('$',Parameter2String,'$'),'fontsize',FontsizeAxis,'interpreter','latex');    
title('Determinacy Region','fontname',Fonttype,'Fontsize',FontsizeDefault);

%% Figure 2: Mesh plot (useful esp. if have all three cases)
TickScaleFactor = 10;       % factor reducing frequency of x-ticks relative to # steps 
Parameter1Stepsize = vParameter1(2)-vParameter1(1);
Parameter2Stepsize = vParameter2(2)-vParameter2(1);

Fig2 =figure(2);
markersize=1;
spy(aStability(:,:)==0,'r.');
set(get(gca,'children'),'color',vColors{2})
hold on 
spy(aStability(:,:)==4,'k.');
hold on 
spy(aStability(:,:)==3,'y.');
set(get(gca,'children'),'markersize',10)
axis xy;

% But need to scale axes labels to reflect parameter values rather than vec length
temp = {Parameter2Min:TickScaleFactor*Parameter2Stepsize:Parameter2Max};
% The following lines are just to make the graphs prettier, may wish to adjust
% depending on preferences
if Parameter2Max>10
N = 0;
else
N = 1;
end
temp = cellfun(@(x)round(x,N),temp,'UniformOutput',false);  % round
set(gca,'YTick',1:TickScaleFactor:length(vParameter2),'fontsize',FontsizeAxis); % this is important to show the right para values
set(gca,'YTicklabel',temp);

temp = {Parameter1Min:TickScaleFactor*Parameter1Stepsize:Parameter1Max};
if Parameter1Max>10
N = 0;
elseif Parameter1Max
N = 1;
end
temp = cellfun(@(x)round(x,N),temp,'UniformOutput',false);
set(gca,'XTick',1:TickScaleFactor:length(vParameter1),'fontsize',FontsizeAxis);
set(gca,'XTicklabel',temp);
ylabel(horzcat('$',Parameter2String,'$'),'fontsize',FontsizeAxis,'interpreter','latex');    
xlabel(horzcat('$',Parameter1String,'$'),'fontsize',FontsizeAxis,'interpreter','latex'); 

% Legend
legend1 = legend('Determinacy','Indeterminacy','Instability');
set(legend1,'fontname','times','Location','best','FontSize',FontSizeLegend,'Orientation','horizontal');
newPosition = [0.2316    0.9474    0.5518    0.0417];
newUnits = 'normalized';
set(legend1,'Position', newPosition,'Units', newUnits,'Orientation','horizontal');
%}
%}

%% Print
%--------------------------------------------------------------------------
xSize = 17.5; 
ySize = 10; 
xCut = 0;
yCut = -0.5;

 set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-xCut ySize-yCut],'PaperPositionMode','auto')

if OptionPrint == 1

  FigNamepdf =horzcat(horzcat(TargetPath,FigName),'.pdf');
print(FigNamepdf,'-dpdf','-painters')
end

%% Done!
%----------------------------------------------------------------------------
TimeEnd = toc(TimeStart);
disp(['Total run time was ',num2str(TimeEnd),' seconds']);