function varargout = CrossesBoundary(params, varargin)

    right = zeros(1,ceil((nargin-1)/2));
    left = zeros(1,ceil((nargin-1)/2));
    up = zeros(1,ceil((nargin-1)/2));
    down = zeros(1,ceil((nargin-1)/2));

    for i = 1:2:nargin-1
        j = 0;
        if nargin > i+1, j = varargin{i+1}; end;
        q = GetShearletCorners(varargin{i}, j, params);

        if max(q(1,:)) > 1, right(ceil(i/2)) = 1; end;
        if min(q(1,:)) < 0, left(ceil(i/2)) = 1; end;
        if max(q(2,:)) > 1, up(ceil(i/2)) = 1; end;
        if min(q(2,:)) < 0, down(ceil(i/2)) = 1; end;
    end

    if nargout == 1
        varargout{1} = right | left | up | down;
    elseif nargout == 2
        varargout{1} = right | left;
        varargout{2} = up | down;
    elseif nargout == 4
        varargout{1} = right;
        varargout{2} = left;
        varargout{3} = up;
        varargout{4} = down;
    end

end
