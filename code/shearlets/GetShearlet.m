function s = GetShearlet(i, params)

    if nargin < 2
        params = Settings;
    end

    orig = i;

    s.Level = 0;
    while i > params.numatlevel(s.Level+1)
        i = i - params.numatlevel(s.Level+1);
        s.Level = s.Level + 1;
    end

    s.Cone = 0;
    if i > params.numatlevel(s.Level+1) / 2
        i = i - params.numatlevel(s.Level+1) / 2;
        s.Cone = 1;
    end

    s.F = mod(i-1, params.numfunctions(s.Level+1));
    i = ceil(i/params.numfunctions(s.Level+1));

    s.K = mod(i-1,params.numshears(s.Level+1))-(params.numshears(s.Level+1)-1)/2;
    i = ceil(i/params.numshears(s.Level+1));

    s.R = mod(i-1, params.numright(s.Level+1));
    i = ceil(i/params.numright(s.Level+1));

    s.U = i-1;

    s = RefreshShearletData(s, params);

    if s.N ~= orig
        disp(['Error in getting shearlet ' num2str(orig) ' [GetShearlet.m]']);
    end

end
