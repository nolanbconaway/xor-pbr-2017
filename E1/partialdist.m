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








a = hist(num_extrapolations,bins);
[bins',a']
% a=a./sum(a);


fsize=35;
lwidth=3;
pdfsize=[400 400];


figure
bar(bins,a,1,'facecolor',[0.5 0.5 0.5],'linewidth',lwidth)
axis([-0.5 n+0.5 0 30])
set(gca,'fontsize',fsize*0.8,'ygrid','on','linewidth',lwidth,'ytick',0:5:30,'box','on')
axis square
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
			'papersize',[pdfsize],'position',[500 500 pdfsize])
	set(gcf, 'color', 'w'); set(gca, 'color', 'w');  
export_fig('untrainedquad.pdf')


[~,alphas,betas]=getproblem(2);




figure
EX = num_extrapolations > 5;
data = mean(gradients(:,:,EX),3);
plotgradient_bw(data,coordinates,alphas,betas,fsize)
set(gca,'linewidth',lwidth)
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[500 500 pdfsize])
set(gcf, 'color', 'w'); set(gca, 'color', 'w');  
export_fig('Extrapolators.pdf','-opengl')

figure
PROX = num_extrapolations < 4;
data = mean(gradients(:,:,PROX),3);
plotgradient_bw(data,coordinates,alphas,betas,fsize)
set(gca,'linewidth',lwidth)
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[500 500 pdfsize])
set(gcf, 'color', 'w'); set(gca, 'color', 'w');  
export_fig('Proximity.pdf','-opengl')
