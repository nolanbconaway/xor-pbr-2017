function plotgradient(subjectgradient,alphas,betas,coords,fsize)

% % turn gradient into a vector
% vectorgradient=reshape(rot90(subjectgradient,3),...
% 	numel(subjectgradient),1);
% vectorgradient=repmat(vectorgradient,1,3);

% plot gradient
imagesc(subjectgradient,[0 1])
colormap gray
axis image
set(gca,'xtick',[],'ytick',[]','linewidth',2.5,'box','on')

% rescale coords
coords=reshape(coords,numel(coords),1);
coords=globalscale(coords,[1,length(subjectgradient)]);
coords=reshape(coords,numel(coords)/2,2);
coords(:,2)=(length(subjectgradient)+1)-coords(:,2);

% plot coords
text(coords(alphas,1),coords(alphas,2),'A','color',[1 1 0],...
	'horizontalalignment','center','fontsize',fsize)
text(coords(betas,1),coords(betas,2),'B','color',[1 0 0],...
	'horizontalalignment','center','fontsize',fsize)

set(gca,'ydir','reverse')