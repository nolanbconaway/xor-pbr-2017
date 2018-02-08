% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;clear;close all;format shortg
addpath([pwd,'/utility/'])
load('twistedxor2data.mat')
whos

%   Name                    Size                Bytes  Class     Attributes
% 
%   condition             120x1                   960  double              
%   generalizeinfo         49x3x120            141120  double              
%   gradients               7x7x120             47040  double              
%   profiles              120x1                   960  double              
%   subjectnumber         120x1                   960  double              
%   trainingaccuracy       96x120               92160  double              
%   traininginfo           96x3x120            276480  double                  

problemnames={'Full XOR','Partial XOR','Twisted XOR','Partial Twisted'};
coordinates=load('physcoords_7x7.txt');
fsize=20;
pdfsize=[500 500];
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
nsubs=length(subjectnumber);
diffscore=zeros(nsubs,1);
for i=1:length(subjectnumber)
	current=generalizeinfo(:,:,i);
	c1=current(current(:,3)==0,2);
	c2=current(current(:,3)==01,2);
	diffscore(i)=mean(c1) - mean(c2);
	
	ttest2(c1,c2);
	
	
	
end


grp1=diffscore(profiles==1 & condition==2)
grp2=diffscore(profiles==2 & condition==2)
xor=diffscore(profiles==1 & condition==1)

[~,p]=ttest2(grp1,grp2)
	[mean(grp1) mean(grp2), mean(xor)]
	
	
[~,p]=ttest(xor,0)
% 	analyze learning data (factoral for each subject for each block00)0