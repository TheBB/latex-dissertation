function out = EvaluateLinCombShearlets(shearlets, x, coeffs, params)
    
    if nargin < 4
        params = Settings;
    end

    out = sum(repmat(coeffs',size(x,2),1) .* EvaluateShearlets(shearlets, x, params), 2)';

end
