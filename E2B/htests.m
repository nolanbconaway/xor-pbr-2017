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


% compare training accuracy

ex = extrapolations > 5;
prox = extrapolations < 5;


% do ex and prox differ on triaing accuracy?
g1 = mean(trialaccuracy(:,ex),1);
g2 = mean(trialaccuracy(:,prox),1);
[H,P,CI,STATS] = ttest2(g1,g2);
[mean(g1) mean(g2)];





betas = unique(betas);
bx = squeeze(nanmean(nanmean(similarity(betas,criticals,2,:),1),2));
ax = squeeze(nanmean(nanmean(similarity(alphas,criticals,2,:),1),2));


% does ex differ on a-x and b-x pairs?
g1 = ax(ex);
g2 = bx(ex);
[H,P,CI,STATS] = ttest(g1-g2)
[mean(g1) mean(g2)];
[stderror(g1,1) stderror(g2,1)];


[p,h,stats] = signrank(g1,g2)

lll

% does prox differ on a-x and b-x pairs?
g1 = ax(prox);
g2 = bx(prox);
[H,P,CI,STATS] = ttest(g1,g2);
[mean(g1) mean(g2)];
[stderror(g1,1) stderror(g2,1)];


% do ex and prox differ on b-x pairs?
g1 = bx(ex);
g2 = bx(prox);
[H,P,CI,STATS] = ttest2(g1,g2)
[mean(g1) mean(g2)]
[stderror(g1,1) stderror(g2,1)]

% do ex and prox differ on a-x pairs?
g1 = ax(ex);
g2 = ax(prox);
[H,P,CI,STATS] = ttest2(g1,g2)
[mean(g1) mean(g2)]
[stderror(g1,1) stderror(g2,1)]
