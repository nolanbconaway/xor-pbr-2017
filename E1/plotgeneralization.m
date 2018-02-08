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

problemnames={'Full XOR','Partial XOR','Twisted XOR','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for i=1:2
	%get example coordinates and get data
	[~,alphas,betas]=getproblem(i);
	data=mean(gradients(:,:,condition==i),3);
% 	data=round(data);
	data
% 	set up figure
	subplot(1,4,i)
	plotgradient(data,coordinates,alphas,betas,30)
	title(problemnames(i),'fontsize',fsize)
end

set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 1000 500],...
		'papersize',[1000 500])
print(gcf,'-dpdf','gradientsbycondition.pdf')