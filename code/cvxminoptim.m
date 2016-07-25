% Use cvx package to solve optimization for OETR
% cvx has to be initialized before running it
% by Eli Shlizerman, Jun 2016

function W = cvxminoptim(O,L,experiment)

% constraint weights not to exceed diagMax (trivial solution)
% the larger diagMax the farther the basis from ETR
diagMax=0.001;
%diagMax=0.1;

cvx_begin
n = size(O,1);
m = size(O,2);
I =eye(m);
variable W(n,n);

minimize( norm( (diag(diag(W))*O).'*L - I,'fro'));

subject to
    diag(W) >= 0;
    diag(W) <= diagMax;
cvx_end

