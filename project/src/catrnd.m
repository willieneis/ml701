function ind = catrnd(p,n)

% get n samples from a categorical distribution with parameter p (a vector)

if nargin==1, n=1; end
k = length(p);
p = reshape(p,k,1);
ind = sum(repmat(rand(1,n),k,1) > repmat(cumsum(p)/sum(p),1,n),1)+1;
