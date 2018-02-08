% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                      Size                Bytes  Class     Attributes
%   alphas                1x4                  32  double              
%   betas                 1x4                  32  double              
%   blockaccuracy        12x30               2880  double              
%   blocksize             1x1                   8  double              
%   counterbalance       30x1                 240  double              
%   criticals             9x4                 288  double              
%   expduration          30x1                 240  double              
%   generalization        9x4x30             8640  double              
%   generalizeinfo       42x3x30            30240  double              
%   inputs                8x1                  64  double              
%   labels                8x1                  64  double              
%   numblocks             1x1                   8  double              
%   numsubjects           1x1                   8  double              
%   stimuli             144x2                2304  double              
%   subjectid            30x1                 240  double              
%   traininginfo         96x4x30            92160  double              
%   trialaccuracy        96x30              23040  double                      


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

extrapolators = squeeze(sum(generalization(:,2,:),1))>5;
proximity = squeeze(sum(generalization(:,2,:),1))<4;
[sum(extrapolators) sum(proximity)]

% compare training accuracy
g1 = mean(trialaccuracy(:,extrapolators));
g2 = mean(trialaccuracy(:,proximity));
[H,P,CI,STATS] = ttest2(g1,g2);
[mean(g1) mean(g2)];

% compare test accuracy
testaccuracy = zeros(1,numsubjects);
for i = 1:numsubjects
	egs = generalizeinfo(:,1,i);
	re = generalizeinfo(:,3,i);
	testaccuracy(i) = sum(re(ismember(egs,alphas))==0) + sum(re(ismember(egs,betas))==1);
end
testaccuracy =testaccuracy /6;
g1 = testaccuracy(extrapolators);
g2 = testaccuracy(proximity);
[H,P,CI,STATS] = ttest2(g1,g2);
[mean(g1) mean(g2)];


% do extrapolators classify w, y, and Z beyond chance?


for i =1:4
	g = squeeze(sum(generalization(:,i,extrapolators),1));
	[H,P,CI,STATS] = ttest(g,4.5)
	
	
end