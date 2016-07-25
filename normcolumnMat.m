% Frobenius matrix norm
% by Eli Shlizerman, Jun 2016

function normA = normcolumnMat(A)

normA = sqrt(sum(A.^2));               % this is a vector
%normA = repmat(normA, [length(A) 1]);  % this makes it a matrix
                                       % of the same size as A
