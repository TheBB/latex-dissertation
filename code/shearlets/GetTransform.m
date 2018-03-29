function [P, c] = GetTransform(s, i, params)

    if nargin < 3
        params = Settings;
    end

    % The translation vector has been precomputed
    c = [s.X; s.Y];

    % The transformation matrix has not
    a = params.xscale / params.yscale;
    P = [1,a*s.K; 0,1] * [params.xscale^s.Level,0;...
                          0,params.yscale^s.Level];
    if s.Cone == 1
        P = P * [0 1; 1 0]; 
    end

    % Restrict to subdomain if necessary
    if nargin > 1 && i > 0
        XS = length(params.wvfunctions(s.Level+1,s.F+1).xpts)-1;
        YS = length(params.scfunctions(s.Level+1,s.F+1).xpts)-1;

        Qi = [XS, 0; 0, YS];
        ci = [(mod(i-1,XS)+.5)/XS-.5; (floor((i-1)/XS)+.5)/YS-.5];
        c = P\ci+c;
        P = Qi*P;
    end

end
