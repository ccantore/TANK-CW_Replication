%%=========================================================================
% Replication code for "Workers, Capitalists, and the Government: Fiscal Policy and Income (Re)Distribution"
% by C. Cantore and L. B. Freund
% Journal of Monetary Economics
% This file: plot VAR-based results (main text & appendix); the 
% relevant input files are already in the 'Data' subfolder
%%=========================================================================

%% Housekeeping
%--------------------------------------------------------------------------
clear;
close all;
clc;
TimeStart = tic;    
addpath('functions')
 
%% Settings
%--------------------------------------------------------------------------
% Output options
OptionPrint = 0;        
FigName = 'fig_Name';
TargetPath = 'Output\';   

% Select which figure to create
FigureType = 1;     % 1: baseline figure in main text, 2: full set of variable (appendix), 3: other countries (appendix)

% Design
IRFPeriods = 15;                        
OptionGreycolor = 0;    
vLinestyle = {'-','--',':','-.'};
FontsizeDefault = 6;
FontsizeAxis = 6;
FontSizeLegend = 6;
FontsizeAxisticks = 6;
Fonttype = 'Times';
LinewidthDefault = 1.6;
LinewidthAlt = 1;
ColorZeros = 'k';
StyleZeros = '-';
if OptionGreycolor == 0
vColors = {[0,42,91]/255,[255 127 0]/255,[114,47,55]/255,[128,128,128]/255};
elseif OptionGreycolor == 1
vColors = {[0.2,0.2,0.2],[0.46,0.46,0.46],[0.6,0.6,0.6],[0.7 0.7 0.7]};
end

%% Load IRF files 
%--------------------------------------------------------------------------

if FigureType == 1 || FigureType == 2 % US baseline VAR 
load('Data/VAR_IRFs_F14L2C3S6LS7_Surprise_Large_10Variables.mat') % Lag: 2, quadratic, S: sample 6, LS7: baseline
NumModels=1;
names{1}='Government spending' ; 
names{3}='Taxes';
names{4}='GDP';
names{5}='Consumption';
names{6}='Investment';
names{7}='Labor share';
names{8}='Corporate profits';
names{9}='GDP deflator';
names{10}='10y real yield';

elseif FigureType == 2 % appendix figure for other countries
load('Data/VarIrf_AusCanUK.mat')             % collected
mIrf=mIrf(1:15,:,:);

% Get baseline US numbers
load('Data/VarIrf_USComparison.mat');  % based on BP, same sample 
gnorm=max(squeeze(prctile(irf(1,1,:,:),[50],4))); 
for i = 1:numel(names)
imp=[squeeze(squeeze(prctile(irf(i,1,:,:),[50],4))) squeeze(prctile(irf(i,1,:,:),[16 84],4))]/gnorm;
mIrfUSMedian(:,i) = imp(:,1);
end
clear names
names{1}='Government spending' ;
names{2}='Taxes';
names{3}='GDP';
names{4}='Labor share';
names{5}='10y real yield';
NumModels = 4;
end

%% Plot
%--------------------------------------------------------------------------

if FigureType == 1
figure;
Selection = [4,5,6,7];              % only show select variables
mIRF=mIRF(:,:,Selection)*(1/0.196); % scale such that increase in government spending is equal to one percent of GDP
names = names([Selection]);

for i=1:size(mIRF,3)
    subplot(2,2,i)
  
    mIrfMedian = mIRF(:,2,i);
    mIrfBands = [mIRF(:,1,i) mIRF(:,3,i)];
    PlotShaded(mIrfBands(1:IRFPeriods,:),1,15);
    hold
    plot(mIrfMedian(1:IRFPeriods),'Color',vColors{1},'linestyle','-','Linewidth',LinewidthDefault);
   
    plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',0.05);
    xlim([0 IRFPeriods]);
    set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',Fonttype);   
    xlim([1 IRFPeriods])
    axis tight  
    title(names{i},'FontSize',FontsizeDefault,'fontname',Fonttype,'FontWeight','normal');
    if i >= numel(names)-1
        xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',Fonttype);
    end
end

elseif FigureType == 2
figure;
Selection = [1,3:10];
mIRF=mIRF(:,:,Selection);
names = names([Selection]);

for i=1:size(mIRF,3)
    subplot(3,3,i)
  
    mIrfMedian = mIRF(:,2,i);
    mIrfBands = [mIRF(:,1,i) mIRF(:,3,i)];
    PlotShaded(mIrfBands(1:IRFPeriods,:),1,15);
    hold
    plot(mIrfMedian(1:IRFPeriods),'Color',vColors{1},'linestyle','-','Linewidth',LinewidthDefault);
   
    plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',0.05);
    xlim([0 IRFPeriods]);
    set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',Fonttype);   
    xlim([1 IRFPeriods])
    axis tight  
    title(names{i},'FontSize',FontsizeDefault,'fontname',Fonttype,'FontWeight','normal');
    if i >= numel(names)-2
        xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',Fonttype);
    end
end


elseif FigureType == 3    
  
for i=1:5
    subplot(3,2,i)
    p1 = plot(mIrf(1:IRFPeriods,4,i),vLinestyle{1},'Color',vColors{1},'Linewidth',LinewidthDefault);
    hold on
    p2 = plot(mIrf(1:IRFPeriods,1,i),vLinestyle{2},'Color',vColors{2},'Linewidth',LinewidthDefault);
    p3 = plot(mIrf(1:IRFPeriods,2,i),vLinestyle{3},'Color',vColors{3},'Linewidth',LinewidthDefault);
    p4 = plot(mIrf(1:IRFPeriods,3,i),vLinestyle{4},'Color',vColors{4},'Linewidth',LinewidthDefault);
    plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',0.05);
    xlim([0 IRFPeriods]);
    set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',Fonttype);   
    xlim([1 IRFPeriods])
    axis tight
    title(names{i},'FontSize',FontsizeDefault,'fontname',Fonttype,'FontWeight','normal');
    if i >= 4
        xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',Fonttype);
    end
    axis tight
   if i==1
        legend1=legend('US','Australia','Canada','UK');
        subplot(3,2,1)
        ylim([0 1])
   end
end
    % Let's move the legend outside, manual positioning to avoid cutoff
    set(legend1,'fontname','times','Location','Southeast','FontSize',FontSizeLegend)
    newPosition = [0.2901    0.9610    0.4418    0.0384];
    newUnits = 'normalized';
    set(legend1,'Position', newPosition,'Units', newUnits,'Orientation','horizontal','interpreter','none');

end

%% Print (if enabled)
%----------------------------------------------------------------------------

if FigureType == 1 || FigureType == 2
xSize = 17.5; 
ySize = 12.5;
xCut = 1;
yCut = 1; 

elseif FigureType == 3
xSize = 17.5;
ySize = 12.5; 
xCut = 1;
yCut = 0; 
end

 set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-xCut ySize-yCut],'PaperPositionMode','auto')
  
if OptionPrint == 1
  FigNamepdf =horzcat(horzcat(TargetPath,FigName),'.pdf');
  print(FigNamepdf,'-dpdf','-painters')
 end

