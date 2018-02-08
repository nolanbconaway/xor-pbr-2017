function tf=gradientCheck(subjectgradient)

% performs a check to make sure the subject was accurate in the test phase
% cat A= 0; B=1;

% turn gradient into a vector
subjectgradient=reshape(rot90(subjectgradient,3),numel(subjectgradient),1);

egs=[1;2;9;10;55;56;63;64];    
num=length(egs)/2; %egs per cat

errorCount=sum(subjectgradient(egs(1:num))~=0) + ...
    sum(subjectgradient(egs(num+1:end))~=1);

tf=errorCount<=1;
clear egs num grad errorCount