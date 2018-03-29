function out = BLFSS(u, v, x, params)

    if nargin < 4
        params = Settings;
    end

    out =    sum(params.s(x) .* EvaluateShearletGradient(u, x, params), 1)...
          .* sum(params.s(x) .* EvaluateShearletGradient(v, x, params), 1);

end
