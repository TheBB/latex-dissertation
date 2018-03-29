function out = EvaluateShearlet(s, x, params)

    if nargin < 3
        params = Settings;
    end

    xorig = x;
    [x, computefor] = PreparePoints(s, x, params);

    wv_xpts = params.wvfunctions(s.Level+1,s.F+1).xpts;
    wv_fvals = params.wvfunctions(s.Level+1,s.F+1).fvals;
    gm = @(x) inter(wv_xpts, wv_fvals, x);

    sc_xpts = params.scfunctions(s.Level+1,s.F+1).xpts;
    sc_fvals = params.scfunctions(s.Level+1,s.F+1).fvals;
    th = @(x) inter(sc_xpts, sc_fvals, x);

    out = zeros(1,size(x,2));
    out(computefor) = th(x(2,computefor)).*gm(x(1,computefor));
    out = 2^(-3*s.Level/2)*out;

    if isfield(params, 'glob')
        out = out .* params.glob(xorig(:,computefor));
    end

    function out = inter(xs, ys, x)
        out = interp1([min([xs,x])-1, xs, max([xs,x])+1], [0, ys, 0], x);
    end

end
