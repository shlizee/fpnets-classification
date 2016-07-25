% Frobenius norm per column
% by Eli Shlizerman, Jun 2016

function normA = normcolumnVec(A)
normA = sqrt(sum(A.^2));          % this is a vector
