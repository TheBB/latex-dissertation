function out = EvaluateShearletGradient(s, x, params)

    if nargin < 3
        params = Settings;
    end

    xorig = x;
    [x, computefor] = PreparePoints(s, x, params);

    wv_xpts = params.wvfunctions(s.Level+1,s.F+1).xpts;
    wv_fvals = params.wvfunctions(s.Level+1,s.F+1).fvals;
    gm = @(x) inter(wv_xpts, wv_fvals, x);
    gmd = @(x) interd(wv_xpts, wv_fvals, x);

    sc_xpts = params.scfunctions(s.Level+1,s.F+1).xpts;
    sc_fvals = params.scfunctions(s.Level+1,s.F+1).fvals;
    th = @(x) inter(sc_xpts, sc_fvals, x);
    thd = @(x) interd(sc_xpts, sc_fvals, x);

    [P, c] = GetTransform(s, 0, params);
    shld = zeros(2,size(x,2));
    shld(:,computefor) = [th(x(2,computefor)).*gmd(x(1,computefor));...
                          thd(x(2,computefor)).*gm(x(1,computefor))];
    shld = 2^(-3*s.Level/2)*P'*shld;

    if ~isfield(params, 'glob') || ~isfield(params, 'globd')
        out = shld;
    else
        shl = zeros(1,size(x,2));
        shl(computefor) = th(x(2,computefor)).*gm(x(1,computefor)); 
        shl = 2^(-3*s.Level/2)*shl;
        out =   repmat(shl,2,1).*params.globd(xorig)...
              + repmat(params.glob(xorig),2,1).*shld;
    end;
    
    function out = inter(xs, ys, x)
        out = interp1([min([xs,x])-1, xs, max([xs,x])+1], [0, ys, 0], x);
    end

    function out = interd(xs, ys, x)
        gpts = length(xs);
        vpts = length(x);

        loc = sum(repmat(x,gpts,1) > repmat(xs',1,vpts), 1);
        ys = [ys(1), ys, ys(end)];
        xs = [xs(1)-1, xs, xs(end)+1];

        out = (ys(loc+2)-ys(loc+1))./(xs(loc+2)-xs(loc+1));
    end

end
