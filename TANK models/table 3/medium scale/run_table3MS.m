%% Replication code for "Workers, Capitalists, and the Government: Fiscal Policy and Income (Re)Distribution"
%% by C. Cantore and L. B. Freund
%% Journal of Monetary Economics

%% This file replicates Table 3 (Medium Scale Models) in the manuscript



%% Housekeeping
%--------------------------------------------------------------------------
clear;
close all;
clc;
TimeStart = tic;

%% Option: Run new simulation (run_simul==1) or load previous one 
run_simul=1;

%% mod files names
model_strings=['rank___';'tank_uh'; 'tank_uw';'tank_cw'];

%number of models
nM=4;
%Discounting
pDiscount = 0.99;


% Display options
IRFPeriods = 1000; 
OptionGreycolor = 0;    % if want grey colorscheme instead of standard colors
vLinestyle = {'--',':','-','-.'};
FontsizeDefault = 8;
FontsizeAxis = 8;
FontSizeLegend = 8;
FontDefault = 'times';
LinewidthDefault = 1.6;
LinewidthAlt = 1;
ColorZeros = 'k';
StyleZeros = '-';
LinewidthZeros = 0.05;
vColors = {[255 127 0]/255,[128,128,128]/255,[0,0,90]/255,[114,47,55]/255};

vColorsGrey = {[0.2,0.2,0.2],[0.6,0.6,0.6],[0.9,0.9,0.9]};

if run_simul==1
    %initialize multipliers
    mI=zeros(1,nM); mC4=mI; mC8=mI; mC12=mI; mC1000=mI;

        for m=1:nM 
                %%%Run .mod files
                model=['dynare '  model_strings(m,:) ' noclearall'];
                eval(model) 
                mI(m)=1/gy*Y_epsG(1)/G_epsG(1); %Impact multiplier
                        for iT = 1:IRFPeriods
                        vDiscount(iT) = pDiscount.^(iT-1);
                        mGAdj(iT) = vDiscount(iT).*G_epsG(iT);
                        mYAdj(iT) = vDiscount(iT).*Y_epsG(iT);
                        end
                mC4(m)=1/gy*cumsum(mYAdj(1:4))/cumsum(mGAdj(1:4));
                mC(m)=1/gy*cumsum(mYAdj(1:1000))/cumsum(mGAdj(1:1000)); %cumulative multiplier


        end
save mult nM mI  mC
else
    
        load mult
    
end


display('Impact Multiplier')
mI
display('Cumulative Multiplier')
mC
