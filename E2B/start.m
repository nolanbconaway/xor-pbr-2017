clc;close;clear
addpath([pwd,'/utility/'])
subFiles=getAllFiles([pwd '/subjects/']);
% subFiles=getAllFiles('/Users/nolan/Dropbox/PSYCHOPY DATA/partialcbs');

rottenapples = [
	5076 % incomplete
];
% -------------------------------------------------------------------------

% initialize storage
subjectid=[];
counterbalance = [];
expduration=[];
traininginfo=[];
trialaccuracy=[];
generalizeinfo=[];
generalization=[];
extrapolations = [];
testaccuracy = [];
similarity = [];

fprintf('\nCompiling data files...')
for f=1:length(subFiles);
    file=char(subFiles(f));
	if ~strcmp(file(end-8:end),'.DS_Store')
		
		%get subject information from filename
		info=textscan(file,'%s','delimiter','-');info=info{1};
		
		%get id, removing the file extension
		subid=str2double(char(info(4)));

		if ~any(rottenapples==subid)

	% 	read data from subject file
			data = readfile(file);
			
	%           log info
			subjectid=cat(1,subjectid,subid);
			counterbalance=cat(1,counterbalance,data.counterbalance);
			expduration = cat(1,expduration,data.expduration);
			traininginfo=cat(3,traininginfo,data.traininginfo);
			trialaccuracy=cat(2,trialaccuracy,data.trainingaccuracy);
			generalizeinfo=cat(3,generalizeinfo,data.generalizeinfo);
			generalization=cat(2,generalization,data.generalization);
			extrapolations = cat(1,extrapolations,data.extrapolations);
			testaccuracy = cat(1,testaccuracy,data.testaccuracy);
			similarity = cat(4,similarity,data.similarity);
		else disp(subid)
		end
	end
   
    clear info subcondition subid data profile file
end

% store info about the experiment in general
blocksize = 8;
numblocks = 12;
numsubjects = length(subjectid);

% set up input space
%     43    44    45    46    47    48    49
%     36    37    38    39    40    41    42
%     29    30    31    32    33    34    35
%     22    23    24    25    26    27    28
%     15    16    17    18    19    20    21
%      8     9    10    11    12    13    14
%      1     2     3     4     5     6     7

stimuli = fliplr(allcomb(linspace(-1, 1, 7),linspace(-1, 1, 7)));
alphas =    [ 1,  9, 41, 49];
betas  =    [43, 37, 43, 37];
criticals = [5,  6,  7, 12, 13, 14, 19, 20, 21];

inputs = [alphas,betas]';
labels = [ones(length(alphas),1);
		ones(length(betas),1)*2];

% 		convert training to blocks
blockaccuracy = blockrows(trialaccuracy,blocksize);

save('data.mat',...
	'stimuli','blocksize','numblocks',...
	'subjectid','numsubjects',...
	'counterbalance','expduration',...
	'traininginfo','trialaccuracy','blockaccuracy',...
	'generalizeinfo','generalization','extrapolations','testaccuracy',...
	'similarity',...
	'alphas','betas','inputs','labels','criticals')

getdescriptives
