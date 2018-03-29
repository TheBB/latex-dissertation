function PlotAllShearlets(N, k, params)

    if nargin < 3
        params = Settings;
    end

    for i=N
        clf;
        s = GetShearlet(i);
        PlotShearlets(s);
        pause(k/params.numatlevel(s.Level+1));
    end;

end
