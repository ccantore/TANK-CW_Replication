%% Reads irfs from SVAR and save them in the format needed for Impulse response matching

clear all
close all
clc


load VAR_IRFs_F14L2C3S6LS7_Surprise_Large_10Variables


gnorm2=max(squeeze(mean(irf(1,1,:,:),4))); %max of v1 to shock 1
irf=irf./gnorm2;

irf=squeeze(irf(:,1,:,:));
%plot(squeeze(prctile(irf(2,2,:,:),[50],4)))
gnorm3=max(squeeze(prctile(irf(1,:,:),[50],3)));
irf=irf./gnorm3;

names{1}='Government Spending';
names{2}='F(1,4)';
names{3}='Taxes';
names{4}='GDP';
names{5}='Consumption';
names{6}='Investment';
names{7}='Labor Share';
names{8}='Corporate Profits';
names{9}='Inflation';
names{10}='10y Real Yield';
hor=20;

figure
for i=1:numel(names)
    imp=[squeeze(prctile(irf(i,:,:),[16],3)); squeeze(prctile(irf(i,:,:),[50],3)); squeeze(prctile(irf(i,:,:),[84],3))]';
    subplot(4,3,i)
    plot(imp(:,1:3))
    hold;
    plot(zeros(1,hor),'-')
    title(names{i})
    axis tight
    xlim([1 hor])
set(gca,'XTick',0:5:hor)
end


%get pointwise variance of IRFs across draws and compute weighting matrix
 IRF_variances=var(irf([1,4,7,5,6,9,8,3],:,:),0,3)';
 IRF_weighting=inv(diag(IRF_variances(2:end)));
 IRF_mat=squeeze(prctile(irf([1,4,7,5,6,9,8,3],:,:),[50],3));
 IRF_quantiles = quantile(irf([1,4,7,5,6,9,8,3],:,:),[0.16 0.84],3);    
 
 Y=IRF_mat;
 
 save IRFG Y;
 
 s_Y=sqrt(IRF_variances)';
 
 save IRFGSE s_Y;