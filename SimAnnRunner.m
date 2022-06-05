function SimAnnRunner(TrialNum)

function SimAnnRunner(TrialNum)
% This function prepares running the simulated annealing based fitting
% process 'TrialNum' number of times. SimAnnRunner loads all data stored in
% external files and needed for the process, and provides them as inputs 
% for the SimAnn function. This way data files are loaded only once instead 
% of 'TrialNum' number of times, which significantly reduces the running 
% time.
%
%
% Inputs for SimAnnRunner:
%
% TrialNum - the number of times the fitting process is run. The value of
% it, in the current format of the code, should be an integer times 100.
%
% parameter_limits.dat - an external ascii file defining the boundaries of
% the parameter space to be explored in the fitting process, as well as the
% step length applied by simulated annealing along the different dimensions
% of the parameter space. Each row in the file corresponds to one parameter
% to be fitted; the number of rows define the number of parameters to be 
% fitted (or equivalently, the number of dimensions of the parameter 
% space). The columns in the file correspond to the lower (Column #1) and 
% the upper boundary (Column #2) of a parameter interval to be explored, 
% and the step length (Column #3) the simulated annealing applies within 
% the interval.
%
% blooming_[cultivar].dat, tc_string_[cultivar].dat, temperatures.dat - 
% ascii data files that should be available in 'Data' folder.
% 
%
% Outputs of SimAnnRunner:
% - The main output is produced in the format of an ascii text file 
% ('Optimal_Params_[TrialNum/100].txt'). Each row of the output file 
% contains the values of the parameters fitted in a single trial. The last 
% column gives the measure of goodness of fit (in our case, the root sum of 
% squared deviations between data points and the reference model, a.k.a. 
% the root mean square error or RMSE) corresponding to the parameter values
% in the previous columns. The output file is saved after every 100th trial 
% under the name 'Optimal_Params_[i/100].txt', and the previous output file 
% is deleted.
%
%
% Credits: 
% Peter Raffai, Ildiko Mesterhazy
% All rights reserved. (2022)
% Contact: peter.raffai@ttk.elte.hu
%

% Loading input files. See the detailed description of them in the header 
% of this file.
InputParams=load('parameter_limits.dat');
BB=load('Data/blooming_ro.dat');
H=load('Data/temperatures.dat');
TC=load('Data/tc_string_ro.dat');

% We start measuring the running time here. Whenever command 'toc' is used, 
% the running time until that point is output to the screen.
tic 

% This is the main cycle of the program, that we run 'TrialNum' number of
% times.
for i=1:TrialNum
    
    % We run the simulated annealing defined in function SimAnn.m. Each
    % trial results with a row of optimal parameters, and a corresponding
    % measure of goodness of fit (in our case, the root sum of squared 
    % deviations between data points and the reference model, a.k.a. the 
    % root mean square error or RMSE)
    OutMatrix(i,:)=SimAnn(InputParams,BB,H,TC);
    
    % We save the output matrix 'OutMatrix' after every 100th trial in file 
    % 'Optimal_Params_[i/100].txt', and delete the previous output file 
    % (if there is one).
    if((i/100)==floor(i/100))
        [i,100*i/TrialNum,toc] % checking the status of the run on the screen
        FileName=sprintf('Optimal_Params_%i.txt',i/100);
        save(FileName,'OutMatrix','-ascii');
        if((i/100)>1)
            DelFileName=sprintf('Optimal_Params_%i.txt',(i/100)-1);
            delete(DelFileName);
        end
    end
    
end