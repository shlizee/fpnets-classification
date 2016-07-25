% List of parameters and data sets
% to be loaded by GetExperiment function.
% by Eli Shlizerman, Jun 2016

function models = ExperimentsList()

models = { ...
struct(...                 
           'name',           'DaturaESOCombMultiDimSpace',...
           'totalnumneurons', 106,... 
           'datafile',       '18stim_benchmark.mat', ...
           'odor',           'Bea', ... % stim to project onto odor space  
           'odorapps',        5,...   % number of trials        
           'timestampunits',  1000, ...%ms
           'Tbeforeodorapplied', 0,... %ms - odor+100ms time of activity
           'Todorapplied',    1000,... %ms - odor+100ms time of activity
           'frequency',       25,...   %KHz
           ...% stims based that compose the odor space which be added dynamically
           ...%'modesodorsnames', {{'Bea','Bol','Lin','Car','Ner','Far','Myr','Ger'}}, ...
           'combined',        1,...    %
           'winnertakeall',       2,...  %           
           'thresh',              4,...  %           
           'windmin',         0.1,...  %
           'windmax',         0.6,...  %
           'pdfstep',         15,...   %
           'ref',             1 ...    %ms     
)
         };