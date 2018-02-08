% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
addpath ef
load('twistedxor2data.mat')
whos
%   Name                   Size               Bytes  Class     Attributes
% 
%   condition             57x1                  456  double              
%   generalizeinfo        49x2x57             44688  double              
%   gradients              7x7x57             22344  double              
%   profiles              57x1                  456  double              
%   rottenapples          26x1                  208  double              
%   subjectnumber         57x1                  456  double              
%   trainingaccuracy      96x57               43776  double              
%   traininginfo          96x3x57            131328  double         

problemnames={'Full XOR','Partial XOR','Twisted XOR','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

gradients = gradients(:,:,condition==2);
generalizeinfo = generalizeinfo(:,:,condition==2);
data = gradientroll(gradients,'unroll');


%     43    44    45    46    47    48    49
%     36    37    38    39    40    41    42
%     29    30    31    32    33    34    35
%     22    23    24    25    26    27    28
%     15    16    17    18    19    20    21
%      8     9    10    11    12    13    14
%      1     2     3     4     5     6     7
nums = [5,6,7,12,13,14,19,20,21];

bins = 0:9;
n = numel(nums);

num_extrapolations = sum(data(nums,:)==1)';

whichsubjects = num_extrapolations>5;

all_data = generalizeinfo(:,:,whichsubjects);
ordered_data = NaN(9,sum(whichsubjects));

for i=1:sum(whichsubjects)
	N=1;
	for j=1:49
		if any(nums==all_data(j,1,i))
			ordered_data(N,i) = all_data(j,3,i);
			
			N=N+1;
		end
	end
end

ordered_data
