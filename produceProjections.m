% Produce projections onto classification space and 
% compare with reference odor
% Input (optional): visulaization bit, method for class space
% construction, basis of classification space  radius of hypersphere
% by Eli Shlizerman, Jun 2016

function SRatioList = produceProjections(varargin)

    
if length(varargin)>=1
    vis= varargin{1}; % visualize
else
    vis = 1;
end

if length(varargin)>=2
    method= varargin{2}; %method= ETR,OETR,ICA,SVDSEP
else
    method= 'ETR';
end

if length(varargin)>=3
    indep_odors_names= varargin{3}; %basis odors: any combination of 'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'.
else
    indep_odors_names = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'};
end

if length(varargin)>=4
    radius= varargin{4}; %radius
else
    radius = .55;
end

% list of odors to test : S1-S8, B1-B3,E1-E6
test_odors = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger','P3','P5','P9','P2','P4','E2','E3','E3B','ctrl'};

% list of reference odor
ref_odor = {'P3'};

% colors
col = {[1 0 0],[0 1 0], [0 0 0]};

% output lists
TestExperimentsList = {};
ProjCoeffList = {};
SRatioList = [];
SCounterList = [];

% construct a classification space and project the reference odor to it
ref_experiment = runExperimentByName('DaturaESOCombMultiDimSpace',{indep_odors_names{1:end}},ref_odor{1});

% find projection of mean ref trajectory for ON time
ref_proj_coeff = projectOnClassSpace(method,ref_experiment,1,col{1},[5 40],vis); 

% find projection of mean ref trajectory for all recording time
ref_proj_coeff_full = projectOnClassSpace(method,ref_experiment,1,col{1},[],vis); 

% find projections per each trial for ON time
ref_proj_coeff_mult = projectOnClassSpace(method,ref_experiment,0,col{1},[5 40],vis); 

% find principle vectors in the classification space
[ur,sr,vr] = svd(ref_proj_coeff);

%define the first pricnicple vector as center
c_coord = abs(vr(:,1).');


% if testing ICA method choose center as mean vector since not guranteed to
% start at (0,0)
if (isequal(method,'ICA'))
    % for ICA
    c_coord = mean(ref_proj_coeff)*1;
end

% if using the convex hull metric (based on trials)
% if size(ref_proj_coeff,2)>1
% [~,vol] = convhulln(ref_proj_coeff_full);
% %c_coord =centroid(ref_proj_coeff);
% else
% vol = 2*0.55;
% end

% if using a hypershpere metric define radius
r_coord = radius*ones(size(c_coord));


%desired_ratio = 0.3;
desired_ratio = 25;

s_ratio_total = 0;
s_counter_total = 0;

% display how many ref points are in the sphere
disp(['ref points within hyperellipse: ' num2str(sum(hyperellipseMetirc(ref_proj_coeff_full,c_coord,r_coord))) ' out of ' num2str(length(ref_proj_coeff_full))]);
 
% go over test odors, project onto classification space and compute metrics
for ind=1:length(test_odors)
  
% find projections of all trials of test odor on same classification space as reference
TestExperimentsList{ind} =runExperimentByName('DaturaESOCombMultiDimSpace',{indep_odors_names{1:end}},test_odors{ind},ref_experiment);
% projection of all recorded interval
ProjCoeffList{ind} = projectOnClassSpace(method,TestExperimentsList{ind},0,col{1},[],vis);

% project trials 
cur_proj_coeff =  ProjCoeffList{ind};

% total sum of points inside the sphere
s_ratio_total = 0;

% go over trials
for mul_ind = 1:length(cur_proj_coeff)
    
    % binary vector for all points in test trajectory (1: inside ref sphere, 0: outside)
    s_t  = hyperellipseMetirc(cur_proj_coeff{mul_ind},c_coord,r_coord);
    
    % for convex hull check how many points inside
    %s_t = sum(inhull(cur_proj_coeff{mul_ind},ref_proj_coeff,[],0.03))
    
    % sum the number of points inside sphere
    s_ratio = sum(s_t);
    
    disp(['input #' num2str(ind) ' ,sample #' num2str(mul_ind) ': ' num2str(s_ratio)]);
    
    % add to total sum
    s_ratio_total = s_ratio_total+s_ratio;
        
end

% compute average number of points in the sphere over trials 
s_ratio_total = s_ratio_total/length(cur_proj_coeff);
SRatioList(ind) = s_ratio_total;
end


