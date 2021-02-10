%plots models vs VAR impulse responses for model-specific estimated
%parameters
clear;
close all;
clc;
TimeStart = tic;
addpath('functions_aux/export_fig')

% Adjust some style options
%set(groot, 'DefaultTextInterpreter', 'LaTex'); set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
set(0, 'DefaultAxesFontSize',14);
set(0, 'DefaultTextFontSize', 14);
set(0, 'DefaultUicontrolFontSize',14);

%% 1. User Options
%---------------------------------------------------------------------------
 
% Output options
OptionPrint = 1;        
FigName = 'figBIRF';
TargetPath = './Output/';
mkdir(TargetPath);

data_varnames={'Government spending', 'GDP', 'Consumption', 'Investment',  'Labor share', 'GDP deflator', 'Corporate profits'};


% Display options
IRFPeriods = 15;       
OptionGreycolor = 0;    % if want grey colorscheme instead of standard colors


vLinestyle = {'-o','--','-',':'};
FontsizeDefault = 8;
FontsizeAcalvos = 8;
FontSizeLegend = 6;
Fonttype = 'times';
LinewidthDefault = 1.6;
LinewidthAlt = 0.001;
ColorZeros = 'k';
StyleZeros = '-';
irf_horizon=15;


if OptionGreycolor == 0
vColors = {[0.2,0.2,0.2],[1 0.5 0],[0,0,90]/255,[30,144,250]/255};
 %{,[255 127 0]/255,[114,47,55]/255,[128,128,128]/255};
else
vColors = {[0.2,0.2,0.2],[0.46,0.46,0.46],[0.6,0.6,0.6]};
end



cd('UH')
%cd('sim')


%load tanks_lin_results
load tank_uh_results

model_resp_TANK=[oo_.irfs.G_epsG(1:irf_horizon); oo_.irfs.Y_epsG(1:irf_horizon);  oo_.irfs.C_epsG(1:irf_horizon); oo_.irfs.I_epsG(1:irf_horizon); oo_.irfs.LS_epsG(1:irf_horizon); oo_.irfs.PIE_epsG(1:irf_horizon)]';
%model_resp_TANK=[oo_.irfs.G_obs_epsG(1:irf_horizon); oo_.irfs.Y_obs_epsG(1:irf_horizon);  oo_.irfs.C_obs_epsG(1:irf_horizon); oo_.irfs.I_obs_epsG(1:irf_horizon); oo_.irfs.LS_obs_epsG(1:irf_horizon); oo_.irfs.PIE_obs_epsG(1:irf_horizon)]';
cd ..
%cd ..

cd('CW')
%cd('MH mode')
%cd('sim')

%load tanks_lin_results
load tank_cw_results

model_resp_TANK2=[oo_.irfs.G_epsG(1:irf_horizon); oo_.irfs.Y_epsG(1:irf_horizon); oo_.irfs.C_epsG(1:irf_horizon); oo_.irfs.I_epsG(1:irf_horizon);  oo_.irfs.LS_epsG(1:irf_horizon); oo_.irfs.PIE_epsG(1:irf_horizon)]';
%model_resp_TANK2=[oo_.irfs.G_obs_epsG(1:irf_horizon); oo_.irfs.Y_obs_epsG(1:irf_horizon);  oo_.irfs.C_obs_epsG(1:irf_horizon); oo_.irfs.I_obs_epsG(1:irf_horizon); oo_.irfs.LS_obs_epsG(1:irf_horizon); oo_.irfs.PIE_obs_epsG(1:irf_horizon)]';

cd ..

cd('UW')
%cd('MH mode')
%cd('sim')

%load tanks_lin_results
load tank_Uw_results

model_resp_TANK3=[oo_.irfs.G_epsG(1:irf_horizon); oo_.irfs.Y_epsG(1:irf_horizon); oo_.irfs.C_epsG(1:irf_horizon); oo_.irfs.I_epsG(1:irf_horizon);  oo_.irfs.LS_epsG(1:irf_horizon); oo_.irfs.PIE_epsG(1:irf_horizon)]';
%model_resp_TANK3=[oo_.irfs.G_obs_epsG(1:irf_horizon); oo_.irfs.Y_obs_epsG(1:irf_horizon);  oo_.irfs.C_obs_epsG(1:irf_horizon); oo_.irfs.I_obs_epsG(1:irf_horizon); oo_.irfs.LS_obs_epsG(1:irf_horizon); oo_.irfs.PIE_obs_epsG(1:irf_horizon)]';


pnstep=irf_horizon;
conflevel=0.68;
factor=-norminv((1-conflevel)/2);
time=[0:1:pnstep-1];

