function [subject]=readfile(file)
subject=struct;



%format data
data=textscan(fopen(file),'%s','delimiter','\n');
fclose('all');data=data{1};


% get data fields
exptime=data(1);
subjectinfo=data(2);
counterbalance = data(3);
data=data(4:end);

% handle time info
exptime=textscan(char(exptime),'%s','delimiter',',');
exptime=exptime{1}; exptime=exptime([1,3]);
exptime=datevec(exptime,'dd mmm yyyy HH:MM:SS PM');
subject.expduration=etime(exptime(2,:),exptime(1,:))/60;

% handle subject info
subjectinfo=textscan(char(subjectinfo),'%s','delimiter',',');
subjectinfo=str2double(subjectinfo{1});
subject.subjectid=subjectinfo(2);
subject.condition=subjectinfo(3);

% handle counterbalance info
counterbalance=textscan(char(counterbalance),'%s','delimiter',',');
counterbalance=str2double(counterbalance{1});
subject.counterbalance = counterbalance(1);

%initialize data structures
subject.traininginfo=[];
subject.trainingaccuracy=[];
subject.generalizeinfo=[];
subject.similarity = NaN(49, 49, 2);
subject.generalization = NaN(49,1);
for i=1:length(data)
    trial=textscan(char(data(i)),'%s','delimiter',',');
    trial=trial{1};
    
    %--------------------------TRAINING
    if strcmp(char(trial(3)),'training')
		egnumber=str2double(trial(6)) + 1;
		correctcat=strcmp(trial(7),'Beta');
		response=strcmp(trial(8),'Beta');
        responsetime = str2double(trial(end));
		accuracy=str2double(trial(9));
		
		subject.traininginfo=cat(1,subject.traininginfo,...
			[egnumber,correctcat,responsetime,response]);
		subject.trainingaccuracy=cat(1,subject.trainingaccuracy,accuracy);
    end
    
    %--------------------------GENERALIZATION
	if strcmp(char(trial(3)),'generalization')

		responsetime = str2double(trial(end));
        egnumber=str2double(trial(5)) + 1;
		response=strcmp(trial(6),'Beta');
		
		subject.generalizeinfo=cat(1,subject.generalizeinfo,...
			[egnumber,responsetime,response]);
		subject.generalization(egnumber) = response;
	end
	
	if strcmp(char(trial(3)),'similarity1') || strcmp(char(trial(3)),'similarity2')
		if strcmp(char(trial(3)),'similarity1')
			phase = 1;
		else phase = 2;
		end
		
		eg1 = str2double(trial(5)) + 1;
		eg2 = str2double(trial(6)) + 1;
		response = str2double(trial(7));
		subject.similarity(eg1,eg2,phase) = response;
		subject.similarity(eg2,eg1,phase) = response;
	end


end

criticals = [5,  6,  7, 12, 13, 14, 19, 20, 21];
subject.extrapolations = sum(subject.generalization(criticals));
subject.testaccuracy = sum(subject.generalization([ 1,9,41,49]) == 0) + ...
	sum(subject.generalization([ 43, 37 ]) == 1);




