function [ probs ] = RandProb( varargin )
%probs=RANDPROB(numstates, numdists) random probability distributions
%   probs = numdists X numstates matrix. Each row is one prob dist
%   numstates = number of states each distribution is over
%   numdists = number of distributions to generate. default=1


persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='RandProb';
    p.StructExpand=true;
    p.KeepUnmatched=false;
    p.addRequired('numstates',@(x) validateattributes(x,{'numeric'},{'scalar','integer'},'RandProb','numstates',1));
    p.addOptional('numdists',1,@(x) validateattributes(x,{'numeric'},{'scalar','integer'},'RandProb','numstates',1));
%     p.addParameter('Normalise',true,@(x) validateattributes(x,{'logical'},{'scalar'}));
end
p.parse(varargin{:});
r=p.Results;


probs=rand(r.numdists,r.numstates);
probs=diag(1./sum(probs,2))*probs;

end

