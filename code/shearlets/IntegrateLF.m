function out = IntegrateLF(lf, v, qr, params)

    if nargin < 4
        params = Settings;
    end

    out = sum(qr.w .* lf(v, qr.x, params));

end
