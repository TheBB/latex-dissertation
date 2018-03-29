function PlotSurroundings(buffer)

    if nargin < 1
        buffer = 0.2;
    end

    hold on;
    
    plot([0 1], [0 0], 'b');
    plot([0 1], [1 1], 'b');
    plot([0 0], [0 1], 'b');
    plot([1 1], [0 1], 'b');
    axes = gca();
    set(axes, 'xlimmode', 'manual');
    set(axes, 'ylimmode', 'manual');
    set(axes, 'xlim', [-buffer, 1+buffer]);
    set(axes, 'ylim', [-buffer, 1+buffer]);

    set(gca,'xcolor',get(gcf,'color'));
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);

    hold off;

end
