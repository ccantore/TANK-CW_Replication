%% Housekeeping
%--------------------------------------------------------------------------
clear;
close all;
clc;
TimeStart = tic;


%% Run .mod files
%  dynare rank;
%  dynare tank_uh;
%  dynare tank_uw;
%  dynare tank_cw;


%% User choices
%--------------------------------------------------------------------------
OptionPrint = 1;        
FigName = 'fig6a';
TargetPath = './Output/';
positive_g_ss=0; %0 if G/Y=0 otherwise G/Y>0 in ss

% Display options
IRFPeriods = 15;       
OptionGreycolor = 0;    % if want grey colorscheme instead of standard colors
vLinestyle = {'--',':','-','-.'};
FontsizeDefault = 6;
FontsizeAxis = 6;
FontSizeLegend = 6;
FontDefault = 'times';
LinewidthDefault = 1.6;
LinewidthAlt = 1;
ColorZeros = 'k';
StyleZeros = '-';
LinewidthZeros = 0.05;

vColors = {[0,0,90]/255,[255 127 0]/255,[114,47,55]/255,[128,128,128]/255};
vColors = {[255 127 0]/255,[128,128,128]/255,[0,0,90]/255,[114,47,55]/255};

vColorsGrey = {[0.2,0.2,0.2],[0.6,0.6,0.6],[0.9,0.9,0.9]};

%% Load and transform inputs
%---------------------------------------------------------------------------
sData1=load(fullfile('.','resultsFiscalUHBaseline.mat'));
sData2=load(fullfile('.','resultsFiscalUWBaseline.mat'));
sData3=load(fullfile('.','resultsFiscalCWBaseline.mat'));
sData4=load(fullfile('.','resultsFiscalRANKBaseline.mat'));
% sData1=load(fullfile('.','resultsFiscalUHDeficit.mat'));
% sData2=load(fullfile('.','resultsFiscalUWDeficit.mat'));
% sData3=load(fullfile('.','resultsFiscalCWDeficit.mat'));
% sData4=load(fullfile('.','resultsFiscalRANKDeficit.mat'));

 sDataC = [sData1.c sData2.c sData3.c sData4.c];
 sDataB = [sData1.b sData2.b sData3.b sData4.b];
 sDataG = [sData1.g sData2.g sData3.g sData4.g];
 sDataT = [sData1.t sData2.t sData3.t sData4.t];
 sDataN = [sData1.n sData2.n sData3.n sData4.n];

%% Multipliers

if positive_g_ss==0
    gy=1;
else
    gy = 0.2;

end

%remove 1ss observation
mY=sDataN(2:end,:);
mG=sDataG(2:end,:);

%Discounting
pDiscount = 0.99;
 for iT = 1:IRFPeriods
    vDiscount(iT) = pDiscount.^(iT-1);
    mGAdj(iT,:) = vDiscount(iT).*mG(iT,:);
    mYAdj(iT,:) = vDiscount(iT).*mY(iT,:);
 end
 
mMultiplierCumulativeUnweighted =(1/gy)*(cumsum(mY(1:IRFPeriods,:),1)./cumsum(mG(1:IRFPeriods,:),1));
mMultiplierCumulativeWeighted =(1/gy)*(cumsum(mYAdj(1:IRFPeriods,:),1)./cumsum(mGAdj(1:IRFPeriods,:),1));
    
    


 figure;
for iM = 1:4
subplot(1,3,1)
%plot(1:IRFPeriods,100*sData(iM).Y(2:IRFPeriods+1), 'Color',vColors{iM},'Linestyle',vLinestyle{iM},'LineWidth',LinewidthDefault); hold on
%title('Output','FontSize',FontsizeDefault,'fontname',FontDefault,'FontWeight','normal');
    if positive_g_ss==0
    plot(1:IRFPeriods,100*sDataN(2:IRFPeriods+1,iM), 'Color',vColors{iM},'Linestyle',vLinestyle{iM},'LineWidth',LinewidthDefault); hold on
    else
    plot(1:IRFPeriods,1/gy*100*sDataN(2:IRFPeriods+1,iM), 'Color',vColors{iM},'Linestyle',vLinestyle{iM},'LineWidth',LinewidthDefault); hold on
    end
    title('Output','FontSize',FontsizeDefault,'fontname',FontDefault,'FontWeight','normal');
set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',FontDefault); axis tight
plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',LinewidthZeros);
xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',FontDefault); axis tight
%ylim([-1 2])
% 
subplot(1,3,2)
    if positive_g_ss==0
    plot(1:IRFPeriods, 100*sDataC(2:IRFPeriods+1,iM), 'Color',vColors{iM},'Linestyle',vLinestyle{iM},'LineWidth',LinewidthDefault); hold on
    else
    plot(1:IRFPeriods,100*sDataC(2:IRFPeriods+1,iM), 'Color',vColors{iM},'Linestyle',vLinestyle{iM},'LineWidth',LinewidthDefault); hold on
    end
    title('Consumption','FontSize',FontsizeDefault,'fontname',FontDefault,'FontWeight','normal');
set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',FontDefault);
plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',LinewidthZeros);
plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',LinewidthZeros); axis tight
xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',FontDefault); axis tight
hold on


end
subplot(1,3,3)
%p1=plot(1:IRFPeriods,100* sDataG(2:IRFPeriods+1,1), 'Color',vColorsGrey{1},'Linestyle',vLinestyle{1},'LineWidth',LinewidthDefault); hold on
p1=plot(1:IRFPeriods,100* sDataG(2:IRFPeriods+1,1), 'Color',vColorsGrey{1},'Linestyle','-','LineWidth',LinewidthDefault); hold on
p2=plot(1:IRFPeriods,100* sDataT(2:IRFPeriods+1,1), 'Color',vColorsGrey{2},'Linestyle','-','LineWidth',LinewidthDefault); 
p3=plot(1:IRFPeriods,100* (sDataB(2:IRFPeriods+1,1)), 'Color',vColorsGrey{3},'Linestyle','-','LineWidth',LinewidthDefault); 
title('Fiscal variables','FontSize',FontsizeDefault,'fontname',FontDefault,'FontWeight','normal');
hL=legend('Gov. spending','Net taxes','Debt');
set(hL,'fontname','times','Location','best','FontSize',FontSizeLegend)
set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAxis,'fontname',FontDefault); axis tight
plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',LinewidthZeros);
xlabel('Time (quarters)','FontSize',FontsizeAxis,'fontname',FontDefault); axis tight
%ylim([-0.25 1.5])

subplot(1,3,1)
hL=legend('UH','UW','CW','RA');
set(hL,'fontname','times','Location','northeast','FontSize',FontSizeLegend)


%% Print
%----------------------------------------------------------------------------
xSize = 17.5; 
ySize = 12.5/3; 
xCut = 2.4;
yCut = 0;
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