%% Replication code for "Workers, Capitalists, and the Government: Fiscal Policy and Income (Re)Distribution"
%% by C. Cantore and L. B. Freund
%% Journal of Monetary Economics

%% This file replicates Figure 7 in the manuscript

clear all
close all
clc

% Run mod files (you need Dynare 4.5.x or later installed)
dynare tank_uh
clear all
dynare tank_uw
clear all
dynare tank_cw
clear all

%Plot figure
plot_fig7


