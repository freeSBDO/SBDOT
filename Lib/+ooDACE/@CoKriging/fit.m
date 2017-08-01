%> @file "@CoKriging/fit.m"
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
%>	
%> samples/values are (columnwise!) cell arrays.
%> {1} is cheap data ... more expensive ... {end} is most expensive
%> NOTE: though only 2 datasets are supported atm (length of samples/values must be 2)
% ======================================================================
function this = fit( this, samples, values )

% process data for underlying Kriging class
this = this.setData( samples, values );

%% useful constants
t = length(samples);

% check if this a refit and if a dataset hasn't been changed
%> @note Allow to update the CoKriging model with new data:
%> - this means no scaling as the scaling changes when new data arrives (we
%> inherit from BasicGaussianProcess)
%> - no refitting with the same hyperparameters (no xval calculation)
if ~isempty( this.GP )

    start = 1;
    while start <= length(this.GP) && ...
           all( size(this.getSamplesIdx(start)) == size(this.GP{start}.getSamples()) ) && ...
           all( all( this.getSamplesIdx(start) ==  this.GP{start}.getSamples() ) )
        start = start + 1;
    end
else
    start = 1;
    
    this.GP = cell(t,1);
    this.rho = cell(t-1,1);
end

%% determine parameters for each dataset
for i=start:t
    samples{i} = this.getSamplesIdx(i);
    values{i} = this.getValuesIdx(i);

    options = this.options;
    % modif_cdu, cell for options HL or LF :
    options.hpBounds = this.options.hpBounds{ i };
    options.hpBounds = this.options.hpBounds{ i };
    options.hpLikelihood = this.options.hpLikelihood{ i };
    options.reinterpolation = this.options.reinterpolation{ i };
    options.lambda0 = this.options.lambda0{ i };
    options.lambdaBounds = this.options.lambdaBounds{ i };
    
    % use the right Optimizer for this sub-GP (if multiple are given)
    if iscell( options.hpOptimizer )
        options.hpOptimizer = options.hpOptimizer{i};
    end
    
    if i == 1
        options.rho0 = -Inf; % disable rho MLE estimation for the first (i==1) sub-GP
        
        d = values{i};
    else
        % rho
        yc = this.GP{i-1}.predict( samples{i} ); % yc unscaled
        d = [values{i} yc]; % note: watch scaling of both entries!
        
        % rho is predicted by the likelihood of the second sub-GP
        % another possible solution is to use least squares, but this gives bad results
        % this.rho{i-1} = abs(yc) \ abs(values{i});
        % d = values{i} - this.rho{i-1} .* yc;
    end
    % modif_cdu, cell for hyperparameters0 :
    this.GP{i} = ooDACE.BasicGaussianProcess(options, this.hyperparameters0 {i}, this.regressionFcn{i}, this.correlationFcn{i});
    this.GP{i} = this.GP{i}.fit(samples{i}, d);
    
    if i > 1
        this.rho{i-1} = this.GP{i}.getRho();
    end
end % end for every dataset

%% concatenate some things

% degrees matrix (only keep track of one, as they are all the same for every GP. As assumed by Kennedy & O'Hagan)
this.regressionFcn = this.GP{end}.regressionFunction();

% create full regression model matrix
F = this.regressionMatrix();

% concatenate the hyperparameters
hp = {        0 this.GP{1}.getSigma() this.GP{1}.getProcessVariance() this.GP{1}.getHyperparameters() ;
    this.rho{1} this.GP{2}.getSigma() this.GP{2}.getProcessVariance() this.GP{2}.getHyperparameters()};

% fit model
this = this.updateModel( F, hp );

% set the correct sigma2
this.sigma2 = this.rho{1}.*this.rho{1}.*this.GP{1}.getProcessVariance() + this.GP{2}.getProcessVariance();

this = this.cleanup();

end
