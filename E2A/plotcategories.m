clear;close;clc

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



addpath ef
addpath utility
load data





a = stimuli(alphas,:);

betas = unique(betas);
b = stimuli(betas,:);

figure
hold on
fsize=12;
lwidth=1;
pdfsize=[200 200];
fopts = struct('fontsize',12,'fontname','courier');
	


% exemplars

text(a(:,1),a(:,2),'A','color',[0.7 0 0],fopts,'fontsize',16,...
	'horizontalalignment','center')
text(b(:,1),b(:,2),'B','color',[0 0 0.7],fopts,'fontsize',16,...
	'horizontalalignment','center')


markers = {'W','X','Y','Z'};

for i= 1:4
	c = stimuli(criticals(:,i),:);
	text(c(:,1),c(:,2),char(markers(i)),'color',[0 0 0],fopts,....
		'horizontalalignment','center')
	
end

axis([-1 1 -1 1]*1.2)

box on
axis square
set(gca,'linewidth',lwidth,'fontsize',fsize,'ytick',[],'xtick',[],'box','on')


set(gcf, 'PaperUnits','points', 'PaperPosition',[0 0 pdfsize],...
		'papersize',[pdfsize],'position',[500 500 pdfsize])
set(gcf, 'color', 'n'); set(gca, 'color', 'n');  
export_fig categories.pdf -transparent



