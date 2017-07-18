function [] = hanging_chain_plot (xy,type)

%
% Plot of the hanging chain.
%
% On entry
% . xy: x-coordinate and y-coordinate of the free joints
% . type: string which can be
%     'first': inital plot
%     'intermediate': intermediate plot
%     'final': final plot

% Global and persistent variables

  global HC_nj HC_nf HC_a HC_b HC_r HC_s HC_axis simul_not_initialized

  persistent n ground init inter final

% Set global and persistent variables (only once)

  if simul_not_initialized

    n = length(xy);
    [coord,ground,init,inter,final] = hanging_chain_plot_params ();

  end

% Split xy

  x = xy(1:HC_nj);
  y = xy(HC_nj+1:n);

% Various types of plots

  switch type

    % plot the initial chain

    case 'first'

      if ground.present
        if HC_nf
          for i=1:HC_nf
            h = fill([HC_axis(1),HC_axis(2),HC_axis(2),HC_axis(1)], ...
                     [HC_r(i)+HC_s(i)*HC_axis(1),HC_r(i)+HC_s(i)*HC_axis(2), ...
                      HC_r(i)+HC_s(i)*HC_axis(2)-2,HC_r(i)+HC_s(i)*HC_axis(1)-2],ground.color);
              set(h,'EdgeColor',ground.color);
          end
        end
      end

      if coord.present
        axis on         % default 'axis off' is set in simulopt.m
        if ground.present && HC_nf; set(gca,'TickDir','out'); end
      end

      if init.present
        h = plot([0; xy(1:HC_nj); HC_a],[0; xy(HC_nj+1:n); HC_b],[init.type init.color]);
          set(h,'LineWidth',init.width)
        h = plot(xy(1:HC_nj),xy(HC_nj+1:n),[init.color '.']);
          set(h,'MarkerSize',20)
        h = plot(0,0,'k.');
          set(h,'MarkerSize',20)
        h = plot(HC_a,HC_b,'k.');
          set(h,'MarkerSize',20)
      end

      drawnow
      return

    % plot an intermediate chain

    case 'intermediate'

      if inter.present
        h = plot([0; x; HC_a],[0; y; HC_b],[inter.color inter.type]);
          set(h,'LineWidth',inter.width)
        h = plot(x,y,[inter.color '.']);
          set(h,'MarkerSize',25)
          set(h,'LineWidth',inter.width)
        h = plot(0,0,'k.');
          set(h,'MarkerSize',25)
        h = plot(HC_a,HC_b,'k.');
          set(h,'MarkerSize',25)
        drawnow
      end

      return

    % plot the final chain

    case 'final'

      if final.present
        h = plot([0; x; HC_a],[0; y; HC_b],[final.color final.type]);
          set(h,'LineWidth',final.width)
        h = plot(x,y,[final.color '.']);
          set(h,'MarkerSize',25)
          set(h,'LineWidth',final.width)
        h = plot(0,0,'k.');
          set(h,'MarkerSize',25)
        h = plot(HC_a,HC_b,'k.');
          set(h,'MarkerSize',25)
        drawnow
      end

      return

  end

end

