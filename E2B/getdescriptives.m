clc;close;clear
addpath([pwd,'/utility/'])
load data.mat
whos


fprintf(['Total\t\tN: ' num2str(numsubjects) '\tTime: ' num2str(mean(expduration),3) '(' num2str(stderror(expduration,1),3) ')' '\n\n'])


for i = 1:6
	INDS = counterbalance==(i-1);
	fprintf(['Condition ' num2str(i) ...
		'\tn: ' num2str(sum(INDS)) ...
		'\tTime: ' num2str(mean(expduration(INDS)),3) ' ('  num2str(stderror(expduration(INDS),1),3) ')'...
		'\n'])
end