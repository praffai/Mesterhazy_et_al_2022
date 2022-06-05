function RMSE=Blooming(Params,BB,H,TC)
% This function calculates the measure of goodness of fit (in our case, 
% the root sum of squared deviations between data points and the 
% reference model, a.k.a. the root mean square error or RMSE) for 
% parameter values input in vector 'Params'.
%
%
% Inputs for Blooming:
%
% Params - a vector that contains the test values of model parameters
% (for a detailed description of these parameters, see the header of 
% 'parameter_limits.dat') for which the measure of goodness of fit is 
% to be calculated by Blooming.
%
% BB, H, TC - matrices of input data loaded from ascii data files 
% blooming_[cultivar].dat, temperatures.dat, and tc_string_ro.dat in 
% 'Data' folder, respectively. For a description of the data matrices, 
% see the headers of the corresponding data files.
%
% Output of Blooming:
% RMSE - the measure of goodness of fit (in our case, the root sum of 
% squared deviations between data points and the reference model, 
% a.k.a. the root mean square error or RMSE).
%
%
% Credits: 
% Peter Raffai, Ildiko Mesterhazy
% All rights reserved. (2022)
% Contact: peter.raffai@ttk.elte.hu
%


%     Adaptation of the simplified Chuine's Unified Model to begenning of blooming of Hungarian apricots in 1994-2020.
%     We use Simulates Annealing Method to optimized the parameters.

%     Important dates are:
%     t0 - beginning of chilling unit accumulation (1st September)
%     TC - end of chilling unit accumulation
%     t1 - beginning of forcing unit accumulation, reach the critical amount of chilling unit
%     tb - end of forcing unit accumulation, reach the critical amount of forcing unit

%     Important amounts are:
%     Ccrit - the critical amount of chilling unit 
%     Ctot - the total amount of chilling unit
%     Fcrit - the critical amount of forcing unit
%     Ftot - the total amount of forcing unit
%     Sf - sum of forcing unit
%     In our work TC=t1 (string stage), therefore Ccrit=Ctot. 

%     As input data we use daily mean temperatures - H; string stage dates - TC; beginning of blooming dates - BB. 
%     We optimize ac, cc, bf, cf and kexp (transformed k) parameters.


ac=Params(1);
cc=Params(2);
bf=Params(3);
cf=Params(4);
w=44.8;
k=-10^(-Params(5));
 
%     Bad values are -99.9.
      bad=-99.9;
      
      t0=1;
            
      m=size(H,1);
      n=size(H,2);

%     We check the input data.
      H(find((H<-100)|(H>100)))=bad;

%     The calculation:
%     We calculate the critical and total sum of chilling unit (Ccrit=Ctot) from t0 to TC.
      Sc=zeros(1,n);

      Ctot=zeros(1,n);
      for j=1:n
        szum=0;
        for i=t0:TC(j)
            szum=2/(1+exp(ac*(H(i,j)-cc)^2));
            Ctot(j)=Ctot(j)+szum;
        end
      end

%     We calculate the critical sum of forcing unit 
      Fcrit=w*exp(k*Ctot);      

%     We calculate the forcing unit accumulation from TC to tb. If the sum of forcing unit reaches the critical amount of forcing unit, we finish the calculation. We define this day as tb and Sf as Ftot.          
      Sf=zeros(1,n);
      for j=1:n
        szum=0;
        for i=TC(j):m    
            if(H(i,j)~=bad) 
                szum=1/(1+exp(bf*(H(i,j)-cf)));
                Sf(j)=Sf(j)+szum;
                if(Sf(j)>Fcrit(j))
                    tb(j)=i;
                    break;
                else
                    tb(j)=1000;
                end
            end 
        end
        if(tb(j)==1000)
            RMSE=bad;
            return;
        end
      end

%     The output parameter is RMSE.      
      szum=sum((BB-tb').^2);
      RMSE=(szum/n)^0.5;



