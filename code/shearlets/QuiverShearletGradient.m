function QuiverShearletGradient(s, N, params)

    if nargin < 3
        params = Settings;
    end

    if nargin < 2 || N == 0
        N = 65; 
    end

    x = linspace(0,1,N);
    y = linspace(0,1,N);
    [xx,yy] = meshgrid(x,y);
    pts = [xx(:), yy(:)]';
    zz = EvaluateShearletGradient(s, pts, params);
    uu = reshape(zz(1,:), N, N); 
    vv = reshape(zz(2,:), N, N); 

    quiver(xx, yy, uu, vv, params);
    xlabel('x');
    ylabel('y');
    PlotSurroundings();

end
