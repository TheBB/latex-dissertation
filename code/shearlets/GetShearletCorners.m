function p = GetShearletCorners(s, i, params)

    if nargin < 3
        params = Settings;
    end

    if nargin < 1
        % No shearlet given, return the computational domain
        p = [0, 1, 1, 0; 0, 0, 1, 1];
    else
        % Get transformation for shearlet (or subdomain)
        if nargin < 2
            i = 0;
        end
        [P, c] = GetTransform(s, i, params);

        % Transform the full domain
        p = [-.5, .5, .5, -.5; -.5, -.5, .5, .5];
        p = P\p + repmat(c, 1, size(p,2));

        % Reverse order if r=1 to ensure clockwise traversal
        if s.Cone == 1
            p = fliplr(p);
        end
    end

end
