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

profilenames={'Full XOR','Partial XOR','Twisted 1','Twisted 2','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% complete xor
	% complete xor
p1=[1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	0.5 0.5 0.5 0.5 0.5 0.5 0.5 
	0	0	0	0.5 1	1	1
	0	0	0	0.5 1	1	1
	0	0	0	0.5 1	1	1];	

% partial xor
p2=[1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	0.5 0.5 0.5 0.5 0	0	0
	0	0	0	0	0	0	0
	0	0	0	0	0	0	0
	0	0	0	0	0	0	0];

% uncertain
p2=[1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	1	1	1	0.5	0	0	0
	0.5 0.5 0.5 0.5 0.5	0.5	0.5
	0	0	0	0.5	0.5	0.5	0.5
	0	0	0	0.5	0.5	0.5	0.5
	0	0	0	0.5	0.5	0.5	0.5];

%twisted based on D1
p3=[1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1
	1	1	0.5	0	0.5	1	1];

%twisted based on D2
p4=[0	0	0	0	0	0	0
	0	0	0	0	0	0	0
	0.5	0.5	0.5	0.5	0.5	0.5	0.5
	1	1	1	1	1	1	1
	0.5	0.5	0.5	0.5	0.5	0.5	0.5
	0	0	0	0	0	0	0
	0	0	0	0	0	0	0];

% uni for twisted
p5=[1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0
	1	1	0.5	0	0	0	0];



allprofiles=cat(3,p1,p2,p3,p4,p5);




for i=1:length(allprofiles)
	if i==1
		[~,alphas,betas]=getproblem(1);
	elseif i==2
		[~,alphas,betas]=getproblem(2);
	elseif i==3 | i==4
		[~,alphas,betas]=getproblem(3);
	elseif i==5
		[~,alphas,betas]=getproblem(4);
	end
	

% 	data=mean(gradients(:,:,profiles==i),3);
% 	data=round(data);
	data=allprofiles(:,:,i);
	data(isnan(data))=0.5;
	data
% 	set up figure
% 	subplot(1,5,i)
	figure
	plotgradient(data,coordinates,alphas,betas,.0001)
	filename=['Template_ ' char(profilenames(i)) '.png'];
	set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 500 500],...
		'papersize',[500 500])
	print(gcf,'-dpng',filename)
end


