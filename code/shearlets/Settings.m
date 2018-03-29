function out = Settings(varargin)

    persistent params
    persistent locked

    if ~exist('params') || isempty(params) ||... 
       ((nargin > 0 && strcmp(varargin{1},'clear')) && ~locked)

        params.let = 'shearlet';
        params.interior = 0;
        params.periodic = 0;
        params.qr = P7O6();
        params.k = @(x) ones(1,size(x,2));
        params.f = @(x) ones(1,size(x,2));
        params.s = @(x) [ones(1,size(x,2)); ones(1,size(x,2))];
        params.maxlevel = 2;
        params.numfunctions = 2 * ones(1,params.maxlevel+1);
        params.numfunctions(1) = 1;

        for l=2:params.maxlevel+1
            params.wvfunctions(l,1).xpts = [-.5, -.25, 0, .25, .5];
            params.wvfunctions(l,1).fvals = [0, -.5, 1, -.5, 0];
            params.wvfunctions(l,2).xpts = [-.5, -.25, 0, .25, .5];
            params.wvfunctions(l,2).fvals = [0,-sqrt(2)/4,0,sqrt(2)/4,0];
            params.scfunctions(l,1).xpts = [-.5, 0, .5];
            params.scfunctions(l,1).fvals = [0, 1, 0];
            params.scfunctions(l,2).xpts = [-.5, 0, .5];
            params.scfunctions(l,2).fvals = [0, 1, 0];
        end
        params.wvfunctions(1,1).xpts = [-.5, 0, .5];
        params.wvfunctions(1,1).fvals = [0, 1, 0];
        params.scfunctions(1,1).xpts = [-.5, 0, .5];
        params.scfunctions(1,1).fvals = [0, 1, 0];

        params.xscale = 4;
        params.yscale = 2;

        params = fixlevels(params);

        params.desc = 'Default';

        locked = 0;

    end

    if nargin > 0 && strcmp(varargin{1},'lock')
        locked = 1;
        disp('Settings locked');
    elseif nargin > 0 && strcmp(varargin{1},'unlock')
        locked = 0;
        disp('Settings unlocked');
    elseif locked && nargin > 0
        disp('Settings change interrupted');
    else

        for j = 1:2:nargin
            switch lower(varargin{j})
                case 'let'
                    if strcmp(varargin{j+1},'ridgelet')
                        params.let = 'ridgelet';
                    else
                        params.let = 'shearlet';
                    end
                case 'interior'
                    if varargin{j+1} == 1
                        params.interior = 1;
                    else
                        params.interior = 0;
                    end
                case 'periodic'
                    if varargin{j+1} == 1
                        params.periodic = 1;
                    else
                        params.periodic = 0;
                    end
                    params = fixlevels(params);
                case 'qr'
                    params.qr = varargin{j+1};
                case 'k'
                    params.k = varargin{j+1};
                case 'f'
                    params.f = varargin{j+1};
                case 's'
                    params.s = varargin{j+1};
                case 'glob'
                    params.glob = varargin{j+1};
                case 'globd'
                    params.globd = varargin{j+1};
                case 'maxlevel'
                    params.maxlevel = varargin{j+1};
                    for j = length(params.numfunctions):params.maxlevel;
                        params.wvfunctions(end+1,:) = params.wvfunctions(end,:);
                        params.scfunctions(end+1,:) = params.scfunctions(end,:);
                        params.numfunctions(end+1) = params.numfunctions(end);
                    end
                    params = fixlevels(params);
                case 'numfunctions'
                    params.numfunctions = varargin{j+1};
                    params = fixlevels(params);
                case 'wvfunctions'
                    params.wvfunctions = varargin{j+1};
                case 'scfunctions'
                    params.scfunctions = varargin{j+1};
                case 'xscale'
                    params.xscale = varargin{j+1};
                    params = fixlevels(params);
                case 'yscale'
                    params.yscale = varargin{j+1};
                    params = fixlevels(params);
                case 'desc'
                    params.desc = varargin{j+1};
            end
        end

    end

    out = params;

    function params = fixlevels(params)

        params.rightskip = zeros(1,params.maxlevel+1);
        params.upskip = zeros(1,params.maxlevel+1);
        params.leftstart = zeros(1,params.maxlevel+1);
        params.downstart = zeros(1,params.maxlevel+1);
        params.numright = zeros(1,params.maxlevel+1);
        params.numup = zeros(1,params.maxlevel+1);
        params.numshears = zeros(1,params.maxlevel+1);
        params.numatlevel = zeros(1,params.maxlevel+1);
        params.numbelowlevel = zeros(1,params.maxlevel+1);

        for i = 0:params.maxlevel
            if i == 0
                params.rightskip(i+1) = 0.5;
                params.upskip(i+1) = 0.5;
                params.numshears(i+1) = 1;
            else
                params.rightskip(i+1) = params.xscale^(-i)/4;
                params.upskip(i+1) = params.yscale^(-i)/2;
                params.numshears(i+1) = 2^i + 1;
            end

            params.downstart(i+1) = 0;
            if params.periodic
                params.leftstart(i+1) = 0;
                params.numright(i+1) = 1/params.rightskip(i+1);
                params.numup(i+1) = 1/params.upskip(i+1);
            else
                if i == 0
                    params.leftstart(i+1) = 0;
                else
                    params.leftstart(i+1) = params.rightskip(i+1)... 
                                - 0.5*(params.xscale^(-i) + params.yscale^(-i));
                end
                params.numright(i+1) = round((1-2*params.leftstart(i+1))...
                            /params.rightskip(i+1)) + 1;
                params.numup(i+1) = round((1-2*params.downstart(i+1))...
                            /params.upskip(i+1)) + 1;
            end

            params.numatlevel(i+1) = 2 * params.numfunctions(i+1)...
                                       * params.numup(i+1)... 
                                       * params.numright(i+1)...
                                       * params.numshears(i+1);
            params.numbelowlevel(i+1) = sum(params.numatlevel);
        end

    end

end
