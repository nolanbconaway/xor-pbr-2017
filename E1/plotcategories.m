% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
problemnames={'Full XOR','Partial XOR','Twisted XOR','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=12;
pdfsize=[200 200];
lwidth =1;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


testc = [0.66667 -0.66667]

criticals = [5,6,7,12,13,14,19,20,21];

for i=2
	[~,alphas,betas]=getproblem(i);
	
	alphas=coordinates(alphas,:);
	betas=coordinates(betas,:);
	
	[pdist2(alphas,testc,'cityblock'),pdist2(betas,testc,'euclidean')]
	
	figure
	plot([-1 1],[0,0],'k--','linewidth',2)
	hold on
	plot([0,0],[-1 1],'k--','linewidth',2)
	
	text(alphas(:,1),alphas(:,2),'A','fontsize',fsize,...
		'horizontalalignment','center','color',[0.8 0 0])
	text(betas(:,1),betas(:,2),'B','fontsize',fsize,...
		'horizontalalignment','center','color',[0 0 0.8])
	
	
	text(coordinates(criticals,1),coordinates(criticals,2),...
		'x','fontsize',fsize*0.8,'color','k',...
		'horizontalalignment','center','verticalalignment','middle')
	
	axis([-1 1 -1 1]*1.2)
	set(gca,'xtick',[],'ytick',[],'box','on','linewidth',4)

	
	filename=['categories_' char(problemnames(i)) '.pdf'];

	set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
			'papersize',[pdfsize],'position',[500 500 pdfsize])
	set(gcf, 'color', 'w'); set(gca, 'color', 'w');  
	export_fig(filename,'-opengl')
	
	
end