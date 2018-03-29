function [cp1, cp2] = EvaluateShearletGradients(shearlets, x, params)

    if nargin < 3
        params = Settings;
    end

    cp1 = zeros(size(x,2),length(shearlets));
    cp2 = zeros(size(x,2),length(shearlets));
    for i=1:length(shearlets)
        a = EvaluateShearletGradient(GetShearlet(shearlets(i)), x, params)';
        cp1(:,i) = a(:,1);
        cp2(:,i) = a(:,2);
    end

end
