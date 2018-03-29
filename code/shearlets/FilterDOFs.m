function out = FilterDOFs(A, I, J, decider)

    Is = [];
    for i = 1:length(I)
        if decider(I(i))
            Is = [Is i];
        end
    end

    if ~isvector(A)
        Js = [];
        for j = 1:length(J)
            if decider(J(j))
                Js = [Js j];
            end
        end

        out = A(Is,Js);
    else
        out = A(Is);
    end

end
