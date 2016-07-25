% Produce projections onto classification space and
% use them for recognition of reference odor (see also produceProjections)
% Input (optional): visulaization bit, method for class space
% construction, basis of classification space  radius of hypersphere
% Output: counter of ref projection and test projections
% by Eli Shlizerman, Jun 2016

function [refcount,SCounterList] = produceProjections_Rec(varargin)


if length(varargin)>=1
    vis= varargin{1}; % visualize
else
    vis = 1;
end

if length(varargin)>=2
    method= varargin{2}; %method= ETR,OETR
else
    method= 'ETR';
end

if length(varargin)>=3
    indep_odors_names= varargin{3}; %method= ETR,OETR
else
    indep_odors_names = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'};
end

if length(varargin)>=4
    radius= varargin{4}; 
else
    radius = .55;
end

% S1-S8, B1-B3,E1-E6
test_odors = {'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger','P3','P5','P9','P2','P4','E2','E3','E3B','ctrl'};

ref_odor = {'P3'};

col = {[1 0 0],[0 1 0], [0 0 0]};

TestExperimentsList = {};
ProjCoeffList = {};
SRatioList = [];
SCounterList = zeros(length(test_odors),5);

ref_experiment = runExperimentByName('DaturaESOCombMultiDimSpace',{indep_odors_names{1:end}},ref_odor{1});

% find projection of averaged trajectory
ref_proj_coeff = projectOnClassSpace(method,ref_experiment,1,col{1},[5 40],vis);

ref_proj_coeff_full = projectOnClassSpace(method,ref_experiment,1,col{1},[],vis);

% find projection of trials trajectories
ref_proj_coeff_mult = projectOnClassSpace(method,ref_experiment,0,col{1},[5 40],vis);

[ur,sr,vr] = svd(ref_proj_coeff);
c_coord = abs(vr(:,1).');

% for ICA
if (isequal(method,'ICA'))
    c_coord = mean(ref_proj_coeff)*1;
    
end

% set radius of hypersphere
r_coord = radius*ones(size(c_coord));

refcount = sum(hyperellipseMetirc(ref_proj_coeff_full,c_coord,r_coord));

% go over trials
for ind=1:length(test_odors)
    
    TestExperimentsList{ind} =runExperimentByName('DaturaESOCombMultiDimSpace',{indep_odors_names{1:end}},test_odors{ind},ref_experiment);
    
    ProjCoeffList{ind} = projectOnClassSpace(method,TestExperimentsList{ind},0,col{1},[],vis);
    
    % project trials
    cur_proj_coeff =  ProjCoeffList{ind};
    
    for mul_ind = 1:length(cur_proj_coeff)
        % binary vector for all points in test trajectory (1: inside ref sphere, 0: outside)
        s_t  = hyperellipseMetirc(cur_proj_coeff{mul_ind},c_coord,r_coord);

        % sum the number of points inside sphere
        s_ratio = sum(s_t);
        
        disp(['input #' num2str(ind) ' ,sample #' num2str(mul_ind) ': ' num2str(s_ratio)]);
        
        % add to list
        SCounterList(ind,mul_ind) = s_ratio;
        
    end
     
end


