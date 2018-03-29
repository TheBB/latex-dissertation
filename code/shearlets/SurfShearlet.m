function SurfShearlet(s, N, params)

    persistent f;

    if ~exist('f') || isempty(f)
        f = figure();
    end

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
    zz = EvaluateShearlet(s, pts, params);
    zz = reshape(zz, N, N); 

    figure(f);
    set(gcf,'Renderer','painters');
    surf(gca,xx,yy,zz,'EdgeColor','none','FaceColor','interp');
    view(0,90);
    xlabel('x');
    ylabel('y');
    colorbar;

    PlotSurroundings();

end
