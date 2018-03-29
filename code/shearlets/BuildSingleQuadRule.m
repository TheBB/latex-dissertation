function r = BuildSingleQuadRule(v, L, params)

    if nargin < 3
        params = Settings;
    end

    r.x = [];
    r.w = [];

    if nargin < 2 || isempty(L)
        L = params.maxlevel - v.Level;
    end

    % Get number of subdomains
    numSections =...
          (length(params.wvfunctions(v.Level+1,v.F+1).xpts)-1)...
        * (length(params.scfunctions(v.Level+1,v.F+1).xpts)-1);

    % For each subdomain...
    for i = 1:numSections
        % ...intersect it with the computational domain...
        [np,p] = GetIntersection(v, i, [], 0, params);

        % ...and form a quadrature rule on each resulting polygon.
        for k = 1:np
            rule = BuildQuadRuleOnPolygon(p(k).p, L, params);
            r.x = [r.x, rule.x];
            r.w = [r.w, rule.w];
        end
    end

end
