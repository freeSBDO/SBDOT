%> @file "@BasicGaussianProcess/plotLikelihood.m"
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
%>	h = plotLikelihood(this, func, param, perf)
%
% ======================================================================
%> For debugging (or paper) purposes
%>
%> Creates contour plot of likelihood over the hyperparameter bounds.
%> If the dimension is higher than two, unplotted hyperparameter values are set fixed to their optimized values.
% ======================================================================
function h = plotLikelihood(this, func, param, perf)

    %% hardcoded options
    % accuracy of the debug plot
    density = 20;
    
    % plots the last 2 hp dimensions instead of the first two
    reversePlotDims = false;    
    
    % show likelihood derivatives for loss functions that support it
    switch func2str(this.options.hpLikelihood)
        case {'marginalLikelihood' 'pseudoLikelihood'}
            showDerivatives = true;
        otherwise
            showDerivatives = false;
    end
	
    %%
    allBounds = {this.options.rhoBounds this.options.lambdaBounds this.options.sigma2Bounds this.options.hpBounds};
    bounds = allBounds(:,this.optimIdx);
    bounds = cell2mat( bounds );
    
    optimDim = size(bounds,2);
	plotDim = min( optimDim, 2 ); % MAX 2D plot
    
    if reversePlotDims
        idx = [zeros(1,optimDim-plotDim) ones(1,plotDim)];
    else
        idx = [ones(1,plotDim) zeros(1,optimDim-plotDim)];
    end
    idx = logical(idx);
    
	hp = cell(plotDim, 1);
	for i=1:plotDim
		hp{i} = linspace( bounds(1,i), bounds(2,i), density );
	end
	
    grid = makeEvalGrid( hp(:) );
    [n m] = size(grid);
	lik = zeros( n, 1 );
	dlik = zeros( n, optimDim );
    for i=1:size(grid,1)
		
		p(:,idx) = grid(i,:);
        p(:,~idx) = param(:,~idx);
		if showDerivatives
			[lik(i,:) dlik(i,:)] = func( p );
        else
			lik(i,:) = func( p );
		end
		
        if mod( i, 20 ) == 0
            buffer = sprintf('Iteration %i of %i', i, size(grid,1) );
            disp( buffer );    
        end
            
    end
    
    % grid minimum
    [gridminimum gridIdx] = min( lik );
        
    % plot
    if optimDim == 1
        plot( grid, lik, 'r-' );
        hold on;
        plot( grid(gridIdx), func( grid(gridIdx) ), 'bx' );
        
        if showDerivatives
            plot( grid, dlik,'r:');
        end
        
    elseif optimDim >= 2
        % likelihood: objective + derivatives
        opts = plotScatteredData();
        opts.contour = true;
        opts.plotPoints = false;
        h = plotScatteredData( [grid lik], opts );
        hold on;

        if showDerivatives
            dlik = dlik(:,idx);
            quiver(grid(:,1),grid(:,2),dlik(:,1),dlik(:,2),'k');
        end
        
        plot(grid(gridIdx,1), grid(gridIdx,2),'gx','Markerfacecolor','g');
        param= param(:,idx);
        plot(param(:,1), param(:,2), '*', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
    else
        error('Likelihood plots not supported for dim > 2 (this error shouldn''t happen).');
    end
    gridminimum
    grid(gridIdx,:)

end
