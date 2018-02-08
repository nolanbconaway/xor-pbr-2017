% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                      Size                Bytes  Class     Attributes
%   blockaccuracy            20x120               19200  double              
%   blocksize                 1x1                     8  double              
%   condition               120x1                   960  double              
%   conditiontitles           1x3                   382  cell                
%   counterbalance          120x1                   960  double              
%   experimentduration      120x1                   960  double              
%   generalizeinfo           49x3x120            141120  double              
%   gradients                 7x7x120             47040  double              
%   numblocks                 1x1                     8  double              
%   numsubjects               1x1                     8  double              
%   stimuli                  49x2                   784  double              
%   subjectid               120x1                   960  double              
%   traininginfo            120x4x120            460800  double              
%   trialaccuracy           120x120              115200  double              

  
fsize=12;
lwidth=1;
pdfsize=[400 250];
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


extrapolator = squeeze(sum(generalization(:,2,:),1)>5);
proximity = squeeze(sum(generalization(:,2,:),1)<4);


% remove the one person not in either group
keep = extrapolator==1 | proximity==1;
responses = squeeze(sum(generalization(:,:,keep),1))';
extrapolator = extrapolator(keep);
proximity = proximity(keep);

ms = zeros(4,2);
sds = ms;
for i = 1:4
	
	ms(i,1) = mean(responses(proximity,i),1);
	sds(i,1) = stderror(responses(proximity,i),1);
	
	ms(i,2) = mean(responses(extrapolator,i),1);
	sds(i,2) = stderror(responses(extrapolator,i),1);
	
	
	g1 = responses(extrapolator,i);
	g2 = responses(proximity,i);
	[H,P,CI,STATS] = ttest2(g1,g2)
	
	
end


fopts = struct('fontsize',12,'fontname','times new roman');
x = [1/3 2/3]+0.5;
xinc = 1;
barcolors = [0,0,0;1 1 1];

figure
hold on
for  i =1:4
	hs = [];
	for  j =1:2
		h = bar(x(j),ms(i,j),1/3,'FaceColor', barcolors(j,:),'linewidth',lwidth/2);
		hs = [hs h];
		
		errorbar(x(j),ms(i,j),sds(i,j),'k-')
	end
	x = x+xinc;
end

axis([0.5 4.5 0 9])
set(gca,fopts,'ytick',0:9,'xtick',1:4,'xticklabel',{'W','X','Y','Z'},'ygrid','on')

l = legend(hs,{'Proximity','Extrapolator'},...
	'orientation','vertical','location','bestoutside','box','off','units','pix');


ylabel('Reduced Category Responses')
box on
axis square
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[1200 500 pdfsize],'color','n')
set(gcf, 'color', 'w');
export_fig extrapolator_split.pdf
