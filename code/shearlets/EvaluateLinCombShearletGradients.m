function out = EvaluateLinCombShearletGradients(shearlets, x, coeffs, params)

    if nargin < 4
        params = Settings;
    end

    [cp1, cp2] = EvaluateShearletGradients(shearlets, x, params);
    out = [sum(repmat(coeffs',size(x,2),1).*cp1, 2), sum(repmat(coeffs',size(x,2),1).*cp2, 2)]';

end
