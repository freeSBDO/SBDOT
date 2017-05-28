%> @file "@BasicGaussianProcess/fit.m"
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
%>	this = fit( this, samples, values )
%
% ======================================================================
%> Need to be invoked before calling any of the prediction methods.
% ======================================================================
function this = fit( this, samples, values )

    %% store data (can be overrided, e.g., Kriging does a scaling before storing)
    this = this.setData( samples, values );

    %% useful constants
    [n, p] = size(this.samples); % 'number of samples' 'dimension'

    %% Preprocessing

    % Calculate Sigma covariance matrix if it is not included in the MLE
    if ~this.optimIdx(1,this.LAMBDA)
        
        % stochastic kriging
        if ~isempty( this.options.Sigma )
            this.Sigma = this.options.Sigma;
        else
            % add a small number to ease ill-conditioning
            this.Sigma = (n+10)*eps;
        end

        o = (1:n)';
        this.Sigma = sparse( o, o, this.Sigma);
    end

    %% Regression matrix preprocessing
    % modif_cdu, commented :
    %if this.options.regressionMaxLevelInteractions > p
    %    warning('regressionMaxLevelInteractions is larger than the number of dimensions.');
    %    this.options.regressionMaxLevelInteractions = p;
    %end

    if ischar( this.regressionFcn )

        % easy to use + compatible with DACE toolbox
        switch this.regressionFcn
            case ''
                dj = []; % no regression function (constant=0)
            case 'regpoly0'
                dj = 0; % constant
            case 'regpoly1'
                dj = [0 ; 1]; % constant + linear terms
            case 'regpoly2'
                dj = [0 ; 1 ; 2]; % constant + linear + quadratic interactions
            case 'regpoly3'
                dj = [0 ; 1 ; 2 ; 3]; % all the above + cubic interactions
            case 'regpoly4'
                dj = [0 ; 1 ; 2 ; 3 ; 4]; % all the above + quartic interactions
        end

        this.regressionFcn = this.generateDegrees( dj );
    end

    % Construct model matrix F
    F = this.regressionMatrix( this.samples );
    
    % if sigma2 is included in hyperparameter optimization, guess initial value if it is Inf/NaN
    if this.optimIdx(:,this.SIGMA2) && ...
       isinf(this.options.sigma20)
        % inital extrinsic variance = variance of ordinary regression residuals
        % From stochastic kriging paper
        alpha = (F'*F)\(F'*this.values);
        this.options.sigma20 = log10(var(this.values-F*alpha));
    end

    %% Correlation matrix preprocessing

    % (no for loop):
    % calculate i,j indices
    nSamples = 1:n;
    idx = nSamples(ones(n, 1),:);
    a = tril( idx, -1 ); % idx
    b = triu( idx, 1 )'; % idx
    a = a(a~=0); % remove zero's
    b = b(b~=0); % remove zero's
    distIdxPsi = [a b];

    % calculate manhattan distance
    dist = this.samples(a,:) - this.samples(b,:);

    % NOTE: double=8 bytes, 500 samples 
    % a/b is 1 mb each... idx is 2 mb
    % . a/b and idx reside in memory but are not used anymore -> CLEAR
    % only needed is distIdxPsi (2 mb) and dist (2 mb)
    clear a b idx

    this.dist = dist; % Sample inter-distance
    this.distIdxPsi = distIdxPsi; % indexing needed for psiD

    % set initial hyperparameters (if not already set)
    % Generating hyperparameters0 should be done by BasisFunctions (need BF
    % classes for that)
    if this.options.generateHyperparameters0
        % From stochastic kriging paper
        % make correlation = 1/2 at average distance
        switch func2str(this.correlationFcn)
            case 'ooDACE.basisfunctions.corrgauss'
                avg_dist = mean(abs(this.dist));
                this.hyperparameters0 = (log(2)/p)*(avg_dist.^(-2));
            case 'ooDACE.basisfunctions.correxp'
                avg_dist = mean(abs(this.dist));
                this.hyperparameters0 = (log(2)/p)*(avg_dist.^(-1));
            otherwise
                this.hyperparameters0 = 10.^0.5*ones(1,this.optimNrParameters(end));
        end
        this.hyperparameters0 = log10(this.hyperparameters0);
    end
    
    % tune hyperparameters
    if isempty( this.hyperparameters )
        hp = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};
        if ~isempty( this.options.hpOptimizer ) % no optimization
            % use internal optimizer
            [this, optimHp] = this.tuneParameters(F);
            
            hp(1,this.optimIdx) = mat2cell( optimHp, 1, this.optimNrParameters );
        % else fixed hp (or optimized from the outside)
        end
    else
        % for xval AND rebuildBestModels (samples changes, model parameters
        % stay the same
        hp = {this.getRho log10(this.getSigma()) log10(this.sigma2) this.getHyperparameters()};
    end

    % Construct model
    this = this.updateModel(F, hp);

    % NOTE: some variables can now be cleared from memory by calling cleanup()
    %> @note Kriging can't do a cleanup automatically, if needed cleanup() can be called manually.
end