% Display options
FontDefault = 'Times';
Rows_figure=3; 
Column_figure=2; 
% 
% % TEMP

 load IRFG;
 policyresponse = Y([1:2,4:5,3,6],:)';
 load IRFGSE;
 policyresponseLOW = policyresponse-s_Y([1:2,4:5,3,6],:)';
 policyresponseHIGH = policyresponse+s_Y([1:2,4:5,3,6],:)';

 cd ..

 
figure('Name','Government Spending Surprise Shock: VAR vs. Model');
legend_string={}; %empty cell for legend
for plotindx=1:1:size(policyresponse,2);
    subplot(3,2,plotindx)
   % grpyat = [ [(0:pnstep-1)'  policyresponseLOW(:,reorderidx(plotindx))] ; [(pnstep-1:-1:0)'  policyresponseHIGH(pnstep:-1:1,reorderidx(plotindx))]];
  %  patch(grpyat(:,1),grpyat(:,2),[0.7 0.7 0.7],'edgecolor',[0.65 0.65 0.65]); hold on
   %patch(grpyat(:,1),grpyat(:,2),[0.9 0.9 .9],'edgecolor',[0.9 0.9 0.9]); hold on
    PlotShaded([policyresponseLOW(1:pnstep,plotindx),policyresponseHIGH(1:pnstep,plotindx)],1,15); hold
    plot(1:IRFPeriods, policyresponse(1:pnstep,plotindx),vLinestyle{1},'Color',vColors{1},'LineWidth',LinewidthAlt); 
%      plot(zeros(1,IRFPeriods),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',0.5); xlim([0 IRFPeriods]);
    set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAcalvos);   
    xlim([1 IRFPeriods])
    plot(1:IRFPeriods,model_resp_TANK2(1:pnstep,plotindx),vLinestyle{3},'Color',vColors{3},'LineWidth',LinewidthDefault); hold on
    plot(1:IRFPeriods,model_resp_TANK(1:pnstep,plotindx),vLinestyle{2},'Color',vColors{2},'LineWidth',LinewidthDefault); hold on
    plot(1:IRFPeriods,model_resp_TANK3(1:pnstep,plotindx),vLinestyle{4},'Color',vColors{1},'LineWidth',LinewidthDefault); hold on

    %plot(time,model_resp_TANK3(1:pnstep,plotindx),'g--','LineWidth',linewidth,'MarkerSize',4); hold on
    %plot(time,model_resp_TANK4(1:pnstep,plotindx),'r--','LineWidth',linewidth,'MarkerSize',4); hold on
    %plot(time,model_resp_TANK5(1:pnstep,plotindx),'g--','LineWidth',linewidth,'MarkerSize',4); hold on
set(gca,'XTick',[0:5:IRFPeriods],'FontSize',FontsizeAcalvos,'fontname',Fonttype);     xlim([1 IRFPeriods])
        plot(1:IRFPeriods,zeros(IRFPeriods,1),StyleZeros,'HandleVisibility','off','Color',ColorZeros,'Linewidth',0.5); xlim([0 IRFPeriods]);

%    if plotindx==1
          
    %ylabel('Dev. (%) ','Fontsize',FontsizeAcalvos,'fontname',Fonttype);

  %  elseif plotindx==4
     %           ylabel('Dev. (%) ','Fontsize',FontsizeAcalvos,'fontname',Fonttype);

%    end
    hold off
    data_varnames{1} = 'Government Spending';
    title(data_varnames(plotindx),'FontSize',FontsizeDefault,'fontname',Fonttype,'FontWeight','normal');
    axis tight
    
    if plotindx > 4
        xlabel('Time (quarters)','FontSize',FontsizeAcalvos,'fontname',Fonttype)
end
    
end

xSize = 17.5;
ySize = 12.5; 
xCut = 0;
yCut = 0;

subplot(3,2,1)
 % leg = legend('Ionisation','Recombination');
 %pos = get(leg,'Position')
   legend_string={['VAR ',num2str(conflevel*100),'%'],'VAR mean','CW','UH','UW'}; %legend string
            legend1=legend(legend_string);%, 
           set(legend1,'fontname','times','Location','best','FontSize',FontSizeLegend);
         %  newPosition = [0.2901    0.9610    0.4418    0.0384];
%newUnits = 'normalized';
%set(legend1,'Position', newPosition,'Units', newUnits,'Orientation','horizontal');

  
   set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
      ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-xCut ySize-yCut],'PaperPositionMode','auto')
  FigNamepdf =horzcat(horzcat(TargetPath,FigName),'.pdf');
  
  if OptionPrint == 1
  print(FigNamepdf,'-dpdf','-painters')
  %print(hfig,-'dpdf','-painters',FigNamepdf)
end

