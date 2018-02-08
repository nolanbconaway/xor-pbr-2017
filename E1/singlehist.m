% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                      Size                Bytes  Class     Attributes
%   alphas                   1x4                  32  double              
%   betas                    1x4                  32  double              
%   blockaccuracy           12x23               2208  double              
%   blocksize                1x1                   8  double              
%   counterbalance          23x1                 184  double              
%   datetime                23x1                 184  double              
%   experimentduration      23x1                 184  double              
%   generalizeinfo          81x3x23            44712  double              
%   gradients                9x9x23            14904  double              
%   inputs                   8x1                  64  double              
%   labels                   8x1                  64  double              
%   numblocks                1x1                   8  double              
%   numsubjects              1x1                   8  double              
%   stimuli                 81x2                1296  double              
%   subjectid               23x1                 184  double              
%   traininginfo            96x4x23            70656  double              
%   trialaccuracy           96x23              17664  double           

fsize=20;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%  73 74 75 76 77 78 79 80 81
%  64 65 66 67 68 69 70 71 72
%  55 56 57 58 59 60 61 62 63
%  46 47 48 49 50 51 52 53 54
%  37 38 39 40 41 42 43 44 45
%  28 29 30 31 32 33 34 35 36
%  19 20 21 22 23 24 25 26 27
%  10 11 12 13 14 15 16 17 18
%   1  2  3  4  5  6  7  8  9



n=12;

data = gradientroll(gradients,'unroll');
a = data([52 53 54 62 63 72],:)==0;
b = data([60 69 70 78 79 80],:)==1;

data = sum(a) + sum(b)

% nonlearners = blockaccuracy(end,:);
% nonlearners = nonlearners<(8/10);
% data = data(~nonlearners)




bins = 0:1:n;
a=hist(data,bins);
a=a/sum(a);

figure
ps = binopdf(0:1:n,n,0.5);
fill([0 0:1:n n] ,[0 ps 0],[1 1 1]*0.7,'linewidth',1,...
	'edgecolor',[1 1 1]*0.7,'facealpha',0.3,'edgealpha',0.3)
hold on
fill([0 bins n] ,[0 a 0],[0 0 0.8],'linewidth',2,'facealpha',0.3)
axis([0 n 0 1])
set(gca,'fontsize',fsize*.9,'ygrid','on','linewidth',2.5,'box','on')
axis square
xlabel('# Diagonal-Consistent Responses')

legend('Binomial Probability','Observed Density')

pdfsize=[400,400];
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',pdfsize)
print(gcf,'-dpng','quadprob.png')


figure
scatter(data/12,blockaccuracy(end,:))
data

