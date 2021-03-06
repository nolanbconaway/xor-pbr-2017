% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close all;clear
addpath([pwd,'/utility/'])
addpath ef
load('data.mat')
whos
%   alphas                   1x4                 32  double              
%   betas                    1x4                 32  double              
%   blockaccuracy           12x8                768  double              
%   blocksize                1x1                  8  double              
%   counterbalance           8x1                 64  double              
%   datetime                 8x1                 64  double              
%   experimentduration       8x1                 64  double              
%   generalizeinfo          81x3x8            15552  double              
%   gradients                9x9x8             5184  double              
%   inputs                   8x1                 64  double              
%   labels                   8x1                 64  double              
%   numblocks                1x1                  8  double              
%   numsubjects              1x1                  8  double              
%   stimuli                 81x2               1296  double              
%   subjectid                8x1                 64  double              
%   traininginfo            96x4x8            24576  double              
%   trialaccuracy           96x8               6144  double              

  
fsize=18;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% ---------------------------------------------------
% plot learning data

data_mean = mean(blockaccuracy,2);
data_dev = stderror(blockaccuracy,2);

figure
fsize=15;
pdfsize=[300 300];
lwidth=4;

plot(data_mean,'k-s','linewidth',2,'markerfacecolor','k','markersize',10);
hold on
errorbar(1:numblocks,data_mean,data_dev,'color','k','linestyle','n','linewidth',1.5)

axis([.5 numblocks+.5 0 1])
axis square; box on
set(gca,'ytick',0:.1:1,'xtick',2:2:numblocks,'fontsize',fsize,'ygrid','on'...
	,'linewidth',2.5)


set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[500 500 pdfsize])
set(gcf, 'color', 'none'); set(gca, 'color', 'none');  
export_fig learning.pdf
