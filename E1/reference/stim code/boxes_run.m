fprintf('\nCREATING FULL IMAGES...\n')

% - - - - - - - - - - - - - - - - - - - - - -
% ITERATE ACROSS STIMULI
stimvals=[];
stimnumber=1;
for figsize=1:numpositions
%	determine box position value
	sizevalue=sizestart+((figsize-1)*sizeincrement);
		
	for figshade=1:numpositions

% 		determine shading value
		shadevalue=shadestart+((figshade-1)*shadeincrement);
		
% 		-----------------------------------------------------------------
%		GENERATE THE FIGURE
		fig=figure;
		axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],...
			'handlevisibility','off','linewidth',lwidth, 'visible','off')
		axis off
		if stimnumber ~= numpositions^2;
            set(gcf,'visible','off') % this prevents the figure display
		end
		
		x=[middle-sizevalue,middle+sizevalue,middle+sizevalue,middle-sizevalue];
		y=[middle-sizevalue,middle-sizevalue,middle+sizevalue,middle+sizevalue];

		fill(x,y,repmat(shadevalue,1,3))
		
	
		
% 		------------------------------------------------------------------
%		AXIS SETTING
		axis(generalaxis); axis off;
		set(gcf, 'PaperUnits','points', 'PaperPosition',...
			[0,0,savesize],'papersize',savesize)
		
% 		save figure
		if stimnumber<10;
			filename=['e0',num2str(stimnumber),'_',...
				num2str(sizevalue*1000,4),'-',...
				num2str(shadevalue*1000,4),'.jpg'];
		else
            filename=['e',num2str(stimnumber),'_',...
                num2str(sizevalue*1000,4),'-',...
				num2str(shadevalue*1000,4),'.jpg'];
		end
		print(fig,'-djpeg',[folder '/' filename])
		
% 		LOG VALUES
		stimvals=cat(1,stimvals,[sizevalue,shadevalue]);
		stimnumber=stimnumber+1;
		
		clear shadevalue points filename
	end
	fprintf('working...\n')
	clear sizevalue
end

dlmwrite('stimulusvalues.txt',stimvals)