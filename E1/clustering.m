% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
addpath([pwd,'/utility/effectsize/'])
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

problemnames={'Full XOR','Partial XOR'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
k = 3;
figure
pnum=1;
blockaccuracy =  blockrows(trainingaccuracy,8);
numblocks =  96/8;
for c = 1:2
    gradientdata = gradients(:,:,condition==c);
    generalizationdata = gradientroll(gradientdata,'unroll');
    trainingdata = blockaccuracy(:,condition==c);
    
	toanalyze = [trainingdata;generalizationdata];
    [group, C, SUMD, D] = kmeans(toanalyze',k,'Replicates',100);
    
    t = zeros(numblocks,k);
    for i=1:k
        t(:,i) = mean(trainingdata(:,group==i),2);
    end
    subplot(2,k+1,pnum)
    plot(t,'linewidth',2)
    axis([0.5 numblocks+0.5 0 1])
	axis square
    set(gca,'ygrid','on','ytick',0:0.2:1,'box','on','linewidth',2,'fontsize',fsize)
    legend(num2str((1:k)'), 'location','southeast')
    title(problemnames(c))
    pnum=pnum+1;
    
    for i=1:k
        [~, alphas, betas] = getproblem(c);
        g = mean(gradientdata(:,:,group==i),3);
        
        subplot(2,k+1,pnum)
        plotgradient(g,coordinates,alphas,betas,fsize)
        title(['Group ' num2str(i) ],'fontsize',fsize )
        pnum=pnum+1;
    end
end

pdfsize=[800,600];
set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize])

print(gcf,'-dpng','clusters.png')
% there is a correlation of > 0.9 between the k means goups and grouping 
% based on average accuracy with a criteria of 0.59728 (~10.8/18) or greater


