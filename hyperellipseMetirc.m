% function that checks whether points are inside hyperellipse (metric s_t)
% Eli Shlizerman June 2016

function s_t  = hyperellipseMetirc(proj_coeff,c_coord,r_coord)


c_coordMat = repmat(c_coord, [length(proj_coeff) 1]);
r_coordMat = repmat(r_coord, [length(proj_coeff) 1]);

q_t = sum(((proj_coeff - c_coordMat)./r_coordMat).^2,2) -1;

s_t = (q_t <= 0); 




