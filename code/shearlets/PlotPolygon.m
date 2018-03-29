function PlotPolygon(p, r, w)

    if ~isempty(p)

        p = [p p(:,1)];
        plot(p(1,:), p(2,:), r, 'LineWidth', w);

    end

end
