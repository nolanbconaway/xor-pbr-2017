function [subject]=readfile(file)
subject=struct;

%fomrat data
data=textscan(fopen(file),'%s','delimiter','\n');
fclose('all');data=data{1};data=data(2:end);

%initialize data structures
subject.traininginfo=[];
subject.trainingaccuracy=[];

subject.generalizeinfo=[];
subject.generalizegradient=zeros(7,7);

for i=1:length(data)
    trial=textscan(char(data(i)),'%s','delimiter',',');
    trial=trial{1};
    
    %--------------------------TRAINING
    if strcmp(char(trial(3)),'training')
		
		egnumber=str2double(trial(7));
		correctcat=strcmp(trial(10),'Beta');
		response=strcmp(trial(11),'Beta');
		accuracy=str2double(trial(end));
		rt=str2double(trial(end-1));
		
		subject.traininginfo=cat(1,subject.traininginfo,...
			[egnumber,rt,correctcat,response]);
		subject.trainingaccuracy=cat(1,subject.trainingaccuracy,accuracy);
		clear egnumber correctcat response accuracy
    end
    
    %--------------------------GENERALIZATION
	if strcmp(char(trial(3)),'generalization')
        egnumber=str2double(trial(7));
		reactiontime=str2double(trial(12));
		response=strcmp(trial(11),'Beta');
		
		subject.generalizeinfo=cat(1,subject.generalizeinfo,...
			[egnumber,reactiontime,response]);
		subject.generalizegradient(egnumber)=response;
		clear egnumber response
	end

end

subject.generalizegradient=rot90(subject.generalizegradient);

% % % % % % DATA NOTES 
% traininginfo=[egnumber,rt,correctcat,response]
% trainingaccuracy=accuracy vector;
% generalizeinfo=[egnumber,response];
% generalizegradient=gradient in line with stim representation;
% singlefeatureinfo=[feature,value,response]
% singlefeatureaccuracy= values for accuracy on each dimension



