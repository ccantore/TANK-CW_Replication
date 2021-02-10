%% TANK-CW


%Pre-processor variable to choose which type of model do you want to run
@#define model_version = 1
%If model_version = 0 RANK
%If model_version = 1 TANK-CW Model
%If model_version = 2 TANK-CH Model
%If model_version = 3 TANK-UH Model
%If model_version = 4 TANK-UW Model
%% Various options to choose from below


%Fiscal policy
@#define gov_spending = 1
%=1 with >0 G in steady state, 0 otherwise

%Pre-processor variable to choose to remove Sticky wages from the model
@#define sticky_wages = 1
    %If sticky_wages > 0 sticky wages 
    %If sticky_wages <= 0 remove sticky wages from the model



                    @#if gov_spending == 1
@#define debt_gdp_steadystate = 1
%>0 B/Y in ss
                    @#else
                    @#define debt_gdp_steadystate = 0  
                    %%CAN'T BE CHANGED
%=0 B/Y in ss
                    @#endif

%Profits in ss
@#define free_entry = 0
%=1 profits>0 in ss, =0 profits=0 in ss



%%DO NOT CHANGE THE FOLLOWING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@#if model_version == 0
%Capitalists supplying labor
@#define U_ls = 1
%=1 U supply labor, =0 they don't
%Portfolio Adjustment Costs
@#define PAC = 0
%=1 H with PAC, =0 H-t-M
@#else
            @#if (model_version == 1|| model_version ==2)
                %Capitalists supplying labor
                @#define U_ls = 0
                %=1 U supply labor, =0 they don't
                %Portfolio Adjustment Costs
                @#define PAC = 1
                %=1 H with PAC, =0 H-t-M
             @#else
                            @#if (model_version == 3|| model_version ==4)
                            %Capitalists supplying labor
                            @#define U_ls = 1
                            %=1 U supply labor, =0 they don't
                            %Portfolio Adjustment Costs
                            @#define PAC = 1
                            %=1 H with PAC, =0 H-t-M
@#endif
@#endif
@#endif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF ENDOGENOUS VARIABLES%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var 
    UCS           $u^{\prime}(c^C)$                    (long_name='Marginal Utility of Consumption, Capitalists')
    UCH           $u^{\prime}(c^W)$                    (long_name='Marginal Utility of Consumption, Workers')
    UHH           $u^{\prime}(n^W)$                    (long_name='Marginal Utility of Leisure, Workers')
    CS            $c^C$                        (long_name='Consumption, Capitalists')
    CH            $c^W$                        (long_name='Consumption, Workers')
    HH            $n^W$                        (long_name='Hours, Workers')
    HS            $n^C$                        (long_name='Hours, Capitalists')
    UHS           $u^{\prime}(n^C)$                    (long_name='Marginal Utility of Leisure, Capitalists')
    H             $n$                          (long_name='Aggregate Hours') 
    R             $r$                          (long_name='Real Interest Rate')
    Rn            $R$                        (long_name='Nominal Interest Rate')
    PIE           $\Pi$                        (long_name='Inflation')
    PIEW          $\Pi^w$                        (long_name='Wage Inflation')
    MRS           $mrs$                        (long_name='Marginal Rate of Substitution - Aggregate and/or Workers')
    W             $w$                          (long_name='Real Wage')
    Y             $y$                          (long_name='Real Output')
    YW            ${y^m}$                (long_name='Real Wholeseal Output')
    MPL           $mpl$                        (long_name='Marginal Product of Labor')
    MC            $mc$                         (long_name='Real Marginal Costs')
    C             $c$                          (long_name='Consumption')
    G             $g$                          (long_name='Government Spending')
    tax           $t$                          (long_name='Lump Sum Taxes')
    taxS          $t^U$                        (long_name='Lump Sum Taxes, Capitalists')
    taxH          $t^W$                        (long_name='Lump Sum Taxes, Workers')
    BS            $b^{C}$                      (long_name='Government bonds, Capitalists')
    BH            $b^{W}$                      (long_name='Government bonds, Workers')
    B             $b$                          (long_name='Government debt')
    Z             $z$                          (long_name='Labor Augmenting shock process')
    profits       $d$                          (long_name='Profits - aggregate')
    profitsS      $d^C$                        (long_name='Profits - Capitalists')
    LI            $li$                         (long_name='Labor Income')
    LS            $ls$                         (long_name='Labor Share')
    MS             ${ms}$                 (long_name='Price Mark-up shock process')
    WMS            ${wms}$                 (long_name='Wage Mark-up shock process')
    K              ${k}$                          (long_name='Capital Stock')
    MPK           ${mpk}$                        (long_name='Marginal Product of Capital')
    RK            ${r^K}$                        (long_name='Rental Rate of Capital')
    I             ${i}$                          (long_name='Investment')
    IS            ${i^S}$                        (long_name='Investment, Capitalists')
    KS            ${k^S}$                        (long_name='Capital Stock, Capitalists')
    Q             ${q}$                          (long_name='Tobin s Q')
    KSh           ${ks}$                        (long_name='Capital Share')
    U             ${u}$                   (long_name='Variable Capital Utilization')
    Pr            ${Pr}$                         (long_name='Preference Shock process')
    ZI             ${ZI}$                          (long_name='Marginal efficiency of Investment shock process')
