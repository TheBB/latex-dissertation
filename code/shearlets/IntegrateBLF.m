function out = IntegrateBLF(blf, u, v, qr, params)

    if nargin < 5
        params = Settings;
    end

    out = sum(qr.w .* blf(u, v, qr.x, params));

end
