function out = BLFKK(u, v, x, params)

    if nargin < 4
        params = Settings;
    end

    out = params.k(x).^2 .* EvaluateShearlet(u, x, params)...
                         .* EvaluateShearlet(v, x, params);

end
