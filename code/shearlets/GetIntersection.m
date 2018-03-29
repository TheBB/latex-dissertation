function [np, p] = GetIntersection(u, i, v, j, params)

    if nargin < 5, params = Settings; end
    if nargin < 4, j = 0; end
    if nargin < 3, v = []; end
    if nargin < 2, i = 0; end

    sp = GetShearletCorners();
    S.x = sp(1,:); S.y = sp(2,:); S.hole = 0;
    U = BuildPolygon(u, i, params);

    R = PolygonClip(U, S, 1);

    if length(R) == 0
        np = 0;
        p = [];
        return;
    end

    if nargin > 2 && ~isempty(v)
        V = BuildPolygon(v, j, params);
        R = PolygonClip(R, V, 1);

        if length(R) == 0
            np = 0;
            p = [];
            return;
        else
            np = length(R);
            for k = 1:length(R)
                p(k).p = fliplr([R(k).x'; R(k).y']);
            end
            return;
        end
    else
        np = length(R);
        for k = 1:length(R)
            p(k).p = fliplr([R(k).x'; R(k).y']);
        end
        return;
    end

    function U = BuildPolygon(u, i, params)
        up = GetShearletCorners(u, i, params);
        U(1).x = up(1,:); U(1).y = up(2,:); U(1).hole = 0;

        if params.periodic
            [r, l, u, d] = CrossesBoundary(params, u, i);

            U = AddToPol(U, 1, -r, 0);
            U = AddToPol(U, 1, l, 0);
            U = AddToPol(U, 1, 0, -u);
            U = AddToPol(U, 1, 0, d);
            U = AddToPol(U, 1, -(r&u), -(r&u));
            U = AddToPol(U, 1, l&u, -(l&u));
            U = AddToPol(U, 1, -(r&d), r&d);
            U = AddToPol(U, 1, l&d, l&d);
        end
    end

    function pol = AddToPol(pol, ref, xadd, yadd)
        if (xadd ~= 0) | (yadd ~= 0)
            k = length(pol) + 1;
            pol(k).x = pol(ref).x + xadd;
            pol(k).y = pol(ref).y + yadd;
            pol(k).hole = pol(ref).hole;
        end
    end

end
