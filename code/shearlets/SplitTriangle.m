function out = SplitTriangle(trs, L)

    if L > 0
        out = zeros(6, 4*size(trs,2));
        i = 1;

        for tr = trs
            q = reshape(tr, 2, 3);
            out(:, i:i+3) = [reshape([q(:,1), avg(q(:,1),q(:,2)),...
                                      avg(q(:,1),q(:,3))], 6, 1),...
                             reshape([q(:,2), avg(q(:,2),q(:,3)),...
                                      avg(q(:,2),q(:,1))], 6, 1),...
                             reshape([q(:,3), avg(q(:,3),q(:,1)),...
                                      avg(q(:,3),q(:,2))], 6, 1),...
                             reshape([avg(q(:,1),q(:,2)),...
                                      avg(q(:,3),q(:,2)),...
                                      avg(q(:,3),q(:,1))], 6, 1)];
            i = i + 4;
        end

        out = SplitTriangle(out, L-1);
    else
        out = trs;
    end

    function out = avg(a, b)
        out = 0.5 * (a+b);
    end

end
