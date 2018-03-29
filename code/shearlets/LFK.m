function out = LFK(v, x, params)

    if nargin < 3
        params = Settings;
    end

    out = EvaluateShearlet(v, x, params) .* params.f(x) .* params.k(x);

end
