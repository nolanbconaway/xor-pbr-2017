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
fsize=20;
ncolumns=6;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


for conditionnum=2;
	num=sum(condition==conditionnum);
	[~,alphas,betas]=getproblem(conditionnum);
	condsubjectnumbers=subjectnumber(condition==conditionnum);
	condgradients=gradients(:,:,condition==conditionnum);
	nrows=ceil(num/ncolumns);

	figure

	for i=1:num
		subplot(nrows,ncolumns,i)
		data=condgradients(:,:,i);
		plotgradient(data,coordinates,alphas,betas,20)
% 		title(num2str(condsubjectnumbers(i)))
	end


	pdfsize=[200*ncolumns,200*(num/(ncolumns+1))];
	filename=['individual_' char(problemnames(conditionnum)) '.pdf'];
	set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
			'papersize',[pdfsize],'position',[500 500 pdfsize])
	set(gcf, 'color', 'w'); set(gca, 'color', 'w');  
	export_fig(filename,'-opengl')
end