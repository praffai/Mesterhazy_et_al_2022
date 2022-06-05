function RunThis
% This is the main code you should run for fitting the reference model
% to your input dataset. RunThis.m runs a simulated annealing based fitting 
% process 'TrialNum' number of times, each resulting with a set of fitted 
% parameters given in a row of output file 
% 'Optimal_Params_[TrialNum/100].txt'. The last column in the output file 
% gives the measure of goodness of fit (in our case, the root sum of 
% squared deviations between data points and the reference model, a.k.a. 
% the root mean square error or RMSE) corresponding to the parameter values 
% in the previous columns.
%
% The hierarchy of functions in the code package is the following:
% (1) RunThis.m calls SimAnnRunner.m
% (2) SimAnnRunner.m needs 
% - parameter_limits.dat, and 
% - input data files 
%	a) blooming_[cultivar].dat,
%	b) tc_string_[cultivar].dat, and
%	c) temperatures.dat
% in 'Data' folder.
% (3) SimAnnRunner.m calls SimAnn.m
% (4) SimAnn.m calls Blooming.m
%
% Inputs for RunThis:
% TrialNum - a hardcoded parameter defining the number of times the fitting
% process is run. The value of it, in the current format of the code, 
% should be an integer times 100.
%
% Outputs of RunThis:
% The output is produced by SimAnnRunner.m in the format of an ascii file 
% ('Optimal_Params_[TrialNum/100].txt').
%
% Credits: 
% Peter Raffai, Ildiko Mesterhazy
% All rights reserved. (2022)
% Contact: peter.raffai@ttk.elte.hu
%

% Setting the number of trials in the fitting process
TrialNum=10000;

% Running the simulated annealing-based fitting process 'TrialNum' number
% of times
SimAnnRunner(TrialNum);