%% Variables in deviations from Yss
    profitsY GY BY taxY BHY BSY taxHY taxSY CSl CHl  BHYl BSYl 
    ;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF EXOGENOUS VARIABLES%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varexo 
    epsZ           ${\epsilon^{Z}}$       (long_name='Technology shock')
    epsM           ${\epsilon^{M}}$       (long_name='Monetary Policy shock')
    epsG           ${\epsilon^{G}}$       (long_name='Government Spending shock')
    epsMS          ${\epsilon^{MS}}$      (long_name='Price Mark-up shock')
    epsWMS         ${\epsilon^{WMS}}$     (long_name='Wage Mark-up shock')
    epsPr          ${\epsilon^{Pr}}$      (long_name='Preference shock')
    epsZI          ${\epsilon^{I}}$       (long_name='MEI shock')    
   ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF PARAMETERS%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameters 
   betta          ${\beta}$               (long_name='Discount Factor') 
   sigma_c        ${\sigma}$              (long_name='Intertemporal elasticity of substitution')
   varrho         ${\varphi}$             (long_name='Inverse of Frish elasticity of Labor Supply')  
  // alp            ${\alpha}$              (long_name='capital share (exluding profits)')
   delta          ${\delta}$              (long_name='Capital depreciation')
   phiX           ${\iota}$              (long_name='Investment adjustment costs')
   //xi           ${\xi}$              (long_name='Rotemberg price adj. costs')
   //xiw          ${\xiw}$              (long_name='Rotemberg wage adj. costs')
   zzeta          ${\eta}$            (long_name='Elasticity of substitutions between intermediate goods varieties')
   zzeta_w        ${\eta^w}$            (long_name='Elasticity of substitutions between labor bundles')
   rhoZ           ${\rho^{z}}$            (long_name='autoregressive parameter for Technology shock')
   rhoG           ${\rho^{g}}$            (long_name='autoregressive parameter for Government Spending shock')   
   rho_r          ${\phi^{r}}$            (long_name='Interest rate smoothing')
   theta_pie      ${\phi^{\pi}}$          (long_name='Taylor rule coeff of inflation')  
   theta_y        ${\phi^{y}}$          (long_name='Taylor rule coeff of output')  
   nuH            ${a^W}$               (long_name='Weight on Hours in Utility, Workers')
   lambda         ${\lambda}$             (long_name='Share of Workers Agents')
   nuS            ${a^U}$               (long_name='Weight on Hours in Utility, Capitalists')
   tauD           ${\tau^d}$              (long_name='Tax on Profits')
   rho_tauT       ${\phi^{\tau t}}$       (long_name='Tax Inertia - T')
   phi_tauT_B     ${\phi^{\tau B}}$     (long_name='Fiscal Policy Rule Coefficient on Debt Debt - T')
   phi_tauT_G     ${\phi^{\tau G}}$     (long_name='Fiscal Policy Rule Coefficient on Output - T')
   psiH            ${\psi^W}$                (long_name='Fixed Costs for H bonds')  
   bH            ${\bar{b^W}}$           (long_name='workers bond holdings benchmark level')  
   rhoMS          ${\rho^{MS}}$           (long_name='autoregressive parameter for Price Mark-up shock')
   rhoWMS         ${\rho^{WMS}}$           (long_name='autoregressive parameter for Wage Mark-up shock')
   //gamma1         ${\gamma^{1}}$          (long_name='Variable capital utilization 1')
   //gamma2         ${\gamma^{2}}$          (long_name='Variable capital utilization 2')
   util           ${\upsilon}$                (long_name='Variable capital utilization 3')
   rhoPr          ${\rho^{Pr}}$           (long_name='autoregressive parameter for Preference  shock')   
   rhoZI          ${\rho^{I}}$            (long_name='autoregressive parameter for MEI shock')   
   //eta            ${\nu}$              (long_name='exogenous redistribution')
   //psi            ${\psi}$                (long_name='Slope of Phillips Curve')
   //The following parameters are steady state realtionships
   Hss            ${\bar H}$              (long_name='Steady State Hours') 
   PIEss          ${\bar \Pi}$            (long_name='Steady State Inflation') 
   gy             ${\frac{\bar{G}}{\bar{Y}}}$ (long_name='Government Spending Output Ratio in Steady State')
   BYss           ${\frac{\bar{B}}{\bar{Y}}}$ (long_name='Steady State Government debt to GDP Ratio')
   LSss           ${\bar{ls}}$         (long_name='Steady State Labor Share')    
   //MCss           ${\bar{mc}}$         (long_name='Steady State Labor Share')    
   // kappa          ${\kappa}$            (long_name='Slope of Phillips Curve')
   //kappaw        ${\kappaw}$            (long_name='Slope of Wage Phillips Curve')
     
