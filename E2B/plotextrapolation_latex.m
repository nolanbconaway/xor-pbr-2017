% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                 Size               Bytes  Class   
%   alphas               1x4                   32  double              
%   betas                1x4                   32  double              
%   blockaccuracy       12x21                2016  double              
%   blocksize            1x1                    8  double              
%   counterbalance      21x1                  168  double              
%   criticals            1x9                   72  double              
%   expduration         21x1                  168  double              
%   extrapolations      21x1                  168  double              
%   generalization      49x21                8232  double              
%   generalizeinfo      15x3x21              7560  double              
%   inputs               8x1                   64  double              
%   labels               8x1                   64  double              
%   numblocks            1x1                    8  double              
%   numsubjects          1x1                    8  double              
%   similarity           4-D               806736  double              
%   stimuli             49x2                  784  double              
%   subjectid           21x1                  168  double              
%   testaccuracy        21x1                  168  double              
%   traininginfo        96x4x21             64512  double              
%   trialaccuracy       96x21               16128  double              

  
lwidth=1;
pdfsize=[250 250];
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


fopts = struct('fontsize',12,'fontname','times new roman');

bins = 0:9;
fsize=12;
lwidth=1;
pdfsize=[250 250];

figure
hist(extrapolations,bins)
set(get(gca,'child'),'FaceColor',[0.5 0.5 0.5],'EdgeColor','k','linewidth',lwidth);
axis([-0.5 9.5 0 numsubjects])
set(gca,fopts,'ygrid','on','linewidth',lwidth,'ytick',0:5:30,'box','on')
axis square
set(gcf, 'position',[500 500 pdfsize],'color','w')
set(gca, 'color','w')

xlabel('Frequency of Reduced Category Responses')
ylabel('Number of Participants')

fname = '/Users/nolan/Desktop/XOR/partial-xor-pbr/figs/e2bhistogram.tex';
matlab2tikz(fname);
