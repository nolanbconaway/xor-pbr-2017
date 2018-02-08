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

problemnames={'full','partial'};
coordinates=load('physcoords_7x7.txt');
fsize=22;
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

coordinates = round((coordinates+1)/2 *6);

data = [];

% subjectid, condition, phase, trial, d1, d2, response, correct, accuracy
for i = 1:length(subjectnumber)
	cond = problemnames(condition(i));
	countr = counterbalance(i);
	tn = 1;
	phase = 'training';
	d = traininginfo(:,:,i);
	for j = 1:size(traininginfo(:,:,i),1)
		stim = coordinates(traininginfo(j,1,i),:);
		response = traininginfo(j,3,i);
		correct = traininginfo(j,4,i);
		rt = traininginfo(j,2,i);
		acc = response==correct;
		data = cat(1,data,...
			[i, cond, countr, tn, phase, j, stim(1), stim(2),response, correct, acc, rt]...
		);
		tn=tn+1;
	end
	
	phase = 'generalization';
	for j = 1:size(generalizeinfo(:,:,i),1)
		stim = coordinates(generalizeinfo(j,1,i),:);
		rt = generalizeinfo(j,2,i);
		response = generalizeinfo(j,3,i);
		data = cat(1,data,...
			[i, cond, countr, tn, phase, j, stim(1), stim(2),response, NaN, NaN, rt]...
		);
		tn=tn+1;
	end
end


delete e1.csv
fid = fopen('e1.csv','wt');
fprintf(fid,'subjectid,condition,counterbalance,responsenumber,phase,trialnumber,F1,F2,response,correctresponse,accuracy,rt\n');
for i =1:size(data,1)
	fprintf(fid,'%i,%s,%i,%i,%s,%i,%i,%i,%i,%i,%i,%f\n',data{i,:});
end
fclose(fid);
