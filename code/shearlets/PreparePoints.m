function [x, computefor] = PreparePoints(s, x, params)

    if nargin < 3
        params = Settings;
    end

    % Transform the points
    [P, c] = GetTransform(s, 0, params);
    x = P * (x - repmat(c, 1, size(x,2)));
    computefor = 1:size(x,2);

    % Extra work for periodic case
    if params.periodic
        % Transform the principal directions
        dirs = P * [1 0; 0 1];
        if s.Cone == 1
            dirs = fliplr(dirs);
        end

        % Solution of m and n
        n_min = ceil((-x(2,:)-0.5)/dirs(2,2));
        n_max = floor((-x(2,:)+0.5)/dirs(2,2));
        n = n_min;

        m_min = ceil((-x(1,:)-n*dirs(1,2)-0.5)/dirs(1,1));
        m_max = floor((-x(1,:)-n*dirs(1,2)+0.5)/dirs(1,1));
        m = m_min;

        % Disregard points where the solution is out of bounds
        computefor = setdiff(computefor, find(m_min>m_max));
        computefor = setdiff(computefor, find(n_min>n_max));

        % Translate points to bring them inside the domain
        x = x + repmat(m,2,1).*repmat(dirs(:,1),1,size(x,2))...
              + repmat(n,2,1).*repmat(dirs(:,2),1,size(x,2));
    end

end
