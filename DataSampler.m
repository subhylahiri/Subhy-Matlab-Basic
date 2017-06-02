classdef DataSampler < handle
    %DATASAMPLER object that samples from data histogram
    %   obj=DATASAMPLER(data,...): construct object
    %   data,...: same as HISTCOUNTS, except 'Normalization' fixed to 'cdf'
    %   samples = obj.Sample(...): sample data
    %   ...: same as RAND
    
    properties
        binedges = [];
        cdf = [];
        mean = [];
    end
    
    methods
        function obj = FixCDF(obj, epsilon)
            if ~exist('epsilon','var')
                epsilon = 1e-7;
            end
            
            deltas = [false, diff(obj.cdf) == 0];
            while any(deltas)
                obj.cdf = obj.cdf + epsilon * cumsum(deltas);
                deltas = [false, diff(obj.cdf) == 0];
            end
        end%function Sample

        function samp = Sample(obj, varargin)
            samp = rand(varargin{:});
            samp = interp1(obj.cdf, obj.binedges, samp);
        end%function Sample

        function samp = SampleMean(obj, varargin)
            samp = obj.mean * ones(varargin{:});
        end%function Sample
    end
    
    methods%Constructor
        function obj = DataSampler(varargin)
        %obj=DATASAMPLER(data,...) object that samples from data histogram
        %   data,...: same as HISTCOUNTS, except 'Normalization' fixed to 'cdf'
            [obj.cdf, obj.binedges] = histcounts(varargin{:}, 'Normalization', 'cdf');
            
            obj.cdf = [0, obj.cdf];
            obj = obj.FixCDF();
            
            if obj.cdf(end) < 1
                obj.cdf(end+1) = 1;
                obj.binedges(end+1) = max(varargin{1});
            end
            
            if obj.cdf(1) > 0
                obj.cdf = [0, obj.cdf];
                obj.binedges = [min(varargin{1}), obj.binedges];
            end
            
            obj.mean = mean(varargin{1});
        end%function Constructor
    end%methods Constructor
    
end

