function s = Up(s, n, params)

    if nargin < 3
        params = Settings;
    end

    if nargin < 2 || isempty(n)
        n = 1;
    end

    s.U = s.U + n;
    if s.U >= params.numup(s.Level+1)
        s.U = params.numup(s.Level+1) - 1;
    elseif s.U < 0
        s.U = 0; 
    end;
    s = RefreshShearletData(s, params);

end
