function PlotSingleShearlet(s, col, params)

    subparts = 0;
    labels = 0;

    if nargin < 3
        params = Settings;
    end

    if nargin < 2
        col = 'k';
    end

    col = strcat(col, '-');

    hold on;

    numSections = (length(params.wvfunctions(s.Level+1,s.F+1).xpts)-1) * (length(params.scfunctions(s.Level+1,s.F+1).xpts)-1);
    for i = 0:numSections
        PlotIt(s,i);
        if ~subparts
            break;
        end
    end

    hold off;

    function PlotIt(s,i)
        p = GetShearletCorners(s, i, params);
        plot([p(1,:), p(1,1)], [p(2,:), p(2,1)], col);

        if labels && i ~= 0
            text(mean(p(1,:)), mean(p(2,:)),...
                ['\bf\fontsize{12}' num2str(i)],...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        end
    end

end
