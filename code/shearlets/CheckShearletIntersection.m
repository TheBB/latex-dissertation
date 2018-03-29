function out = CheckShearletIntersection(u, v, params)

    if nargin < 3
        params = Settings;
    end

    % Get polygons for the support of the shearlets
    p = GetShearletCorners(u, 0, params);
    q = GetShearletCorners(v, 0, params);

    % Compute a set of translations that must be checked
    Nvals = 0;
    Mvals = 0;
    if params.periodic
        deltax = v.X - u.X;
        deltay = v.Y - u.Y;
        rad = v.Radius + u.Radius;

        Nvals = ceil(-rad-deltax):floor(rad-deltax);
        Mvals = ceil(-rad-deltay):floor(rad-deltay);
    end

    % Check each pair of translations
    for N = Nvals
    for M = Mvals
        if CheckPolygonIntersection(p, q + repmat([N;M],1,size(q,2)))
            % An intersection was found, this is enough
            out = 1;
            return;
        end
    end
    end

    % No intersection found
    out = 0;

end
