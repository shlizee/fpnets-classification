% Per model and odor computes the bais for classification space
% by Eli Shlizerman, Jun 2016


function experiment = runExperimentByName(varargin)
%%%%            %%%%
fit=0;
if (~isempty(varargin))    
    experimentname = varargin{1}; %name of list
end

if length(varargin) >1
    indep_odors_names = varargin{2};     % dynamic indep odors for basis ('modesodorsnames' field)
else
    indep_odors_names={};
end

if length(varargin) >2
    test_odor_name = varargin{3};   % dynamic test odor name ( 'odor' field)
else
    test_odor_name={};
end

if length(varargin) >3
ref_experiment= varargin{4};    % dynamic ref odor name ( 'odor' field)
else
   ref_experiment = {};
end


if length(varargin) >4     % how to show results in sub plot or not 
    h = 'sub';    
    fit = varargin{5};
else
    h={};
end

%pulls data from ExperimentsList.m
experiment = GetExperiment(ExperimentsList(), experimentname);

% replace experiment struct with refexperiment if was provided
if (~isempty(ref_experiment))
    experiment = ref_experiment;
end
    
% replace modesodorsnames with the indep odornames list in argument
if (~isempty(indep_odors_names))
    experiment.modesodorsnames = indep_odors_names;
end

% set odor field
if (~isempty(test_odor_name))
    experiment.odor = test_odor_name;
end

experiment = processdatacombined(experiment);

%prepare pdfs 
experiment = getpdfs(experiment);

% compute basis vectors (modes)
if (isempty(ref_experiment))

    if isfield(experiment, 'winnertakeall')
        
        % OETR modes
        if (experiment.winnertakeall == 2)
            experiment = getmodes_winnertakeall_optim(experiment);
        else
        % ETR modes    
            experiment = getmodes_winnertakeall(experiment);
        end
    % SVD Sep modes    
    elseif (length(experiment.modesodorsnames)==3)
        experiment = getmodes_libthree(experiment);
    %else
    %    experiment = getmodes_lib(experiment);
    end
    
end
