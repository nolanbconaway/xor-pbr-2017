% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                      Size                Bytes  Class     Attributes
%   alphas                1x4                  32  double              
%   betas                 1x4                  32  double              
%   blockaccuracy        12x30               2880  double              
%   blocksize             1x1                   8  double              
%   counterbalance       30x1                 240  double              
%   criticals             9x4                 288  double              
%   expduration          30x1                 240  double              
%   generalization        9x4x30             8640  double              
%   generalizeinfo       42x3x30            30240  double              
%   inputs                8x1                  64  double              
%   labels                8x1                  64  double              
%   numblocks             1x1                   8  double              
%   numsubjects           1x1                   8  double              
%   stimuli             144x2                2304  double              
%   subjectid            30x1                 240  double              
%   traininginfo         96x4x30            92160  double              
%   trialaccuracy        96x30              23040  double                      


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

stimuli = round((stimuli+1)/2 * 11);
data = [];
% subjectid, condition, phase, trial, d1, d2, response, correct, accuracy
for i = 1:length(subjectid)
	tn = 1;
	countr = counterbalance(i);
	phase = 'training';
	d = traininginfo(:,:,i);
	for j = 1:size(traininginfo(:,:,i),1)
		stim = stimuli(traininginfo(j,1,i),:);
		rt = traininginfo(j,3,i);
		response = traininginfo(j,4,i);
		correct = traininginfo(j,2,i);
		acc = double(response==correct);
		data = cat(1,data,...
			{i, countr, tn, phase, j, stim(1), stim(2), response, correct, acc, rt}...
		);
		tn=tn+1;
	end
	
	phase = 'generalization';
	for j = 1:size(generalizeinfo(:,:,i),1)
		stim = stimuli(generalizeinfo(j,1,i),:);
		rt = generalizeinfo(j,2,i);
		response = generalizeinfo(j,3,i);
		data = cat(1,data,...
			{i, countr, tn, phase, j, stim(1), stim(2), response, NaN, NaN, rt}...
		);
		tn=tn+1;
	end
end


delete e2a.csv
fid = fopen('e2a.csv','wt');
fprintf(fid,'subjectid,counterbalance,responsenumber,phase,trialnumber,F1,F2,response,correctresponse,accuracy,rt\n');
for i =1:size(data,1)
	fprintf(fid,'%i,%i,%i,%s,%i,%i,%i,%i,%i,%i,%f\n',data{i,:});
end
fclose(fid);