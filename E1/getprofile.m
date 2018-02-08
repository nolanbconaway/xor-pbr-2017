function [absprofile,condprofile,errors]=getprofile(generalization,condition)


if condition ==1
    
    % complete xor
    p1=[1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        0.5 0.5 0.5 0.5 0.5 0.5 0.5 
        0	0	0	0.5 1	1	1
        0	0	0	0.5 1	1	1
        0	0	0	0.5 1	1	1];	

    % add nonlearner templates
    nls=cat(3,zeros(7),ones(7)*0.5,ones(7));
    allprofiles=cat(3,p1,nls);

    errors=zeros(1,size(allprofiles,3));
    for i = 1:size(allprofiles,3)
        current=allprofiles(:,:,i);
        errors(i)=mean(mean((generalization-current).^2));
    end

    [~,absprofile]=min(errors);

    % convert to psychologically meaningful profiles
    if absprofile==1
        condprofile=1;
    elseif absprofile>1
        condprofile=2;		
    end
    
elseif condition == 2 
    % complete xor
    p1=[1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        0.5 0.5 0.5 0.5 0.5 0.5 0.5 
        0	0	0	0.5 1	1	1
        0	0	0	0.5 1	1	1
        0	0	0	0.5 1	1	1];	

    % partial xor
    p2=[1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        1	1	1	0.5	0	0	0
        0.5 0.5 0.5 0.5 0	0	0
        0	0	0	0	0	0	0
        0	0	0	0	0	0	0
        0	0	0	0	0	0	0];

    nums=[33:35,40:42,47:49]; %to create halfway profile
    untrainedquad=mean(generalization(nums));

    allprofiles=cat(3,p1,p2);


    % add nonlearner templates
    nls=cat(3,zeros(7),ones(7)*0.5,ones(7));
    allprofiles=cat(3,allprofiles,nls);

    errors=zeros(1,size(allprofiles,3));
    for i = 1:size(allprofiles,3)
        current=allprofiles(:,:,i);
        errors(i)=mean(mean((generalization-current).^2));
    end

    [~,absprofile]=min(errors);

    % convert to psychologically meaningful profiles

    if absprofile==1
        condprofile=1;
    elseif absprofile==2
        condprofile=3;		
    elseif absprofile>2
        condprofile=4;
    end
    if condprofile~=4 & (untrainedquad>=4/9 & untrainedquad<=5/9);
        condprofile=2;
	end
	absprofile
	condprofile
end
