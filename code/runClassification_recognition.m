% Run classification and then recognition of all trials w.r.t an projection (B1 here)
% produces Figure 5 C,D in Blaszka,Sanders,Riffell,Shlizerman, 2016
% by Eli Shlizerman, Jun 2016

function runClassification_recognition()
% run classification on dimensions 1 -> 8

% operate with all independent stimulit space (8 dimensions)
indep_odors_names = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'};
figure; set(gcf,'Color',[1 1 1]);

% pick a hypersphere radiuses (for robustness)
ball_rad = [0.65];

% precision
P_List = zeros(4,length(ball_rad));

% recall
R_List = zeros(4,length(ball_rad));
W = zeros(4,length(ball_rad));

SRL = {};
RefCL = {};

% go over different ball sizes 
for br_ind = 1: length(ball_rad)
    
    % go over dimensions (this example  dim=8) and compute recogniton
    % with SVD Sep
    for dim_ind = 8
        
        [refcount,SCounterList]= produceProjections_Rec(0,'SVDSep',{indep_odors_names{1:dim_ind}},ball_rad(br_ind));
        SRL{1} = SCounterList;
        RefCL{1} = refcount;
        
    end
    
    % go over dimensions (this example  dim=8) and compute recogniton
    % with ICA    
    for dim_ind = 8
        
        [refcount,SCounterList]= produceProjections_Rec(0,'ICA',{indep_odors_names{1:dim_ind}},ball_rad(br_ind));
        SRL{2} = SCounterList;
        RefCL{2} = refcount;

    end
    
    % go over dimensions (this example  dim=8) and compute recogniton
    % with ETR   
    for dim_ind = 8
                
      [refcount,SCounterList]= produceProjections_Rec(0,'ETR',{indep_odors_names{1:dim_ind}},ball_rad(br_ind));
      SRL{3} = SCounterList;
      RefCL{3} = refcount;
             
    end
    
    % go over dimensions (this example  dim=8) and compute recogniton
    % with OETR         
    for dim_ind = 8
 
         [refcount,SCounterList] = produceProjections_Rec(0,'OETR',{indep_odors_names{1:dim_ind}},ball_rad(br_ind));
         SRL{4} = SCounterList;
         RefCL{4} = refcount;
     
        
    end

end;

showBarPlot(SRL,RefCL);


% show distribution of score and output recall and precision rates
function showBarPlot(SRL,RefCL)

PP3 =[];
PP3Class = [];

for ind =1:length(SRL)
    
    B = (SRL{ind} > 0.7*RefCL{ind});
    
    % precision with respect to P3 (B1)
    PP3(ind) = sum(sum(B(9,:)))/sum(sum(B));        
    
    % precision with respect to P3's (B) Class
    PP3Class(ind) = sum(sum(B(9:11,:)))/sum(sum(B));
    
end

P = [PP3Class.' PP3.'].';

figure;
bar(P); hold on;








