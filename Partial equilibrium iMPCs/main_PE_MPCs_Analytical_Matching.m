%%=========================================================================
% iMPCs in a partial equilibrium consumption-savings model with portfolio
% adjustment costs, based on analytical solution in Cantore & Freund (2020)

% This file computes the values of population share $\lambda$ and 
% portfolio adjustment cost parameter $\psi^W$ to match targets
% from micro consumption data (illustrated in Fig 1a)

% Run on Matlab R2019b
% Last updated: September 2020
% For any questions please email lukas.beat.freund@gmail.com
%%=========================================================================

%% Housekeeping
%--------------------------------------------------------------------------
clear; close all; clc;

%% User choices
%---------------------------------------------------------------------------
sPar.R = 1/0.99;            % gross real interest rate 

MPC00Target = 0.1942;       % Q1 impact
MPC40Target = 0.5470;       % cumulatively after four quarters

%% Matching using the analytical solution
%---------------------------------------------------------------------------
syms psi lambda
assume(lambda>0)
assumeAlso(lambda<1)

% Symbolic versions of parameters

phi0 = 1/(1+sPar.R+psi);
phi1 = sPar.R/(1+sPar.R+psi);
phi2 = phi0;
mu = roots([1, -1/phi0, phi1/phi0]); % roots of char poly
mu1 = mu(1);
mu2 = mu(2);

for iT = 0:19
    if iT == 0
        vMPC(iT+1) = 1-mu2^(-1);
    else
        vMPC(iT+1) = (sPar.R-mu1)*mu1^(iT-1)*mu2^(-1);
   end
end

MPC0PIH = (sPar.R-1)/sPar.R; 

MPC00 =  vMPC(1);
MPC00Avg = lambda*MPC00+(1-lambda)*MPC0PIH;

MPC40 = sum(sum(vMPC(1:4)));
MPC40Avg = lambda*MPC40+(1-lambda)*4*MPC0PIH;

[solx,soly] = (solve(MPC00Avg == MPC00Target, MPC40Avg == MPC40Target));
lambdaTarget = double(solx);
psiTarget    = double(soly);

% Model with hand-to-mouth: match quarterly impact MPC only
MPC0PIH = (sPar.R-1)/sPar.R; 
lambdaHTarget = double(solve(lambda+(1-lambda)*MPC0PIH-MPC00Target));

%% Done!
%----------------------------------------------------------------------------
