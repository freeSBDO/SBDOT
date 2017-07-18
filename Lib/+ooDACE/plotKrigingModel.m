%> @file "plotKrigingModel.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	h = plotKrigingModel(k, LB, UB)
%
% ======================================================================
%> @brief Generate some plots of a Kriging model
%>
%> Only for 1D/2D models.
%>
%> @param k Kriging model
%> @param LB lowerbound of input parameters (optional)
%> @param UB upperbound of input parameters (optional)
%> @retval h handles to the figure windows
% ======================================================================
function h = plotKrigingModel(k, LB, UB)

samples = k.getSamples();
values = k.getValues();

if ~exist( 'LB', 'var' )
   LB = min(samples);
   UB = max(samples);
end

inDim = size(samples,2);

if inDim == 1
    density = 250;

    x = linspace( LB, UB, density ).';
    [y s2] = k.predict( x );

    fprintf('Calculating derivatives for plot... (may take a while).\n');

    dy = zeros( size(x) ); % derivative of prediction
    ds2 = zeros( size(x) ); % derivative of prediction variance
    for i=1:size(x, 1)
         [dy(i,:) ds2(i,:)] = k.predict_derivatives( x(i,:) );
    end

    % plot of prediction + derivatives
    h(1) = figure;
    [ax, hline1, hline2] = plotyy(x,y,x,dy);
    set(hline1,'LineStyle','-')
    set(hline2,'LineStyle','--')
    
    hold(ax(1), 'on' );
    if iscell( samples )
        plot( ax(1), samples{1}, values{1}, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10 );
        plot( ax(1), samples{2}, values{2}, 'ko', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',10 );
    else
        plot( ax(1), samples(:,1), values, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10 );
    end
    
    title('Plot of Kriging model', 'FontSize', 14);
    xlabel('x', 'FontSize', 14);
    set(get(ax(1),'Ylabel'),'String','f(x)') 
    set(get(ax(2),'Ylabel'),'String','df(x)/dx') 
    %set(gca, 'FontSize', 14);
    hold off;

    % plot of prediction variance + derivatives
    h(2) = figure;
    [ax, hline1, hline2] = plotyy(x,s2,x,ds2);
    set(hline1,'LineStyle','-')
    set(hline2,'LineStyle','--')
    
    title('Plot of Kriging model (variance)', 'FontSize', 14);
    xlabel('x', 'FontSize', 14);
    set(get(ax(1),'Ylabel'),'String','s2(x)') 
    set(get(ax(2),'Ylabel'),'String','ds2(x)/dx') 
    %set(gca, 'FontSize', 14);
    hold off;

    
else %if inDim == 2
    density = 50;

    % landscape plot of model
    h(1) = figure;

    x1 = linspace( LB(1), UB(1), density );
    x2 = linspace( LB(2), UB(2), density );
    gridx = makeEvalGrid( {x1 x2} );
    [gridy grids2] = k.predict( gridx );

    surfc( x1, x2, reshape( gridy, density, density ) );
    hold on;
    if iscell( samples )
        plot3( samples{1}(:,1), samples{1}(:,2), values{1}, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10 );
        plot3( samples{2}(:,1), samples{2}(:,2), values{2}, 'ko', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',10 );
    else
        plot3( samples(:,1), samples(:,2), values, 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10 );
    end

    title('Landscape plot of kriging model', 'FontSize', 14);
    xlabel('x', 'FontSize', 14);
    ylabel('y', 'FontSize', 14);
    zlabel('f(x,y)', 'FontSize', 14);
    set(gca, 'FontSize', 14);
    hold off;

    % contour plot of model
    fprintf('Calculating derivatives for contour plot... (may take a while).\n');

    dgridy = zeros( size(gridx) ); % derivative of prediction
    dgrids2 = zeros( size(gridx) ); % derivative of prediction variance
    for i=1:size(gridx, 1)
         [dy ds2] = k.predict_derivatives( gridx(i,:) );
         dgridy(i,:) = dy;
         dgrids2(i,:) = ds2;
    end

    h(2) = figure;
    contourf( x1, x2, reshape( gridy, density, density ) );
    hold on;
    quiver( gridx(:,1), gridx(:,2), dgridy(:,1), dgridy(:,2), 'k' );

    title('Contour plot of kriging model', 'FontSize', 14);
    xlabel('x', 'FontSize', 14);
    ylabel('y', 'FontSize', 14);
    set(gca, 'FontSize', 14);
    hold off;

    h(3) = figure;
    contourf( x1, x2, reshape( grids2, density, density ) );
    hold on;
    quiver( gridx(:,1), gridx(:,2), dgrids2(:,1), dgrids2(:,2), 'k' );

    if iscell( samples )
        plot( samples{1}(:,1), samples{1}(:,2), 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k' );
        plot( samples{2}(:,1), samples{2}(:,2), 'ko', 'MarkerEdgeColor','k', 'MarkerFaceColor','b' );
    else
        plot( samples(:,1), samples(:,2), 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','k' );
    end

    title('Contour plot of kriging model (variance)', 'FontSize', 14);
    xlabel('x', 'FontSize', 14);
    ylabel('y', 'FontSize', 14);
    set(gca, 'FontSize', 14);
    hold off;
end
end % demo
