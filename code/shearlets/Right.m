function s = Right(s, n, params)

    if nargin < 3
        params = Settings;
    end

    if nargin < 2 || isempty(n)
        n = 1;
    end

    s.R = s.R + n;
    if s.R >= params.numright(s.Level+1)
        s.R = params.numright(s.Level+1) - 1;
    elseif s.R < 0
        s.R = 0; 
    end;
    s = RefreshShearletData(s, params);

end
