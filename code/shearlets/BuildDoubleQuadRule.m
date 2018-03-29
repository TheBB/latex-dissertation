function r = BuildDoubleQuadRule(u, v, params)

    if nargin < 3
        params = Settings;
    end

    if u.N == v.N
        % If the shearlets are the same, we can use a single QR
        r = BuildSingleQuadRule(u, 0, params);
    else
        r.x = [];
        r.w = [];

        % Numbers of subdomains
        numSectionsU =...
              (length(params.wvfunctions(u.Level+1,u.F+1).xpts)-1)...
            * (length(params.scfunctions(u.Level+1,u.F+1).xpts)-1);
        numSectionsV =...
              (length(params.wvfunctions(v.Level+1,v.F+1).xpts)-1)...
            * (length(params.scfunctions(v.Level+1,v.F+1).xpts)-1);

        % For each pair of subdomains...
        for i = 1:numSectionsU
        for j = 1:numSectionsV
            % ...get the intersection as a union of polygons...
            [np,p] = GetIntersection(u, i, v, j, params);

            % ...and for each polygon, get a quadrature rule
            for k = 1:np
                rule = BuildQuadRuleOnPolygon(p(k).p, 0, params);
                r.x = [r.x, rule.x];
                r.w = [r.w, rule.w];
            end
        end
        end
    end

end
