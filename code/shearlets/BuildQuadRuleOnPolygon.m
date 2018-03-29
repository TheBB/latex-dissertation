function r = BuildQuadRuleOnPolygon(p, L, params)

    if nargin < 3
        params = Settings;
    end

    r.x = [];
    r.w = [];

    % No quadrature on empty sets
    if isempty(p)
        return;
    end

    idxs = [1, 2, size(p,2)];       % Indices of the next triangle
    sw = 2;                         % Which side is next (1 or 2)
    endidx = 1; startidx = 3;       % Number of used points from the end
                                    % on the left and right side
    while true
        % Split the next triangle into smaller ones 
        % (for quadrature accuracy purposes)
        trs = SplitTriangle(reshape(p(:, idxs), 6, 1), L);

        % For each of them, add quadrature points
        for tr = trs
            temp = TransformQuadRule(params.qr, reshape(tr, 2, 3));
            if sum(temp.w) > 0
                r.x = [r.x, temp.x];
                r.w = [r.w, temp.w];
            end
        end

        if sw == 2
            % Move forward on the left side, switch to right
            idxs = [idxs(2), size(p,2)-endidx, idxs(3)];
            endidx = endidx + 1;
            sw = 1;
        elseif sw == 1
            % Move forward on the rigth side, switch to left
            idxs = [idxs(1), startidx, idxs(2)];
            startidx = startidx + 1;
            sw = 2;
        end

        % If indices overlap, we are done
        if length(unique(idxs)) < 3,
            break;
        end
    end

end