s_prices_duration s_wages_duration calvo calvo_w
   %CHss Wss HHss profitsss Rss FY Yss calvo psi taxHss  Gss Bss BSss taxss psi
   ;
    
%%%%%%%%%%%%%%%%%%%%%%
%%PARAMETERS VALUES %%
%%%%%%%%%%%%%%%%%%%%%%
betta      = 0.99; %Discount factor
delta      = 0.0250; %depreciation rate
rhoZ       = 0.75; %autoregressive param Z shock (Labor Augmenting)
sigma_c    = 1;%Relative Risk Adversion
varrho     = 1; %Inverse Frish Elasticity of Labor Supply
phiX       = 2;%2.5;%3.8103; %Investment adjustment costs
LSss       = 0.67; %Steady state Labor share

util       = 0.495; %util=0.01 = no utilization // the highe util the higher the utilization in the model (usually calibrated in between 0.5 and 1)



%%Pop share
@#if model_version == 0
lambda     = 0.00001;
@#else
@#if (model_version == 1||model_version == 4)
lambda      =0.7967;
@#else
@#if (model_version == 2||model_version == 3)
lambda      =0.1861;
@#endif
@#endif
@#endif



theta_pie  = 1.5; %Taylor rule elasticity of interest rate to inflation
rho_r      = 0.7;%  %Taylor rule interest rate smoothing
theta_y    = 0;% %Taylor rule elasticity of interest rate to output

rhoG       = 0.9;%0.9089;  %autoregressive param G  shock (Government Spending)
rho_tauT   = 0;       
phi_tauT_B = 0.33;      
phi_tauT_G = 0.1;

rhoMS=0.75; %autoregressive param MS shock (Price Mark-up)
rhoWMS=0.75; %autoregressive param WMS shock (Wage Mark-up)
rhoPr      = 0.75; %autoregressive param Pr shock (Preference)
rhoZI       = 0.75; %autoregressive param Z shock (MEI)




@#if gov_spending == 1
gy         = 0.2; %Government Spending Output Ratio
@#else
gy         = 0; %Government Spending Output Ratio
@#endif


bH=0; %Cannot be different from 0
@#if model_version == 0
psiH     = 0;
@#else
@#if (model_version == 3||model_version == 2)
psiH     = 100000;
@#else
@#if (model_version == 1||model_version == 4)
psiH        =0.0742;
@#endif
@#endif
@#endif


@#if debt_gdp_steadystate==1
BYss      = 0.57;     
@#else
BYss      = 0;     
@#endif


@#if sticky_wages > 0
zzeta_w=6;%elasticity of substitution between labor bundles
s_wages_duration=3.5;
@#else
zzeta_w=1000;%elasticity of substitution between labor bundles
s_wages_duration=1.00001;
@#endif



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%STEADY STATE RELATIONSHIPS%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PIEss=1;
Hss=0.33;


zzeta=6;%elasticity of substitution between differentiated goods 
s_prices_duration=3.5;

tauD=0;%1-(1+varrho)/((1-lambda)^(-1)*varrho)-0.001;%Tax on Profits
calvo=1-1/s_prices_duration;
calvo_w=1-1/s_wages_duration;

