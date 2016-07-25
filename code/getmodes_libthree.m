function experiment = getmodes_libthree(experiment)


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


if isfield(experiment, 'remmin')
    experiment.modes(sum(experiment.modes,2)<experiment.remmin,:)=0;
end
 
    
if isfield(experiment, 'winnertakeall')
return;
end

% if isfield(experiment,'combined')
%     
%     % normalize the modes
% 
%     experiment.modes = extractmodescombined(experiment);
%         experiment.sigmas = sum(abs(experiment.modes).^2).^(1/2);
% 
%     for nind = 1:size(experiment.modes,2)
%         experiment.modes(:,nind) = ...
%             (1/norm(experiment.modes(:,nind)))*experiment.modes(:,nind);
%         
%     end
% 
% else
    


% remove small entries

experiment.remmodes=experiment.modes;


experiment.sigmas = sum(abs(experiment.modes).^2).^(1/2);


diffmin=20;
if isfield(experiment, 'diffmin')
diffmin=experiment.diffmin;
end


m1 = experiment.modes(:,1)/experiment.sigmas(1);
m2 = experiment.modes(:,2)/experiment.sigmas(2);
m3 = experiment.modes(:,3)/experiment.sigmas(3);


[jjj,indom1] = sort(m1-m2-m3,'descend');
[jjj,indom2] = sort(m2-m1-m3,'descend');
[jjj,indom3] = sort(m3-m1-m2,'descend');

%inddiffexit= find(diffpat>diffmin);
%indsingle = find((experiment.modes(:,1)>0 | experiment.modes(:,2)>0) & experiment.modes(:,1).*experiment.modes(:,2)==0);
%indsel = union(inddiff,indsingle);

numselmodes1 = 10;
numselmodes2 = 10;
numselmodes3 = 10;

if isfield(experiment, 'numselmodes')
   numselmodes1=experiment.numselmodes;
   numselmodes2=experiment.numselmodes;
   numselmodes3=experiment.numselmodes;
elseif isfield(experiment, 'numselmodes1')
       numselmodes1=experiment.numselmodes1;
   numselmodes2=experiment.numselmodes2;
   numselmodes3=experiment.numselmodes3;
end



indsel = [indom1(1:numselmodes1).' indom2(1:numselmodes2).' indom3([1:numselmodes3]).'];
allneurind = 1:size(experiment.modes,1);

indnonsel = setdiff(allneurind,indsel);

%experiment.modes(diffpat<25,:) =0;

experiment.modes(indnonsel,:) =0;
experiment.sigmas(1) = norm(experiment.modes(:,1));
experiment.sigmas(2) = norm(experiment.modes(:,2));
experiment.sigmas(3) = norm(experiment.modes(:,3));


[jjj,indmax]=max(experiment.modes,[],2);

%tem = experiment.modes.';
em = zeros(size(experiment.modes));

for frind = 1:size(experiment.modes,1)
   
    em(frind,indmax(frind)) = experiment.modes(frind,indmax(frind));
    
end
experiment.modes = em;




remmin=15;
if isfield(experiment, 'remmin')
remmin=experiment.remmin;
end


% remainder modes
indrem = find((experiment.remmodes(indnonsel,1)+experiment.remmodes(indnonsel,2))+experiment.remmodes(indnonsel,3) < remmin);
indrem = indnonsel(indrem);
indnonrem = setdiff(allneurind,indrem);
experiment.remmodes(indnonrem,:) =0;


%experiment.modes(experiment.modes< 4)=0;




experiment.modes(:,1) =  experiment.modes(:,1)/norm(experiment.modes(:,1));
experiment.modes(:,2) =  experiment.modes(:,2)/norm(experiment.modes(:,2));
experiment.modes(:,3) =  experiment.modes(:,3)/norm(experiment.modes(:,3));

%experiment = warpmodes(experiment);


experiment.remmodes(:,1) =  experiment.remmodes(:,1)/norm(experiment.remmodes(:,1));
experiment.remmodes(:,2) =  experiment.remmodes(:,2)/norm(experiment.remmodes(:,2));
experiment.remmodes(:,3) =  experiment.remmodes(:,3)/norm(experiment.remmodes(:,3));

experiment.indsel = indsel;
experiment.indnonsel = indnonsel;


%%% commented since producing warped modes

% for indmode = 1:size(experiment.modes,2)
%     if (size(experiment.modes,2)==2)
%         offset=experiment1.totalFR(:,10).'*experiment.modes(:,indmode);
%         experiment.modes(:,indmode)= experiment.modes(:,indmode)-offset*experiment1.totalFR(:,10)/norm(experiment1.totalFR(:,10))^2;
%     else
%         
%         offset=experiment.totalFR(:,10).'*experiment.modes(:,indmode);
%         experiment.modes(:,indmode)= experiment.modes(:,indmode)-offset*experiment.totalFR(:,10)/norm(experiment.totalFR(:,10))^2;
%     end
% end
% 
% experiment.modes(experiment.modes<0) =0;


%offset1=experiment.totalFR(:,1).'*nmode1/norm(experiment.modes(:,1))^2
%offset2=experiment.totalFR(:,1).'*nmode2/norm(experiment.modes(:,2))^2

%%%experiment.modes  = orthmodes(experiment.modes);


% revert modes if needed



%end




%[experiment.sigmas,experiment.modes]=orthmodes(experiment.modes);



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


function experiment=warpmodes(experiment)

%% produce orthogonal (warped) modes

%%% find nonzero entries
indi = find(experiment.modes(:,1) >0 | experiment.modes(:,2)>0);


%%% within nonzero entries find maximal 
[Y,indj]=max(experiment.modes(indi,:),[],2);

experiment.warpmodes =experiment.modes;

%%% extract mode 1 max
mode1ind = find(indj==1);

experiment.warpmodes(indi(mode1ind),2)=0;


%%% extract mode 2 max
mode2ind = find(indj==2);

experiment.warpmodes(indi(mode2ind),1)=0;



experiment.warpmodes(:,1) =  experiment.warpmodes(:,1)/norm(experiment.warpmodes(:,1));
experiment.warpmodes(:,2) =  experiment.warpmodes(:,2)/norm(experiment.warpmodes(:,2));

%%% for debug
%figure;barh(experiment.modes(indi,:))

figure;
h=barh(experiment.warpmodes(indi,:),2.5);
axis([0 0.7 0 length(indi)+0.5]);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gca,'YTick',[]);
set(gca,'XTick',[0 0.5 0.7]);


