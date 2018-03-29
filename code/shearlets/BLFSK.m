function out = BLFSK(u, v, x, params)

    if nargin < 4
        params = Settings;
    end

    out =    sum(params.s(x) .* EvaluateShearletGradient(u, x, params), 1)...
          .* params.k(x) .* EvaluateShearlet(v, x, params);

end
