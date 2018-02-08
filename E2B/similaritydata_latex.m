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

  
fopts=struct('fontsize',12,'fontname','times new roman');
lwidth=1;
pdfsize=[250 250];
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

betas = unique(betas);
bx = squeeze(nanmean(nanmean(similarity(betas,criticals,2,:),1),2));
ax = squeeze(nanmean(nanmean(similarity(alphas,criticals,2,:),1),2));

[H,P,CI,STATS] = ttest(ax,bx);
disp([mean(ax) mean(bx) P])



figure
hold on
markers = {'s','o'};
colors = [1 0 0; 0 0 1];
plot([1,9] , [1,9] ,'k-','linewidth',lwidth)

hs = [];
for i = 1:2
	if i==1
		idx = extrapolations < 4;
	else idx = extrapolations > 5;
	end
	
	x = ax(idx);
	y = bx(idx);
	m = char(markers(i));
	c = colors(i,:);
	h= scatter(x,y,250,m,...
		'MarkerFaceColor',c,'MarkerEdgeColor',c,...
		'MarkerFaceAlpha',0.4,'MarkerEdgeAlpha',0.8);
	hs = [hs h];
end


axis([0.5 9.5 0.5 9.5])
set(gca,fopts,'linewidth',lwidth,'ytick',1:9,'box','on','xtick',1:9)
axis square
set(gcf, 'position',[500 500 pdfsize],'color','w')
set(gca, 'color','w')

legend(hs,{'Proximity','Extrapolation'},'location','North','box', 'off')
xlabel('Complete - Critical Similarity')
ylabel('Reduced - Critical Similarity')



fname = '/Users/nolan/Desktop/XOR/partial-xor-pbr/figs/e2bsimilarity.tex';
matlab2tikz(fname);
