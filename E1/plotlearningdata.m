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


conditiontitles = {'Partial','Full'};

blockaccuracy = blockrows(trainingaccuracy,8);
numblocks = size(blockaccuracy,1);

colors = [1 0 0; 
	0 0 0];
styles = {'-s','--o'};
% ---------AGGREGATE LINES
figure
for c=[2]
	whichsubjects = condition==c;
	data_mean = mean(blockaccuracy(:,whichsubjects),2);
	data_dev = stderror(blockaccuracy(:,whichsubjects),2);
	plot(data_mean,char(styles(c)),'linewidth',2,'markersize',10,...
		'color',colors(c,:),'markerfacecolor',colors(c,:));
	hold on
end
	
axis([.5 numblocks+.5 0 1.1])
set(gca,'ytick',0:.1:1,'xtick',2:2:numblocks,'fontsize',fsize*.9,'ygrid','on'...
	,'linewidth',2.5)
box on
l = legend(conditiontitles,'fontsize',fsize);
set(l,'location','southeast','fontsize',fsize*0.8,'linewidth',2)

for c=[2]
	whichsubjects = condition==c;
	data_mean = mean(blockaccuracy(:,whichsubjects),2);
	data_dev = stderror(blockaccuracy(:,whichsubjects),2);
	errorbar(data_mean,data_dev,'-','color',colors(c,:),...
			'linestyle','n','linewidth',1.5)
	hold on
end
axis square
pdfsize=[500,500];
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize])
print(gcf,'-dpng','learning_line.png')