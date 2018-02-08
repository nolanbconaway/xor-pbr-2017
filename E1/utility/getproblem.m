function [egs,alphas,betas]=getproblem(problem)



% 43 44	45 46 47 48 49
% 36 37	38 39 40 41 42
% 29 30	31 32 33 34 35
% 22 23	24 25 26 27 28
% 15 16	17 18 19 20 21
% 08 09 10 11 12 13 14
% 01 02 03 04 05 06 07

if problem==1 % full xor
	alphas=[1,9,41,49];
	betas =[7,13,37,43];
end
	
if problem==2 % partial xor
	alphas=[1,9,41,49];
	betas =[37,43,37,43];
end
	
if problem==3 %twisted xor
	alphas=[4,11,39,46];
	betas =[22,23,27,28];
end
	
if problem==4 %partial twisted
	alphas=[4,11,39,46];
	betas =[22,23,22,23];
end
	
egs=[alphas,betas];
