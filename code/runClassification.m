% Run classification with  different methods and produce comparison
% produces Figure figure 5 B in Blaszka,Sanders,Riffell,Shlizerman, 2016
% by Eli Shlizerman, Jun 2016

function runClassification()
% run classification on dimensions 1 -> 8

indep_odors_names = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'};

figure; 

set(gcf,'Color',[1 1 1],'Position',[23  123  1349  668]);

P_List = zeros(4,length(indep_odors_names));
R_List = zeros(4,length(indep_odors_names));
W = zeros(4,length(indep_odors_names));

for dim_ind = length(indep_odors_names):-1:1

%for dim_ind = 7

SRatioList= produceProjections(0,'SVDSep',{indep_odors_names{1:dim_ind}},0.65);

SRL = SRatioList/max(SRatioList);

 [wrong_num,prec_num,recall_num]=showBarPlot(SRL,4,length(indep_odors_names),dim_ind);

P_List(1,dim_ind) = prec_num;
R_List(1,dim_ind) = recall_num;
W(1,dim_ind) = wrong_num;

end

 annotation('textbox', [0 0.9 1 0.1], ...
    'String', 'SVDSep', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')

for dim_ind = length(indep_odors_names):-1:1

%for dim_ind = 7

SRatioList= produceProjections(0,'ICA',{indep_odors_names{1:dim_ind}},0.65);

SRL = SRatioList/max(SRatioList);

 [wrong_num,prec_num,recall_num]=showBarPlot(SRL,4,length(indep_odors_names),length(indep_odors_names)+dim_ind);

P_List(2,dim_ind) = prec_num;
R_List(2,dim_ind) = recall_num;
W(2,dim_ind) = wrong_num;

end

annotation('textbox', [0 0.65 1 0.1], ...
    'String', 'ICA', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center')


for dim_ind = length(indep_odors_names):-1:1
%for dim_ind = 7
        
SRatioList= produceProjections(0,'ETR',{indep_odors_names{1:dim_ind}},0.65);

SRL = SRatioList/max(SRatioList);
 [wrong_num,prec_num,recall_num]=showBarPlot(SRL,4,length(indep_odors_names),2*length(indep_odors_names)+dim_ind);

P_List(3,dim_ind) = prec_num;
R_List(3,dim_ind) = recall_num;
W(3,dim_ind) = wrong_num;

end

annotation('textbox', [0 0.43 1 0.1],'String', 'ETR','EdgeColor', 'none', 'HorizontalAlignment', 'center')

for dim_ind = length(indep_odors_names):-1:1
  
    
SRatioList = produceProjections(0,'OETR',{indep_odors_names{1:dim_ind}},0.65);

%vol

max(SRatioList)
SRL = SRatioList/max(SRatioList);
 [wrong_num,prec_num,recall_num]=showBarPlot(SRL,4,length(indep_odors_names),3*length(indep_odors_names)+dim_ind);

P_List(4,dim_ind) = prec_num;
R_List(4,dim_ind) = recall_num;
W(4,dim_ind) = wrong_num;

end

annotation('textbox', [0 0.22 1 0.1],'String', 'OETR','EdgeColor', 'none', 'HorizontalAlignment', 'center')


% show distribution of score and output recall and precision rates 
function [wrong_num,prec_num,recall_num]=showBarPlot(SRL,rownum,colnum,sp_ind)

mm = mean(SRL);
th = (1 + mm)*0.5 - 0.02;
%th=0.7;

cor_ind =ones(size(SRL)); cor_ind(9:11) =0;
ind = (SRL>=th); 

o_ind = abs(cor_ind-ind);

SRL_Cor = zeros(size(SRL));SRL_Cor(logical(o_ind))=SRL(logical(o_ind));
SRL_Wro = zeros(size(SRL));SRL_Wro(~logical(o_ind))=SRL(~logical(o_ind));

%figure;
subplot(rownum,colnum,sp_ind);

bar(SRL_Wro,'FaceColor',[1 0 0]); hold on;
bar(SRL_Cor,'FaceColor',[0 1 0]);hold on;
line([0 18],[th th]) 

prec_num=sum(ind(9:11))/sum(ind);
recall_num = sum(ind(9:11))/3;
wrong_num = sum(~logical(o_ind));

title(['p=' num2str(prec_num) '; r=' num2str(recall_num) ';']);

axis([0.5 17.5 0 1]);
axis off;







