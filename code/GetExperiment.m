% Load particular data set from the list
% by Eli Shlizerman, Jun 2016

function m = GetExperiment(experiments, name)

for i=1:length(experiments),
  m = experiments{i};

  % If you get an error on this line, the name you are searching for
  % is not present in the list.
  if strcmp(m.name, name),
    break;
  end
end