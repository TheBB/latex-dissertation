function ret = Stiffness(k, I, J, blf, sym, params)

    N = 10000;
    NNZ = 1000*N;

    persistent A;
    persistent nodes;
    persistent defined;

    if isa(k, 'char')
        if strcmp(k, 'clear')
            disp('Clearing...');
            clear A;
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
        A{k} = spalloc(N, N, NNZ);
        nodes{k} = zeros(1, N);
        defined(k) = 1;
    end

    if nargin < 6
        params = Settings();
    end

    maxidx = max(max(I),max(J));
    if maxidx > length(nodes{k})
        nodes{k} = [nodes{k}, zeros(1, maxidx-length(nodes{k}))];
    end

    newI = find(nodes{k}(I) == 0);
    newJ = find(nodes{k}(J) == 0);
    newnodes = unique([I(newI), J(newJ)]);
    oldnodes = find(nodes{k} == 1);

    if size(newnodes, 1) == 0
        newnodes = [];
    end

    nums = 0;
    N = length(newnodes);
    tots = length(oldnodes)*N + N*(N+1)/2;
    disp(' ');
    if tots > 0
        progmeter(0, ['Computing ' num2str(tots) ' entries of mx #' num2str(k)]);
    end

    for i = newnodes
        temph = zeros(1,length(oldnodes));
        tempv = zeros(length(oldnodes),1);
        parfor j = 1:length(oldnodes)
            temph(j) = EvaluateBLF(blf,...
                                   GetShearlet(oldnodes(j), params),...
                                   GetShearlet(i, params),...
                                   params);
            if sym
                tempv(j) = temph(j);
            else
                tempv(j) = EvaluateBLF(blf,...
                                       GetShearlet(i, params),...
                                       GetShearlet(oldnodes(j), params),...
                                       params);
            end
        end

        A{k}(i,oldnodes) = temph;
        A{k}(oldnodes,i) = tempv;
        
        A{k}(i,i) = EvaluateBLF(blf,...
                                GetShearlet(i, params),...
                                GetShearlet(i, params),...
                                params);
        nums = nums + length(oldnodes) + 1; progmeter(nums/tots);

        nodes{k}(i) = 1;
        oldnodes = [oldnodes, i];
    end

    ret = A{k}(I,J);

    if tots > 0
        progmeter done
    end

end
