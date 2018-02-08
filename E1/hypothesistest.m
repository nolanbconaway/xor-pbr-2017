% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
addpath([pwd,'/utility/effectsize/'])
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
generalization = gradientroll(gradients,'unroll');


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

num_extrapolations = sum(generalization(nums,:)==1)';


data = mean(trainingaccuracy,1);
g1 = data(num_extrapolations > 5);
g2 = data(num_extrapolations < 4);
[H,P,CI,STATS] = ttest2(g1,g2)
