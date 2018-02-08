% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
load('twistedxor2data.mat')
whos
%   Name                     Size                Bytes  Class     Attributes
% 
%   absoluteprofiles       120x1                   960  double              
%   condition              120x1                   960  double              
%   conditionprofiles      120x1                   960  double              
%   counterbalance         120x1                   960  double              
%   generalizeinfo          49x3x120            141120  double              
%   gradients                7x7x120             47040  double              
%   subjectnumber          120x1                   960  double              
%   trainingaccuracy        96x120               92160  double              
%   traininginfo            96x3x120            276480  double              

problemnames={'Full XOR','Partial XOR','Twisted XOR','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

numsubs=zeros(1,2);
for i=unique(condition)'
	numsubs(i)=sum(condition==i);
end
numsubs

fprintf('\nCONDITION BY COUNTERBALANCE LISTING\n')
balancestats=zeros(length(unique(condition)),length(unique(counterbalance)));
for c =unique(condition)'
	for b=unique(counterbalance)'
		balancestats(c,b)=sum(condition==c & counterbalance==b);
	end
end
disp(balancestats)
