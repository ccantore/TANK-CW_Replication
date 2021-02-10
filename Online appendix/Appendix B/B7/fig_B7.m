%%=========================================================================
% Compare IRFs based on 
% Follows code by Cristiano Cantore
% Lukas Freund
% Last updated: March 2019
%%=========================================================================
 
%% 0. Housekeeping
%--------------------------------------------------------------------------
clear;
close all;
clc;
TimeStart = tic;


%% 1. User Options
%---------------------------------------------------------------------------
 
% Output options
OptionPrint = 1;        
FigName = 'fig5_phib1_phig0';
TargetPath = './Output/';


% Names of files to be loaded (.mat) whether they're linear or non-linear, and
% how they're called in figures
RESULT_names={'tank_uh_results','tank_uw_results','tank_cw_results'};%,'TANKs_results'}; %%EXACT NAMES OF THE RESULTS FILES TO LOAD
%RESULT_names={'TANK-UH_EH_results','TANK-UW_EH_results','TANK-CW_results'};%,'TANKs_results'}; %%EXACT NAMES OF THE RESULTS FILES TO LOAD

lin_vs_nonlin=[1,1,1]; % = 0 if corresponding model non-linear, 1 otherwise
%Model_names=char('TANK-UH','TANK-UW','TANK-CW'); %NAMES OF THE MODEL VARIANTS TO APPEAR IN THE LEGEND OF THE GRAPHS
Model_names=char('UH','UW','CW'); %NAMES OF THE MODEL VARIANTS TO APPEAR IN THE LEGEND OF THE GRAPHS


% Select names of 1) endogenous vairables of interest for IRFs, 2) names to be shown, and 3) shocks
%VAR_IRFs_nonlin = {'YY','C_C','II','HH','CCC', 'CCW','WW','RKRK','LILI','KIKI','profits','MCMC'};%,'RR','RnRn','PIEPIE','tauC','tauK','tauW','BG','BGC','BGW',}; %% NAMES OF ENDOGENOUS VARIABLES OF INTEREST FOR THE IRFS (NON-LINEAR MODELS) - NEED TO HAVE EXACTLY SAME NAME AS IN THE .MOD FILE
VAR_IRFs_nonlin = {'Y_obs','H_obs','W_obs','C_obs','CSl_obs','CHl_obs','B_obs','BSl_obs','BHl_obs','tax_obs','LS_obs','P_obs'};%,'RR','RnRn','PIEPIE','tauC','tauK','tauW','BG','BGC','BGW',}; %% NAMES OF ENDOGENOUS VARIABLES OF INTEREST FOR THE IRFS (NON-LINEAR MODELS) - NEED TO HAVE EXACTLY SAME NAME AS IN THE .MOD FILE
VAR_IRFs_linear = {'n','n','w','c','csl','chl','b','bsl','bhl','t','ls','d'};   
names = char('Output','Hours worked','Real wage','Consumption','Consumption U/C','Consumption H/W','Bonds','Bonds U/C','Bonds H/W', 'Taxes','Labor share','Profits');
NAME_SHOCKS={'_eps'};
shocks_names=['T'; 'M'; 'F'];


% Display options
IRFPeriods = 15;       
OptionGreycolor = 0;    % if want grey colorscheme instead of standard colors
Rows_figure=4; 
Column_figure=3; 
vLinestyle = {'--',':','-','-'};
FontsizeDefault = 8;
FontsizeAxis = 8;
FontSizeLegend = 6;
Fonttype = 'times';
LinewidthDefault = 1.6;
LinewidthAlt = 1;
ColorZeros = 'k';
StyleZeros = '-';
LinewidthZeros = 0.05;

TitleSize = 14;
LabelSize = 12;
Font = 'times';