%ind1 = find(experiment.warpmodes(indi,1)>0);
%ind2 = find(experiment.warpmodes(indi,2)>0);

%mode1 =sort(experiment.warpmodes(indi(ind1),1),1,'descend');
%mode2 =sort(experiment.warpmodes(indi(ind2),2),1,'descend');

%figure;barh([mode1;mode2],1);



experiment.modes = experiment.warpmodes;



function omodes = extractmodescombined(experiment)

[indicesvec1large,~] = find(experiment.modes(:,1)>10 & experiment.modes(:,2)< 1);
[indicesvec2large,~] = find(experiment.modes(:,2)>10 & experiment.modes(:,1)< 1);

indicesveclarge = [indicesvec1large;indicesvec2large];

omodes = 0*experiment.modes;

omodes(indicesveclarge,:)=experiment.modes(indicesveclarge,:);


function omodes = orthmodes(modes)

omodes = orth(modes);

% omode1 = omodes(:,1);
% omode2 = omodes(:,2);
% 
% mode1=modes(:,1);
% mode2=modes(:,2);
% proj12 = mode1.'*mode2/(mode1.'*mode1);
% 
% omode1 = mode1;
% omode2 = mode2-proj12*mode1;
% 
% omode1 = omode1/norm(omode1);
% omode2 = omode2/norm(omode2);



% for ind =1:floor(length(omode1)/2)
% 
% %G{ind} = eye(size(omodes,1));
% anglesvecinit(ind) = -130*2*pi/360;
% 
% end
% 
% options = optimset('Display','iter','TolFun',10^-15,'TolX',10^-10,'MaxFunEvals',30000,'MaxIter',30000);
% 
% [fittedanglesvec,fval] = fminsearch(@(anglesvec) ...
%     runorthogonalization(anglesvec,mode1,mode2,omode1,omode2),...
%               anglesvecinit,options);
% 
% 
% totalG = eye(length(mode1));
% for ind =1:floor(length(mode1)/2)
% totalG(2*ind-1:2*ind,2*ind-1:2*ind) = [cos(fittedanglesvec(ind)) -sin(fittedanglesvec(ind));...
% sin(fittedanglesvec(ind)) cos(fittedanglesvec(ind))];
% end
% 
% omodes = [totalG*omode1 totalG*omode2];
% sigmas = [(omodes(:,1).'*mode1) (omodes(:,2).'*mode2)];

if (size(omodes,2)==2) 
R = [cos(-130*2*pi/360) -sin(-130*2*pi/360);sin(-130*2*pi/360) cos(-130*2*pi/360)];
else
R1 = [cos(-100*2*pi/360) -sin(-100*2*pi/360) 0;sin(-100*2*pi/360) cos(-100*2*pi/360) 0; 0 0 1];
%R2 = [1 0 0;0 cos(45*2*pi/360) -sin(45*2*pi/360);0 sin(45*2*pi/360) cos(45*2*pi/360)];

%R = R1*R2;
omodes = (R1*omodes.').';
%omodes = (R2*omodes.').';

%[U,S,V] = svd(omodes);
%R = V;
R = eye(3);
end

omodes = (R*omodes.').';
 

function meas = runorthogonalization(anglesvec,mode1,mode2,omode1,omode2)

totalG = eye(length(mode1));
for ind =1:floor(length(mode1)/2)

totalG(2*ind-1:2*ind,2*ind-1:2*ind) = [cos(anglesvec(ind)) -sin(anglesvec(ind));...
                         sin(anglesvec(ind)) cos(anglesvec(ind))];
end

proj11 = (totalG*omode1).'*mode1;
proj12 = (totalG*omode1).'*mode2;
proj21 = (totalG*omode2).'*mode1;
proj22 = (totalG*omode2).'*mode2;

%meas = abs(proj11-1)+abs(proj22-1)+abs(proj12)+abs(proj21);
meas = abs(proj12)+abs(proj21);