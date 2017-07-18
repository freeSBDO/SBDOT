%> @file "@BasicGaussianProcess/plotVariogram.m"
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
%>	handle = plotVariogram(this)
%
% ======================================================================
%> Plots the experimental (semi-)variogram (based on the data) as well as
%> the theoretical kriging (semi-)variogram (defined by the correlation function).
%> Empirical variogram:
%> - Methods of moments estimator Matheron (Cressie, 1993)
%> - More robust estimators: Cressie-Hawkins (1980), Genton (1998)
%> In general: use median instead of mean
% ======================================================================
function handle = plotVariogram(this)

    %% Preprocessing
    density = 20; % = nrbins

    samples = this.samples;
    values = this.values;
    [n inDim] = size(samples);

    minx = min(samples,[],1);
    maxx = max(samples,[],1);
    maxd = sqrt(sum((maxx-minx).^2));

    gamma = zeros(density, 2);

    %% experimental (semi-)variogram
    maxdist = maxd ./ 2;
    tol = maxdist ./ density;

    % input
    if isempty( this.distIdxPsi )
        % (no for loop):
        % calculate i,j indices
        nSamples = 1:n;
        idx = nSamples(ones(n, 1),:);
        a = tril( idx, -1 ); % idx
        b = triu( idx, 1 )'; % idx
        a = a(a~=0); % remove zero's
        b = b(b~=0); % remove zero's

        idx = [a b];
    else
        idx = this.distIdxPsi;
    end

    samplesDist = sqrt( sum( (samples(idx(:,1),:) - samples(idx(:,2),:)).^2, 2 ) );
    valuesDist = (values(idx(:,1),:)-values(idx(:,2),:)).^2;

    % everything bigger than maxDist is discarded
    idx = find( samplesDist > maxdist );
    valuesDist(idx,:) = [];
    samplesDist(idx,:) = [];

    % variogram function
    fvar = @(x) 1./(2*numel(x)) * sum(x);

    % distance bins
    edges = linspace(0,maxdist,density+1).';
    edges(end) = inf;

    [nedge,ixedge] = histc(samplesDist,edges);

    holdsExperimental = accumarray(ixedge,valuesDist,[numel(edges) 1],fvar,nan);

    h = (edges(1:end-1)+tol/2);
    holdsExperimental(end,:) = [];
    
    gamma(:,1) = holdsExperimental;

    %% variogram of kriging
    % This is actually a multi-dimensional variogram. Simplify it... (take slice)
    % gamma = (corrfunc(0) - corrfunc(h))
    x = repmat( h ./sqrt(inDim), 1, inDim );
    gamma(:,2) = 1 - this.correlationFcn( this.hyperparameters{1}, x);

    %% plot all variograms
    handle = gcf;
    clf; hold on;

    plot( h, gamma(:,1), 'rx', 'LineWidth', 1.5 );
    plot( h, gamma(:,2:end), 'k-', 'LineWidth', 2 );

    % experimental nugget
    nugget = gamma(1,1);
    plot( h, nugget, 'k--', 'LineWidth', 1.5 );

    xlabel( 'h', 'Fontsize', 14, 'Interpreter', 'tex' );
    ylabel( '\gamma(h) (semi-variogram)', 'Fontsize', 14, 'Interpreter', 'tex' );
    axis([0 maxdist 0 max(holdsExperimental)*1.1]);
    set(gca,'Fontsize', 14);
    legend( {'Experimental variogram', ...
            sprintf( 'Kriging''s variogram (%s)', func2str( this.correlationFcn ) )}, ...
            'Fontsize', 14, 'Interpreter', 'tex', 'Location', 'NorthWest' );
    
end