% Produce projections onto classification space and 
% compare with reference odor
% Input (optional): visulaization bit, method for class space
% construction, basis of classification space  radius of hypersphere
% by Eli Shlizerman, Jun 2016

function proj_coeff = projectOnClassSpace(projtype,experiment,avg,varargin)

if ~isempty(varargin)
    
    if length(varargin)>=1
        col= varargin{1};
    else
        col = rand(3,1);
    end
    
    if length(varargin)>=2 && ~isempty(varargin{2})
        interval= varargin{2};
    else
        interval(1) = 1;
        interval(2) = size(experiment.totalFR,2);
    end
    
    if length(varargin)>=3 && ~isempty(varargin{3})
        vis= varargin{3};
    else
        vis=1;
    end
    
end


% extract matrix L -- SVDSep modes
L = experiment.modes;

% extract matrix O, -- ETR modes
O = experiment.winnermodes;

% extract matrix D -- OETR weights
D = experiment.D;

% use appropriate basis for each method
if (isequal(projtype,'ICA') )
    
    % load previously saved ICA basis
    dims = size(L,2);
    load(['ICAModes' num2str(dims) '.mat']);
    P =s';
    nV = normcolumnVec(L'*P);
    
    if (avg==1)
        proj_coeff = experiment.totalFR(:,interval(1):interval(2)).'*P; %
        normMat = repmat(nV, [length(proj_coeff) 1]);
        
        proj_coeff = proj_coeff./normMat;
        
    else
        
        for frind = 1:length(experiment.FRs)
            FRmat = experiment.FRs{frind};
            proj_coeff{frind} = FRmat(:,interval(1):interval(2)).'*P; %
                        
            normMat = repmat(nV, [length(proj_coeff{frind}) 1]);
            proj_coeff{frind}  = proj_coeff{frind} ./normMat;
            
            mN = max(sqrt(sum(proj_coeff{frind}.^2,2)));
            
            proj_coeff{frind} = proj_coeff{frind}./mN;
            
            % debug:
            %         hold on;
            %         plot3(proj_coeff{frind}(:,1),proj_coeff{frind}(:,2),proj_coeff{frind}(:,3),'Color',col);
            %         axis tight;
            %         view(143,20);
            
        end
    end
elseif (isequal(projtype,'SVDSep') )
    
    P = L;
    nV = normcolumnVec(L'*O);
    
    if (avg==1)
        proj_coeff = experiment.totalFR(:,interval(1):interval(2)).'*P; %
        normMat = repmat(nV, [length(proj_coeff) 1]);
        
        proj_coeff = proj_coeff./normMat;
        
            
        mN = max(sqrt(sum(proj_coeff.^2,2)));            
        proj_coeff = proj_coeff./mN;

            
    else
        
        for frind = 1:length(experiment.FRs)
            FRmat = experiment.FRs{frind};
            proj_coeff{frind} = FRmat(:,interval(1):interval(2)).'*P; %
            
            
            normMat = repmat(nV, [length(proj_coeff{frind}) 1]);
            proj_coeff{frind}  = proj_coeff{frind} ./normMat;
            
            mN = max(sqrt(sum(proj_coeff{frind}.^2,2)));
            
            proj_coeff{frind} = proj_coeff{frind}./mN;
            
            % debug:
            %         hold on;
            %         plot3(proj_coeff{frind}(:,1),proj_coeff{frind}(:,2),proj_coeff{frind}(:,3),'Color',col);
            %     axis tight;
            %     view(143,20);
            
        end
    end
elseif (isequal(projtype,'ETR') )
    
    % projection matrix
    %P = O./normcolumnMat(L'*O);
    P=O;
    nV = normcolumnVec(L'*O);
    
    
    if (avg==1)
        proj_coeff = experiment.totalFR(:,interval(1):interval(2)).'*P; %
        normMat = repmat(nV, [length(proj_coeff) 1]);
        
        proj_coeff = proj_coeff./normMat;
        
    else
        
        for frind = 1:length(experiment.FRs)
            FRmat = experiment.FRs{frind};
            proj_coeff{frind} = FRmat(:,interval(1):interval(2)).'*P; %
                        
            normMat = repmat(nV, [length(proj_coeff{frind}) 1]);
            proj_coeff{frind}  = proj_coeff{frind} ./normMat;
            
            mN = max(sqrt(sum(proj_coeff{frind}.^2,2)));
            
            proj_coeff{frind} = proj_coeff{frind}./mN;
            
            % debug:
            %         hold on;
            %         plot3(proj_coeff{frind}(:,1),proj_coeff{frind}(:,2),proj_coeff{frind}(:,3),'Color',col);
            %     axis tight;
            %     view(143,20);
            
        end
    end
    
elseif (isequal(projtype,'OETR'))
    
    P = D*O;    
    nV = normcolumnVec(L'*D*O);    
    
    if (avg==1) 
       proj_coeff = experiment.totalFR(:,interval(1):interval(2)).'*P; %
        normMat = repmat(nV, [length(proj_coeff) 1]);
        
        proj_coeff = proj_coeff./normMat;
        
    else
        
        for frind = 1:length(experiment.FRs)
            FRmat = experiment.FRs{frind};
           
            proj_coeff{frind} = FRmat(:,interval(1):interval(2)).'*P; %
                        
            normMat = repmat(nV, [length(proj_coeff{frind}) 1]);
            proj_coeff{frind}  = proj_coeff{frind} ./normMat;
            
            mN = max(sqrt(sum(proj_coeff{frind}.^2,2)));
            
            proj_coeff{frind} = proj_coeff{frind}./mN;
            
            % debug:
            %         hold on;
            %         plot3(proj_coeff{frind}(:,1),proj_coeff{frind}(:,2),proj_coeff{frind}(:,3),'Color',col);
            %     axis tight;
            %     view(143,20);
            
        end
    end
    
    
end

if (vis==1)
    hold on;
    plot3(proj_coeff(:,1),proj_coeff(:,2),proj_coeff(:,3),'Color',col);
    axis tight;
    view(143,20); 
end
