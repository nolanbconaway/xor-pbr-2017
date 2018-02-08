% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clc;close;clear
addpath([pwd,'/utility/'])
load('data.mat')
whos
%   Name                 Size               Bytes  Class   
%   alphas               1x4                    32  double              
%   betas                1x4                    32  double              
%   blockaccuracy       12x31                 2976  double              
%   blocksize            1x1                     8  double              
%   counterbalance      31x1                   248  double              
%   criticals            1x9                    72  double              
%   expduration         31x1                   248  double              
%   extrapolations      31x1                   248  double              
%   generalization      49x31                12152  double              
%   generalizeinfo      15x3x31              11160  double              
%   inputs               8x1                    64  double              
%   labels               8x1                    64  double              
%   numblocks            1x1                     8  double              
%   numsubjects          1x1                     8  double              
%   similarity           4-D               1190896  double              
%   stimuli             49x2                   784  double              
%   subjectid           31x1                   248  double              
%   testaccuracy        31x1                   248  double              
%   traininginfo        96x4x31              95232  double              
%   trialaccuracy       96x31        
  
lwidth=1;
pdfsize=[250 250];
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

stimuli = round((stimuli+1)/2 * 6);

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


% delete e2b.csv
fid = fopen('e2b.csv','wt');
fprintf(fid,'subjectid,counterbalance,responsenumber,phase,trialnumber,F1,F2,response,correctresponse,accuracy,rt\n');
for i =1:size(data,1)
	fprintf(fid,'%i,%i,%i,%s,%i,%i,%i,%i,%i,%i,%f\n',data{i,:});
end
fclose(fid);