function s = Flip(s, params)

    if nargin < 2
        params = Settings;
    end

    s.Cone = 1 - s.Cone;
    s = RefreshShearletData(s, params);

end