if OptionGreycolor == 0
%vColors = {[4,30,150]/255,[152,58,68]/255,[30,144,250]/255,[0,0,0]};
vColors = {[255 127 0]/255,[128,128,128]/255,[0,0,90]/255,[0,0,0]};
%{,,,};
%{,,,[114,47,55]/255};
else
% vColors = repmat(linspace(0.2,0.6,4).',1,4);
% vColors = mat2cell(vColors,ones(1,size(vColors,1)),4);
vColors = {[0.2,0.2,0.2],[0.46,0.46,0.46],[0.6,0.6,0.6],[0.8,0.8,0.8]};
end

%% 2. Recover data
%---------------------------------------------------------------------------
Num_models=length(RESULT_names); %%NUMBER OF MODELS TO COMPARE
NUM_SHOCKS=length(NAME_SHOCKS);  %%NUMBER OF SHOCKS TO COMPARE
NUM_VAR=length(VAR_IRFs_nonlin);%%NUMBER OF VARIABLES TO COMPARE

irfs_matrix=zeros(20,NUM_VAR,NUM_SHOCKS,Num_models);
for mm=1:Num_models
%load Model 
eval(['load ' RESULT_names{mm} ';']);
if lin_vs_nonlin(mm)~=0
    VAR_IRFs=VAR_IRFs_linear;
else
    VAR_IRFs=VAR_IRFs_nonlin;
end
for xx=1:NUM_SHOCKS
for jj=1:NUM_VAR
%Rename the IRFs for each variable of interest 
genrate_irf_names=[VAR_IRFs{jj},NAME_SHOCKS{xx},'=','oo_.irfs.',VAR_IRFs{jj},NAME_SHOCKS{xx},';'];
evalin('base', genrate_irf_names);
%generate_irf_matrix=['irf_',num2str(mm),NAME_SHOCKS{xx},'(jj,:)=',VAR_IRFs{jj},NAME_SHOCKS{xx}];
%evalin('base', generate_irf_matrix)
irfs_matrix(:,jj,xx,mm)=eval([VAR_IRFs{jj},NAME_SHOCKS{xx}]);
end
end

end

%% 3. Plot
%---------------------------------------------------------------------------
for xx=1:NUM_SHOCKS

%Options for the plot
h=figure('Position', [600, 0, 1000, 900]);
axes ('position', [0, 0, 1, 1]);

%Loop over the number of endogenous variables to plot
F1=figure(xx);
set(F1, 'numbertitle','off');
set(F1, 'name', ['Impulse response functions to',NAME_SHOCKS{xx}]);
for jj = 1:length(VAR_IRFs)
for mm=1:Num_models
subplot(Rows_figure,Column_figure,jj), plot(irfs_matrix(1:IRFPeriods,jj,xx,mm),vLinestyle{mm},'Color',vColors{mm},'LineWidth',LinewidthDefault); 
hold on;
 set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',Fonttype);
    xlim([1 IRFPeriods])
    set(gca,'XTick',0:5:IRFPeriods); %'TickLabelInterpreter','LaTex')
plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',LinewidthZeros);

% if jj==1
% hL=legend(Model_names);
% set(hL,'interpreter','latex','fontname','times','Location','best','FontSize',FontSizeLegend)
% %ylabel('% dev from SS','Fontsize',FontsizeAxis);
% end

% Can manipulate the following to make exceptions to axis titles
%if names(jj,:)=='Profits           '
%           ylabel('absolute dev from SS');
%  else
%ylabel('% dev from SS','Fontsize',FontsizeAxis);
%  ylabel('absolute dev from SS','Fontsize',LabelSize);
%   end
%grid on
title(names(jj,:),'FontSize',FontsizeDefault,'fontname',Fonttype,'FontWeight','normal');

if jj > Rows_figure*Column_figure-Column_figure
xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',Fonttype)
end


axis tight         
 %set(gca, 'FontName', Font)
    end
end


subplot(Rows_figure,Column_figure,1)
hL=legend(Model_names);
set(hL,'fontname','times','Location','northeast','FontSize',FontSizeLegend)
%newPosition = [0.3765    0.9542    0.2811    0.0373];
%newUnits = 'normalized';
%set(hL,'Position', newPosition,'Units', newUnits,'Orientation','horizontal');





%% Print (if enabled)
%----------------------------------------------------------------------------

if size(VAR_IRFs_nonlin,2)==2
xSize = 17.5; 
%ySize = 5;
ySize = 10;
xCut = 1.5;
yCut = 0;
elseif size(VAR_IRFs_nonlin,2)==4
xSize = 17.5; 
ySize = 10;
%ySize = 9; % when fitting 8 figures
xCut = 2.4;
yCut = 0.1;
elseif size(VAR_IRFs_nonlin,2)==6 || size(VAR_IRFs_nonlin,2)==5
xSize = 17.5; 
ySize = 12.5; 
xCut = 2.4;
yCut = 0.8;
elseif size(VAR_IRFs_nonlin,2)==9
xSize = 17.5; 
ySize = 12.5; 
xCut = 2.4;
yCut = 0.8;
elseif size(VAR_IRFs_nonlin,2)==12
% xSize = 17.5; 
% ySize = 11.5; 
% xCut = 2.4;
% yCut = 0;
xSize = 17.5; 
ySize = 16.6667; %12.5; 
xCut = 2.4;
yCut = 0.8;
elseif size(VAR_IRFs_nonlin,2)==16
xSize = 17.5; 
ySize = 10; 
xCut = 2.4;
yCut = 0;
elseif size(VAR_IRFs_nonlin,2)==18
xSize = 17.5; 
ySize = 12; 
xCut = 2.4;
yCut = 0;
end

 set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-xCut ySize-yCut],'PaperPositionMode','auto')

if OptionPrint == 1
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% set(0,'DefaultFigureColor','remove')
% export_fig(strcat(TargetPath,FigName),'-pdf','-transparent')

 % FigNamepdf =horzcat(horzcat(TargetPath,FigName,shocks_names(xx)),'.pdf');
 FigNamepdf =horzcat(horzcat(TargetPath,FigName),'.pdf');
  print(FigNamepdf,'-dpdf','-painters')
 
 %print(hfig,-'dpdf','-painters',FigNamepdf)
end
end

%% Done!
%----------------------------------------------------------------------------
TimeEnd = toc(TimeStart);
disp(['Total run time was ',num2str(TimeEnd),' seconds']);