function PlotShears(varargin)

    colors = 'rgbkcm';

    p = Settings;

    c = 1;

    for i=1:nargin, for k=0:p.numshears(varargin{i}.Level+1)-1,
        varargin{i}.K = k - (p.numshears(varargin{i}.Level+1)-1)/2;
        PlotSingleShearlet(varargin{i}, colors(c));
        c = c+1;
    end; end;

    PlotSurroundings();

end