model(linear);
#eta        = lambda; %exo redistribution
#Rss=1/betta;
#RKss=(Rss-1+delta); 
#gamma1=RKss; 
#gamma2=gamma1*(1/(util)); %var capital utilization as in SW07 
@#if U_ls == 1
#HHss=Hss;
@#else
#HHss=Hss/lambda;
@#endif
#MCss=(zzeta-1)/zzeta; %Steady State Marginal Costs
@#if free_entry == 1
#alp=1-LSss/MCss; %capital share
@#else
#alp=1-LSss; %capital share
@#endif

#Kss=(RKss/(MCss*alp))^(1/(alp-1))*Hss;

#YWss=(Hss)^(1-alp)*Kss^alp;
#Wss=MCss*(1-alp)*(Hss/Kss)^(-alp);
@#if free_entry == 1
    #F=0;
    @#else
    #F=Hss*((Kss/Hss)^alp-(Wss+RKss*Kss/Hss));
@#endif
#Yss=YWss-F;
#FY=F/Yss;
#MRSss=Wss*(1-1/zzeta_w);
#profitsss=Yss-Wss*Hss-RKss*Kss;
#Bss=BYss*4*Yss;
#BSss=Bss/(1-lambda);
#iy=delta*Kss/Yss;
#cy=1-gy-iy;
#Css=cy*Yss;
#Gss=gy*Yss;
#CHss=Css;
#taxss=1/betta*Bss+Gss-Bss; 
#taxHss=eta/lambda*taxss;
#taxSss=(1-eta)/(1-lambda)*taxss;
#xi          = calvo*(zzeta-1)/((1-calvo)*(1-betta*calvo)); % implied Rotemberg parameter (exploiting first-order equivalence)
#xiw         = calvo_w*(zzeta_w-1)/((1-calvo_w)*(1-betta*calvo_w)); % implied Rotemberg parameter (exploiting first-order equivalence)
#kappa       =(zzeta-1)/xi;
#kappaw      = (zzeta_w-1)/xiw;

%% Households
[name='Marginal Utility of Consumption, Capitalists']
UCS=Pr-sigma_c*(CS);
[name='Euler Equation, Capitalists']
UCS=R+UCS(+1);

        @#if U_ls == 0
        [name='Marginal Utility of Leisure, Capitalists']
        UHS=0;
        [name='Labor Supply, Capitalists']
        HS=0;
        @#else
        [name='Marginal Utility of Leisure, Capitalists']
        UHS=varrho*H;
        [name='Labor Supply, Aggregate']
        MRS=varrho*H+sigma_c*(C)-Pr;
        [name='Hours, Capitalists']
        HS=H;
        @#endif
    
[name=' Marginal Utility of Consumption, Workers']
UCH=Pr-sigma_c*(CH);
        @#if U_ls == 0
        [name='Marginal Utility of Leisure, Workers']
        UHH=varrho*HH;
        [name='Labor Supply, Workers']
        MRS=UHH-UCH;
        @#else
        [name='Marginal Utility of Leisure, Workers']
        UHH=varrho*H;
        [name='Hours, Workers']
        HH=H;
@#endif

@#if PAC == 1
[name='Euler Equation, Workers']
UCH=R+UCH(+1)-(psiH/CHss)*BH;

        @#if U_ls == 0
                   @#if free_entry == 1   
                            [name='Consumption, Workers']
                            @#if gov_spending == 1
                            CH+BH*1/(CHss)=(W+HH)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits*profitsss/CHss+BH(-1)*Rss/CHss;
                            @#else
                            CH+BH*1/(CHss)=Wss*HHss/CHss*(W+HH)-1/CHss*taxH+tauD/lambda*profits*profitsss/CHss+BH(-1)*Rss/CHss;
                            @#endif
                  @#else
                            [name='Consumption, Workers']
                            @#if gov_spending == 1
                            CH+BH*1/(CHss)=(W+HH)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits/CHss+BH(-1)*Rss/CHss;
                            @#else
                            CH+BH*1/(CHss)=Wss*HHss/CHss*(W+HH)-1/CHss*taxH+tauD/lambda*profits/CHss+BH(-1)*Rss/CHss;
                            @#endif
                   @#endif  
                   
                   
       @#else   
                   
                  @#if free_entry == 1
                            [name='Consumption, Workers']
                            @#if gov_spending == 1
                            CH+BH*1/(CHss)=(W+H)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits*profitsss/CHss+BH(-1)*Rss/CHss;
                            @#else
                            CH+BH*1/(CHss)=Wss*HHss/CHss*(W+H)-1/CHss*taxH+tauD/lambda*profits*profitsss/CHss+BH(-1)*Rss/CHss;
                            @#endif
                  @#else
                            [name='Consumption, Workers']
                            @#if gov_spending == 1
                            CH+BH*1/(CHss)=(W+H)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits/CHss+BH(-1)*Rss/CHss;
                            @#else
                            CH+BH*1/(CHss)=Wss*HHss/CHss*(W+H)-1/CHss*taxH+tauD/lambda*profits/CHss+BH(-1)*Rss/CHss;
                            @#endif
                   @#endif  
                   
        @#endif            
                   
