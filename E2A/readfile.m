function [subject]=readfile(file)
subject=struct;

criticals = [
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
subject.generalization=NaN(size(criticals));

for i=1:length(data)
    trial=textscan(char(data(i)),'%s','delimiter',',');
    trial=trial{1};
    
    %--------------------------TRAINING
    if strcmp(char(trial(3)),'training')
		egnumber=str2double(trial(7));
		correctcat=strcmp(trial(10),'Beta');
		response=strcmp(trial(11),'Beta');
        responsetime = str2double(trial(end-1));
		accuracy=str2double(trial(end));
		
		subject.traininginfo=cat(1,subject.traininginfo,...
			[egnumber,correctcat,responsetime,response]);
		subject.trainingaccuracy=cat(1,subject.trainingaccuracy,accuracy);
		clear egnumber correctcat response accuracy
    end
    
    %--------------------------GENERALIZATION
	if strcmp(char(trial(3)),'generalization')

		responsetime = str2double(trial(end));
        egnumber=str2double(trial(7));
		response=strcmp(trial(10),'Beta');
		
		subject.generalizeinfo=cat(1,subject.generalizeinfo,...
			[egnumber,responsetime,response]);
		subject.generalization(criticals==egnumber) = response;
		clear egnumber response
	end

end



