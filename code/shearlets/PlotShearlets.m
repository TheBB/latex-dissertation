function PlotShearlets(varargin)

    for i=1:nargin, PlotSingleShearlet(varargin{i}); end

    PlotSurroundings();

end
