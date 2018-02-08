clc;close;clear
addpath([pwd,'/utility/'])
subFiles=getAllFiles([pwd '/subjects/']);
rottenapples=[2288 2254 2261];
% -------------------------------------------------------------------------

% initialize storage
subjectnumber=[];
condition=[];
counterbalance=[];
traininginfo=[];
trainingaccuracy=[];
generalizeinfo=[];
gradients=[];
absoluteprofiles=[];
conditionprofiles=[];


for f=1:length(subFiles);
	file=char(subFiles(f));
	if ~strcmp(file(end-8:end),'.DS_Store')
		
		%get subject information from filename
		info=textscan(file,'%s','delimiter','-');
		info=info{1};
		

		%get condition
		subcondition=str2double(info(5));

		%get id, removing the file extension
		subid=char(info(6));
		subid=textscan(subid,'%s','delimiter','.');
		subid=subid{1};subid=str2double(subid(1));

		counterbalancecondition=mod(subid,8) +1;

		if ~any(rottenapples==subid) %check for rotten apple
				
		% 	read data from subject file
			data = readfile(file);
			
		%   log info
			subjectnumber=cat(1,subjectnumber,subid);
			condition=cat(1,condition,subcondition);
			counterbalance=cat(1,counterbalance,counterbalancecondition);
			traininginfo=cat(3,traininginfo,data.traininginfo);
			trainingaccuracy=cat(2,trainingaccuracy,data.trainingaccuracy);
			generalizeinfo=cat(3,generalizeinfo,data.generalizeinfo);
			gradients=cat(3,gradients,data.generalizegradient);

			
		else disp([subid,subcondition]) 
		end

		clear info subid data profile file
	end
end


save('twistedxor2data.mat',...
	'subjectnumber','condition','counterbalance',...
	'traininginfo','trainingaccuracy',...
	'generalizeinfo','gradients')

getdescriptives
