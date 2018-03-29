function out = LFS(v, x, params)

    if nargin < 3
        params = Settings;
    end

    out =    sum(params.s(x) .* EvaluateShearletGradient(v, x, params), 1)...
          .* params.f(x);

end
