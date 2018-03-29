function out = EvaluateBLF(blf, u, v, params)

    if nargin < 4
        params = Settings;
    end

    if CheckShearletIntersection(u, v, params);

        [np,p] = GetIntersection(u, 0, v, 0, params);

        if np == 0
            out = 0;
            return;
        else
            qr = BuildDoubleQuadRule(u, v, params);
            if size(qr.x,2) > 0
                out = IntegrateBLF(blf, u, v, qr, params);
            else
                out = 0;
            end
        end

    else
        out = 0;
    end

end
