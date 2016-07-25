% The function receives a struct of an odor and neural spiking times ensambles
% and processes the data
% by Eli Shlizerman, Jun 2016

function experiment=processdatacombined(experiment)


% data includes neurons -- each is a struct
data = load(experiment.datafile);

% prepare neural activity matrices per odor application
experiment = assignSpikingTimes(experiment,data);

%experiment = calcPCAModes(experiment);


% Assigns 1 where spike in a matrix 
function experiment=assignSpikingTimes(experiment,data)
    
    % find neurons' names/number
    neuronsnames = fieldnames(data);
    experiment.totalnumneurons = length(neuronsnames);

    % create spikeactivity cell
    experiment.spikeactivity = cell(experiment.odorapps,1);
    
    for i = 1:experiment.odorapps        
        
        experiment.odorvec(i) = 0;
        
        % window of time odor was applied
        experiment.tcell{i} = [-experiment.Tbeforeodorapplied:experiment.ref:experiment.Todorapplied]/experiment.timestampunits;
        
        % create matrix per odor
        experiment.spikeactivity{i} = ...
            sparse(experiment.totalnumneurons,length(experiment.tcell{i}));
        
        for j = 1:experiment.totalnumneurons
            
            oneindices = assignSpikingTimesPerNeuronPerOdor(experiment,data.(neuronsnames{j}),i);
            experiment.spikeactivity{i}(j,oneindices)= 1;
            
        end
        
        
    end
    



% indices of 1 where there was a time stamp (denoted by oneindices)
function oneindices=assignSpikingTimesPerNeuronPerOdor(experiment,neuronstruct,odorindex)
    
    tstamps = neuronstruct.tstamps;
    
    % get odor and application index
    odorvec=neuronstruct.(experiment.odor);
    odortime = odorvec(odorindex);
    
    %find window of time odor was applied
    tdiscrt = odortime+experiment.tcell{odorindex};
    
    
    % find first index  of time stamps for that application of odor
    firstind = find(tstamps >=...
        tdiscrt(1),1,'first');
    
    % find last index of time stamps for that application of odor
    lastind = find(tstamps <=...
        tdiscrt(end),1,'last');
    
    % transform all indices that have a spike between first and last to
    % indices of matrix
    
    
    if (~isempty(lastind) && ~isempty(firstind) && lastind>firstind)
        
        oneindices = round(tstamps(firstind:lastind)...
            *experiment.timestampunits/experiment.ref);
        
        % translate indices to beginning
        oneindices = oneindices - round(tdiscrt(1)...
            *experiment.timestampunits/experiment.ref)+1;
        
    else
        oneindices=[];
    end
    
% calcs PCA modes for each odor app
function experiment=calcPCAModes(experiment)

% cell array of matrices where each matrix represents activity of one odor
% application
experiment.pcamodes = cell(length(experiment.odorvec),1);
experiment.energy = cell(length(experiment.odorvec),1);

for i=1:length(experiment.odorvec)    
   
   [~,S,V] = svds(experiment.spikeactivity{i}.',20);
   experiment.energy{i} = S.^2/sum(diag(S).^2);
   experiment.pcamodes{i} = V;
   
end

% Returns maximum of a cell array of vectors
function maxvec=maxcell(cellarray)

maxvec=zeros(1,length(cellarray));

for i = 1:length(maxvec)
   maxvec(i) = max(cellarray{i});    
end