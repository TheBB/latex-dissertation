function out = BLF(u, v, x, params)

    if nargin < 4
        params = Settings;
    end

    ux = EvaluateShearlet(u, x, params);
    vx = EvaluateShearlet(v, x, params);
    ud = EvaluateShearletGradient(u, x, params);
    vd = EvaluateShearletGradient(v, x, params);

    p = params;

    out =   p.k(x).^2.*ux.*vx...
          + sum(p.s(x).*ud, 1).*p.k(x).*v...
          + sum(p.s(x).*vd, 1).*p.k(x).*ux...
          + sum(p.s(x).*ud, 1).*sum(p.s(x).*vd, 1);

end
