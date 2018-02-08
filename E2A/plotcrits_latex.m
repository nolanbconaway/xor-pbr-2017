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

bins = 0:9;
data=hist(permute(sum(generalization,1),[3,2,1]),bins);


xlim = [2.1 7.4];
ylim = [12 28];

xsp = [xlim(1)+0.45 xlim(2)-0.45];
ysp = [ylim(1)+1.5 ylim(2)-1.5];
space = stimuli;
space = space/2+0.5;
space(:,1) = space(:,1) * range(xsp) + min(xsp);
space(:,2) = space(:,2) * range(ysp) + min(ysp);

  
fsize=12;
fsize2 = 7;
msize=15;
lwidth=0.5;
pdfsize=[1.9 2]*160;
colors = [	1 0 0;
			0.5 0 0.5;
			0 0 1;
			0.25 0.75 0.5];
markers = {'W','X','Y','Z'};
figure
c = 1;
for i =[ 3 4 1 2]
	subaxis(2,2,c,'SpacingHoriz',0.01,'SpacingVert',0.01)
	hold on
	
% 	fill([0 bins 9], [0 data(:,i)' 0], colors(i,:),...
% 		'facealpha',0.4)
	bar(bins,data(:,i),1,'facecolor',colors(i,:),'linewidth',lwidth)
	
	set(gca,'ytick',0:5:30,'xtick',bins,'fontsize',fsize,'ygrid','on'...
		,'linewidth',lwidth, 'fontname','times new roman')
	axis([-0.5 9.5 0 30])
	axis square
	
% 	set up ticks
	if c==2 || c==4
		set(gca,'yticklabel','')
	end
	if c==1 || c==2
		set(gca,'xticklabel','')
	end
	if c==3
		set(gca,'ytick',0:5:25)
	end
	
% 	set up axis labels
	if c==1
		text(-2.7,-0.5,'Number of Participants','rotation',90,...
			'horizontalalignment','center','fontsize',fsize,'fontname','times new roman')
	end
	if c==4
		text(-0.5,-6,'Frequency of Reduced Category Responses',...
			'horizontalalignment','center','fontsize',fsize,'fontname','times new roman')
	end
	c = c+1;
	
% 	set up depiction of classification
	x = xlim([1 2 2 1 1]);
	y = ylim([1 1 2 2 1]);
	fill(x,y,'w','facealpha',1,'linewidth',lwidth)
	text(space(alphas,1),space(alphas,2),'A','fontsize',fsize2+3,'color',[1 0.7 0.7],'horizontalalignment','center')
	text(space(betas,1),space(betas,2),  'B','fontsize',fsize2+4,'color',[0.7 0.7 1],'horizontalalignment','center')
	crits = criticals(:,i);
	text(mean(space(crits,1),1),mean(space(crits,2),1),  char(markers(i)),...
		'fontsize',fsize,'color','k','horizontalalignment','center')
	
end

set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[1200 500 pdfsize])
set(gcf, 'color', 'w');
export_fig critbars.pdf
