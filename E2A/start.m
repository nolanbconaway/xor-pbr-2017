clc;close;clear
addpath([pwd,'/utility/'])
subFiles=getAllFiles([pwd '/subjects/']);
% subFiles=getAllFiles('/Users/nolan/Dropbox/KLAB/PSYCHOPY DATA/STEYVERS');

rottenapples = [];
% -------------------------------------------------------------------------

% initialize storage
subjectid=[];
counterbalance = [];
expduration=[];
traininginfo=[];
trialaccuracy=[];
generalizeinfo=[];
generalization=[];

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
			generalization=cat(3,generalization,data.generalization);
		
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
%  133 134 135 136 137 138 139 140 141 142 143 144
%  121 122 123 124 125 126 127 128 129 130 131 132
%  109 110 111 112 113 114 115 116 117 118 119 120
%   97  98  99 100 101 102 103 104 105 106 107 108
%   85  86  87  88  89  90  91  92  93  94  95  96
%   73  74  75  76  77  78  79  80  81  82  83  84
%   61  62  63  64  65  66  67  68  69  70  71  72
%   49  50  51  52  53  54  55  56  57  58  59  60
%   37  38  39  40  41  42  43  44  45  46  47  48
%   25  26  27  28  29  30  31  32  33  34  35  36
%   13  14  15  16  17  18  19  20  21  22  23  24
%    1   2   3   4   5   6   7   8   9  10  11  12

stimuli = fliplr(allcomb(0:1/11:1,0:1/11:1)) .* 2 - 1;
alphas =    [  6  19  71  84];
betas  =    [ 67  78  67  78];

criticals = [
% 			00    01   10    11
			 1    10   109   118
			 2    11   110   119
			 3    12   111   120
			13    22   121   130
			14    23   122   131
			15    24   123   132
			25    34   133   142
			26    35   134   143
			27    36   135   144
];

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
	'generalizeinfo','generalization',...
	'alphas','betas','inputs','labels','criticals')

getdescriptives