@#else
[name='Bonds, Workers']
BH=0;  

          @#if U_ls == 0  
                 @#if free_entry == 1
                        [name='Consumption, Workers']
                        @#if gov_spending == 1
                        CH=(W+HH)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits*profitsss/CHss;
                        @#else
                        CH=Wss*HHss/CHss*(W+HH)-1/CHss*taxH+tauD/lambda*profits*profitsss/CHss;
                        @#endif   
                 @#else
                         [name='Consumption, Workers']
                        @#if gov_spending == 1
                        CH=(W+HH)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits/CHss;
                        @#else
                        CH=Wss*HHss/CHss*(W+HH)-1/CHss*taxH+tauD/lambda*profits/CHss;
                        @#endif 
                 @#endif 
                 
        @#else 
                 
                 @#if free_entry == 1
                        [name='Consumption, Workers']
                        @#if gov_spending == 1
                        CH=(W+H)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits*profitsss/CHss;
                        @#else
                        CH=Wss*HHss/CHss*(W+H)-1/CHss*taxH+tauD/lambda*profits*profitsss/CHss;
                        @#endif   
                 @#else
                        [name='Consumption, Workers']
                        @#if gov_spending == 1
                        CH=(W+H)*Wss*HHss/CHss-taxHss/CHss*taxH+tauD/lambda*profits/CHss;
                        @#else
                        CH=Wss*HHss/CHss*(W+H)-1/CHss*taxH+tauD/lambda*profits/CHss;
                        @#endif 
                 @#endif 
        @#endif
          
@#endif

%% Firms
[name='Cobb-Douglas Prodution function']
YW=(1-alp)*(Z+H)+(alp)*(U+K(-1));
[name='Real Output']
Y=YW*(1+FY);
[name='Marginal product of Labor']
MPL=YW-H;
[name='Real Wage']
W=MC+MPL;
[name='Marginal product of Capital']
MPK=YW-U-K(-1);
[name='Rental Rate']
RK=MC+MPK;
[name='Profits']
@#if free_entry == 1
         profits=Y*Yss/profitsss-(W+H)*Wss*Hss/profitsss-(RK+U+K(-1))*(RKss*Kss)/profitsss;
@#else
%profitsY=Y-(W+H)*LSss-(RK+U+K(-1))*(1-LSss);
Y=(W+H)*Wss*Hss/Yss+(RK+U+K(-1))*(RKss*Kss)/Yss+profits/Yss;
@#endif


[name='Profits - Capitalists']
profits=profitsS;
[name='Labor Income']
LI=W+H;
[name='Labor Share']
LS=W+H-Y;
[name='7. Capital Share']
KSh = RK+U+K(-1)-Y;

[name='Variable capital Utilization'] 
RK=gamma2/gamma1*U;
[name='Capital Law of Montion'] 
KS=delta*(IS+ZI) +(1-delta)*KS(-1);
[name=' Arbitrage condition for capital demand'] 
Rn-PIE(+1)=betta*(1-delta)*Q(+1)+(1-betta*(1-delta))*(RK(+1))-Q;
[name=' Investment Equation'] 
(1+1/(Rss))*IS= 1/(Rss)*IS(+1)+IS(-1)+1/(2*phiX*(1)^2)*(Q+ZI); 

[name='Aggregation: Investment']
I=IS;
[name='Aggregation: Capital']
K=KS;


[name='Resource Constraint'] 
@#if gov_spending == 1
Y=C*cy+G*gy+iy*I+gamma1*Kss/Yss*U;
@#else
Y=C*cy+GY+iy*I+gamma1*Kss/Yss*U;
@#endif

[name='Fisher Equation'] 
R=Rn-PIE(+1);
[name='Aggregation: Consumption']
C=lambda*CH+(1-lambda)*CS;

