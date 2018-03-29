function out = CheckPolygonIntersection(p, q)

    % Empty polygons do not intersect
    if isempty(p) || isempty(q)
        out = 0;
        return;
    end

    cp = [p(:,end), p];
    cq = [q(:,end), q];

    % Loop through edges of P
    for i = 2:size(cp,2)
        base_tmp = cp(:,i) - cp(:,i-1);         % Edge
        base = [base_tmp(2); -base_tmp(1)];     % Outward normal

        separator = 1;
        % Check each vertex of Q
        for j = 2:size(cq,2)
            if dot(cq(:,j) - cp(:,i), base) < 0
                % The j-1'th vertex of Q is on the wrong side
                % This edge is not a separating line
                separator = 0;
                break;
            end
        end

        % If a separating line has been found, return
        if separator
            out = 0;
            return;
        end

    end

    % Loop through the edges of Q
    % This is identical to the above loop
    % (code removed)

    % No separating line has been found, the polygons intersect
    out = 1;

end
