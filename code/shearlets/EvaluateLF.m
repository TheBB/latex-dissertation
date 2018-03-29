function out = EvaluateLF(lf, v, params)

    if nargin < 3
        params = Settings;
    end

    if CheckPolygonIntersection(GetShearletCorners(),...
                                GetShearletCorners(v, 0, params))

        [np,p] = GetIntersection(v, 0, [], 0, params);

        if np == 0
            out = 0;
            return;
        else
            qr = BuildSingleQuadRule(v, [], params);
            if size(qr.x,2) > 0
                out = IntegrateLF(lf, v, qr, params);
            else
                out = 0;
            end
        end

    else
        out = 0;
    end

end
