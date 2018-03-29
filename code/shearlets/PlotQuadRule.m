function PlotQuadRule(qr)

    if length(qr.x) > 0
        plot(qr.x(1,:), qr.x(2,:), 'b*', 'MarkerSize', 2);
    end;

    PlotSurroundings();

end
