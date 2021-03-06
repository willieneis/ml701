function finalSamples = smcSimple(data)

% Sampling with the simple version of smc.
%
% Inputs:
% (1) data is a 1xT cell-array; each element is an nxd matrix of observations from a single point in time 
%
% ----------------------------------------------
% Procedure:
% 1) do static inference on t=1 
% 2) for each t=2:T
%   a) for each particle k=1:K
%       i) sample a graph given previous
%       ii) compute weight for sample
%   b) resample from (pair down) set of particles
%
% for simple version:
%   sample new state: P(G|G_-1), P(K|G)
%   compute weight: P(X|K)
% ---------------------------------------------

d = size(data{1},2); % number of nodes / length of adjacency and precision matirices

P = 10000; % number of particles
b = 3; % G-Wishart prior param b
D = eye(d); % G-Wishart prior param D

result = bdmcmc_static(data{1},P,b,D); 
normLambdas = result{4}/sum(result{4}); newInd = catrnd(normLambdas,length(normLambdas));
%ACell{1} = result{2}(newInd); KCell{1} = result{1}(newInd); % resample based on bdmcmc waiting times 
ACell{1} = result{2}; KCell{1} = result{1}; weightCell{1} = result{4};
for t=2:length(data)
    newAs = {}; newKs = {};
    for p=1:P
        newAs{p} = SampleForwardGraph(ACell{t-1}{p}); % sample p_th graph given p_th graph at previous time
        newKs{p} = SamplePrecisionMatrix(newAs{p},b,D); % sample p_th precision matrix given p_th graph
    end
    weights = getWeights_smcSimple(newKs,data{t}); % compute weights
    resampleInd = resampleParticles(weights); % resample particles
    %ACell{t} = newAs(resampleInd); KCell{t} = newKs(resampleInd);
    ACell{t} = newAs; KCell{t} = newKs; weightCell{t} = weights;
    fprintf('finished time-step t=%d\n',t);
end
finalSamples = {ACell,KCell,weightCell};
