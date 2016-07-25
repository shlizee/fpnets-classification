% The function receives a struct of an odor and neural spiking vectors
% and produces peristinulus time histograms
% by Eli Shlizerman, Jun 2016

function experiment = getpdfs(experiment)

step=experiment.pdfstep;

experiment.pdfs = {};
experiment.FRs = {};

for odorapp = 1:length(experiment.odorvec)
    
    pdf=[];
    
    indtvec = 1:step:length(experiment.tcell{odorapp})-step;
    
    for indt = 1:length(indtvec)
        pdf(:,end+1) = full(sum(experiment.spikeactivity{odorapp}(:,indtvec(indt):indtvec(indt)+step),2));
    end
    
    if isfield(experiment,'smwinper')
        smpdf = smoothTrajectories(pdf,experiment.smwinper);
    end
    
    experiment.pdfs{odorapp} = pdf;
    
    experiment.FRs{odorapp} = experiment.timestampunits*(pdf/experiment.pdfstep);
    
    
    if (~exist('totalpdf','var'))
        totalpdf = pdf;
        if isfield(experiment,'smwinper')
            smtotalpdf = smpdf;
        end
    else
        totalpdf = totalpdf+pdf;
        if isfield(experiment,'smwinper')
            smtotalpdf = smtotalpdf+smpdf;
        end
    end
    
    totalpdf = totalpdf/length(experiment.odorvec);
    
    experiment.totalpdf = totalpdf;
    
    experiment.totalFR = experiment.timestampunits*(totalpdf/experiment.pdfstep);
    
    if isfield(experiment,'smwinper')
        smtotalpdf = smtotalpdf/length(experiment.odorvec);
        experiment.smtotalpdf = smtotalpdf;
        experiment.smtotalFR = experiment.timestampunits*(smtotalpdf/experiment.pdfstep);
    end
    
    % time of experiment - for aceraged quantities
    experiment.tavg = linspace(-experiment.Tbeforeodorapplied/experiment.timestampunits,...
    experiment.Todorapplied/experiment.timestampunits,length(experiment.tcell{odorapp}(indtvec(1:end))));
    
    %if isfield(experiment,'smwinper')
    %    experiment.totalFR = smoothTrajectories(experiment.totalFR,experiment.smwinper);
    %end
    
end

end

% mean convolution
function smtraj = smoothTrajectories(traj,winper)


trajlen = size(traj,2);


windlen = floor(winper*trajlen);
smtraj = traj;

wind = ones(1,windlen)/windlen;
for ind=1:size(traj,1)
    smtraj(ind,:) = conv(traj(ind,:),wind,'same');
end

end