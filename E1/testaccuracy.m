% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
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

coordinates=load('physcoords_7x7.txt');
fsize=35;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


gradients = gradients(:,:,condition==2);
trainingaccuracy = trainingaccuracy(:,condition==2);
blockaccuracy = blockrows(trainingaccuracy,8);


generalization = gradientroll(gradients,'unroll');


%     43    44    45    46    47    48    49
%     36    37    38    39    40    41    42
%     29    30    31    32    33    34    35
%     22    23    24    25    26    27    28
%     15    16    17    18    19    20    21
%      8     9    10    11    12    13    14
%      1     2     3     4     5     6     7
nums = [5,6,7,12,13,14,19,20,21];


num_extrapolations = sum(generalization(nums,:)==1)';
test_accuracy = mean([generalization([1 9 41 49],:) == 0; generalization([43 37],:) == 1],1);
mean_train = mean(trainingaccuracy,1);
final_block = blockaccuracy(end,:);

g1 = num_extrapolations<4;
g2 = num_extrapolations>5;

for i  = {g1,g2};
	inds = i{1};
	MT = mean(mean_train(inds));
	ST = std(mean_train(inds));
	MF = mean(final_block(inds))
	SF = std(final_block(inds))
	MG = mean(test_accuracy(inds));
	SG = std(test_accuracy(inds));
	
	fprintf( ['\t' num2str(MT,2) ' (' num2str(ST,2) ')\t\t' num2str(MG,2) ' (' num2str(SG,2) ')'     '\n'] )
	
end