@#if U_ls == 0
[name='Aggregation: Labor']
H=HH;
@#endif


%%%%%%%%%%%%%%%%%%%%%%
%%Inflation Dynamics%%
%%%%%%%%%%%%%%%%%%%%%% 
[name='Linear Phillips Curve '] 
PIE=betta*PIE(+1)+kappa*(MC+MS);

[name='Linear Wage Phillips Curve '] 
PIEW=betta*PIEW(+1)+kappaw*(MRS-W+WMS);


[name='Wage inflation '] 
PIEW=W-W(-1); 

[name='Taylor Rule'] 
Rn=rho_r*Rn(-1)+(1-rho_r)*(theta_pie*(PIE)+theta_y*Y)+epsM;

[name='Labor Augmenting Shock'] 
Z=rhoZ*Z(-1)+epsZ;

[name='Government Spending Shock'] 
G=rhoG*G(-1)+epsG;
[name='Government Budget Constraint']
//tax=G;
@#if gov_spending == 1
    @#if debt_gdp_steadystate==1
    B=(B(-1)+R(-1))*Rss+G*Gss/Bss-tax*taxss/Bss;
    @#else    
    B/Gss=1/betta*(B(-1))/Gss+G-tax;
    @#endif
@#else
B=1/betta*(B(-1))+G-tax;
@#endif



[name='Aggregation: Gov. Bonds']
@#if PAC == 1
    @#if debt_gdp_steadystate==1
    B=BS+lambda*BH/Bss;
    @#else      
    B=(1-lambda)*BS+lambda*BH;
    @#endif
@#else     
    @#if debt_gdp_steadystate==1
    B=BS;
    @#else
    B=(1-lambda)*BS;
    @#endif
@#endif
[name='Tax Rule']
tax=rho_tauT*tax(-1)+phi_tauT_B*B(-1)+phi_tauT_G*G;



[name='Price Mark-up Shock'] 
MS=rhoMS*MS(-1)+epsMS;
[name='Wage Mark-up Shock'] 
WMS=rhoMS*WMS(-1)+epsWMS;

[name='Preference Shock'] 
Pr=rhoPr*Pr(-1)+epsPr;
[name='MEI Shock'] 
ZI=rhoZI*ZI(-1)+epsZI;


%variables in deviations of Yss
profitsY=profits/Yss;
BY=B/Yss;
BHY=BH/Yss;
BSY=BS/Yss;
GY=G/Yss;
taxY=tax/Yss;
taxHY=taxH/Yss;
taxSY=taxS/Yss;


[name='Tax Rule, Unonstrained']
taxS=(1-eta)/(1-lambda)*tax;
[name='Tax Rule, Workers']
taxH=eta/lambda*tax;

%variables weighted for lambda
CSl=(1-lambda)*CS;
CHl=lambda*CH;
BSYl=(1-lambda)*BSY;
BHYl=lambda*BHY;
end;

shocks;
var epsZ; stderr 1;
var epsM; stderr 1;
var epsG; stderr 1/gy; %% SS Output
var epsMS; stderr 1;
var epsWMS; stderr 1;
var epsPr; stderr 1;
var epsZI; stderr 1;
end;

steady;
check;
resid(1);


/*
write_latex_parameter_table;
write_latex_dynamic_model;
write_latex_definitions;
collect_latex_files;
*/
%%%%%%%%%%%%%%%%%%%%%%%%%
%%STOCHASTIC SIMULATION%%
%%%%%%%%%%%%%%%%%%%%%%%%%
stoch_simul(order=1,irf=20,nograph,noprint);

@#if sticky_wages > 0

    @#if model_version == 0
     save('RANK_linear_SW_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 1
    save('TANK-CW_linear_SW_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 2
    save('TANK-CH_linear_SW_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 3
    save('TANK-UH_EH_linear_SW_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 4
    save('TANK-UW_EH_linear_SW_results.mat', 'oo_', 'M_', 'options_');
    @#endif
    @#endif
    @#endif
    @#endif
    @#endif


 @#else
 
@#if model_version == 0
     save('RANK_linear_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 1
    save('TANK-CW_linear_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 2
    save('TANK-CH_linear_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 3
    save('TANK-UH_EH_linear_results.mat', 'oo_', 'M_', 'options_');
  @#else
    @#if model_version == 4
    save('TANK-UW_EH_linear_results.mat', 'oo_', 'M_', 'options_');
    @#endif
    @#endif
    @#endif
    @#endif
    @#endif


  @#endif