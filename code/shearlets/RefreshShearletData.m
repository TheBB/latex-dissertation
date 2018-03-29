function s = RefreshShearletData(s, params)

    if nargin < 2
        params = Settings;
    end

    if s.Cone == 0,
        s.X = params.leftstart(s.Level+1) + s.R * params.rightskip(s.Level+1);
        s.Y = params.downstart(s.Level+1) + s.U * params.upskip(s.Level+1);
    else
        s.Y = params.leftstart(s.Level+1) + s.R * params.rightskip(s.Level+1);
        s.X = params.downstart(s.Level+1) + s.U * params.upskip(s.Level+1);
    end;

    n = 0;
    if s.Level > 0
        n = params.numbelowlevel(s.Level);
    end
    if s.Cone == 1
        n = n +   params.numfunctions(s.Level+1)... 
                * params.numup(s.Level+1)...
                * params.numright(s.Level+1)...
                * params.numshears(s.Level+1);
    end
    n = n + s.U * params.numfunctions(s.Level+1)...
                * params.numright(s.Level+1)...
                * params.numshears(s.Level+1);
    n = n + s.R * params.numfunctions(s.Level+1)...
                * params.numshears(s.Level+1);
    n = n +   params.numfunctions(s.Level+1)...
            * (s.K + (params.numshears(s.Level+1)-1)/2);
    n = n + s.F;
    n = n + 1;

    s.N = n;

    r = GetShearletCorners(s, 0, params);
    s.Radius = max(sqrt(sum((r-repmat([s.X;s.Y],1,4)).^2, 1)));

end
