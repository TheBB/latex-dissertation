function ret = Load(k, I, lf, params)

    N = 10000;

    persistent L;
    persistent nodes;
    persistent defined;

    if isa(k, 'char')
        if strcmp(k, 'clear')
            disp('Clearing...');
            clear L;
            clear nodes;
            clear defined;
            ret = 0;
            return;
        end
    end

    if ~exist('defined')
        defined = [];
    end

    if (length(defined) < k) || (defined(k) == 0)
        disp('Allocating...');
        L{k} = zeros(N, 1);
        nodes{k} = zeros(1, N);
        defined(k) = 1;
    end

    if nargin < 4
        params = Settings();
    end

    newI = find(nodes{k}(I) == 0);
    newnodes = I(newI);

    if size(newnodes, 1) == 0
        newnodes = [];
    end

    nums = 0;
    tempLk = L{k};
    tempnodesk = nodes{k};
    parfor i = newnodes,
        tempLk(i) = EvaluateLF(lf, GetShearlet(i), params);
        tempnodesk(i) = 1;
    end
    nodes{k} = tempnodesk;
    L{k} = tempLk;

    ret = L{k}(I);

end
