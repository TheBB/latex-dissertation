function out = EvaluateShearlets(shearlets, x, params)

    if nargin < 3
        params = Settings;
    end

    out = zeros(size(x,2),length(shearlets));
    for i=1:length(shearlets)
        out(:,i) = EvaluateShearlet(GetShearlet(shearlets(i)), x, params)';
    end

end
