% Compute modes using OETR approach
% by Eli Shlizerman, Jun 2016

function experiment = getmodes_winnertakeall_optim(experiment)

% matrix L
experiment.modes = [];

% if it is a mixture, obtain modes
if isfield(experiment,'modesodorsnames')
    
    
    for modesind = 1:length(experiment.modesodorsnames)

        experiment1 = experiment;
        
        experiment1.odor = experiment1.modesodorsnames{modesind};
        if isfield(experiment,'combined')
            experiment1 = processdatacombined(experiment1);
        else
            experiment1 = processdata(experiment1);
        end
        
        experiment1 = getpdfs(experiment1);
        experiment.modes(:,end+1) = getoneodormodes(experiment1);
        
        
    end
    
else
        experiment.modes(:,end+1) = getoneodormodes(experiment); 
    
end  

experiment.sigmas = sum(abs(experiment.modes).^2).^(1/2);


% find the maximal element in each row
[v1,maxind] = max(experiment.modes,[],2);

% subindices of the maximal elements to keep
submaxind=sub2ind(size(experiment.modes),[1:size(experiment.modes,1)].',maxind);

% set all elements zero
winnermodes = zeros(size(experiment.modes));

% set only maximal elements nonzero
winnermodes(submaxind) = experiment.modes(submaxind);


% run optimization instead of normalizing 
% matrix O
experiment.winnermodes = winnermodes;

% Weights matrix
W = cvxminoptim(experiment.winnermodes,experiment.modes);

% matrix D
experiment.D = W;



function modes = getoneodormodes(experiment)

% at which value/values to sample
%sampleind =  find(experiment.tavg>0.5,1);

windmin = 0.4;windmax = 0.6;
if isfield(experiment, 'windmin')
windmin = experiment.windmin;
end
if isfield(experiment, 'windmax')
windmax = experiment.windmax;
end

sampleind =  find(experiment.tavg>windmin & experiment.tavg<windmax);


% get the averaged FR modes
modes = mean(experiment.totalFR(:,sampleind),2);