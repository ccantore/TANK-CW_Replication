%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF ENDOGENOUS VARIABLES%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var
    n             $n$                          (long_name='Aggregate Hours') 
    w             $w$                          (long_name='Real Wage')
    c             $c$                          (long_name='Consumption')
    cU            $c^U$                        (long_name='Consumption, Unconstrained')
    cW            $c^W$                        (long_name='Consumption, Workets')
    rn            $R$                          (long_name='Nominal Interest Rate')
    r             $r$                          (long_name='Real Interest Rate')
    pi            $\Pi$                        (long_name='Inflation')
    bU            $b^U$                        (long_name='Bonds, Unconstrained')
    bW            $b^W$                        (long_name='Bonds, Workers')
    b             $b$                          (long_name='Bonds, Aggregate')
    t             $t $                         (long_name='Lump Sum Taxes')
    g             $g $                         (long_name='Government spending')
    d             $d$                          (long_name='Profits - aggregate')
    csl chl bsl bhl ls
    ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF EXOGENOUS VARIABLES%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varexo 
    eps           ${\epsilon}$       (long_name='Government spending shock')
   ;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DECLARATION OF PARAMETERS%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameters 
   phi         ${\varphi}$             (long_name='Inverse of Frish elasticity of Labor Supply')  
   theta       ${\theta}$              (long_name='Calvo prices')
   xi          ${\xi}$                 (long_name='Rotember price adj costs')
   beta        ${\beta}$               (long_name='Discount Factor') 
   phi_t       ${\phi^{\tau t}}$       (long_name='Fiscal rule coeff of taxes')  
   phi_b       ${\phi^{\tau g}}$       (long_name='Fiscal rule coeff of G')  
   phi_g       ${\phi^{\tau b}}$       (long_name='Fiscal rule coeff of B')  
   lambda      ${\lambda}$             (long_name='Share of Workers')
   phi_pi      ${\phi^{\pi}}$          (long_name='Taylor rule coeff of inflation')  
   rho         ${\rho}$                (long_name='AR(1) Government spending shock')  
   psiW         ${\psi^W}$               (long_name='PACs')  
   eta          ${\eta}$               (long_name='Elasticity of substitutions between intermediate goods varieties')
   ;

%%%%%%%%%%%%%%%%%%%%%%
%%PARAMETERS VALUES %%
%%%%%%%%%%%%%%%%%%%%%%

   phi         =0.05;  
   beta        =0.99;
   lambda      =0.7967;
   eta         =6;
   phi_pi      =1.5;  
   rho         =0.9;  
   phi_t       =0;
   phi_b       =0.33;  
   phi_g       =0.1;
   theta       =1-1/3.5;
   psiW        =0.0742;
   xi          = theta*(eta-1)/((1-theta)*(1-beta*theta)); % implied Rotemberg parameter (exploiting first-order equivalence)

   
   
model(linear);
    [name='Euler equation, U'] 
    cU=cU(+1)-(rn-pi(+1));
    [name='Budget constraint, U'] 
    cU+bU=n+w+d/(1-lambda)-t+bU(-1)/beta;
    [name='Euler equation, W'] 
    cW=cW(+1)-(rn-pi(+1))+psiW*bW;
    [name='Budget constraint, H'] 
    cW+bW=w+n+bW(-1)/beta-t;
    [name='Aggregate consumption'] 
    c=lambda*cW+(1-lambda)*cU;
    [name='Labor Supply'] 
    phi*n=w-c;
    [name='Profits'] 
    d=-w;
    [name='Phillips curve'] 
    pi=beta*pi(+1)+eta/xi*w;  
    [name='Government Budget constraint'] 
    b=1/beta*b(-1)+g-t;
    [name='Government spending'] 
    g=rho*g(-1)+eps;       
    [name='Fiscal Rule'] 
    t=phi_t*t(-1)+phi_b*b(-1)+phi_g*g;
    [name='Taylor Rule'] 
    rn=phi_pi*pi;
    [name='Fischer Equation'] 
    r=rn-pi(+1);
    [name='Bonds, Aggregate'] 
    b=lambda*bW+(1-lambda)*bU; 
    
    %weighted variables
    csl=(1-lambda)*cU;
    chl=lambda*cW;
    bsl=(1-lambda)*bU;
    bhl=lambda*bW;
    ls=w;
end;
   
steady;
check;



shocks;
var eps; stderr 1;
end;

stoch_simul(order=1,irf=20,noprint,nograph);
