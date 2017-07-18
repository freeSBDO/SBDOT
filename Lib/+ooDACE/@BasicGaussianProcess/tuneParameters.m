%> @file "@BasicGaussianProcess/tuneParameters.m"
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
%>	[this optimHp perf] = tuneParameters( this, F )
%
% ======================================================================
%> Setups and invokes the optimizer
% ======================================================================
function [this, optimHp, perf] = tuneParameters( this, F )

% modif_cdu, commented :
%[n, p] = size(this.samples); % 'number of samples' 'dimension'

func = @(optimParam) likelihood( this, F, optimParam );

allParam = {this.options.rho0 this.options.lambda0 this.options.sigma20 this.hyperparameters0};
allBounds = {this.options.rhoBounds this.options.lambdaBounds this.options.sigma2Bounds this.options.hpBounds};

% select only variables and bounds of variables that we optimize
initialPopulation = cell2mat( allParam(:,this.optimIdx) );
bounds = cell2mat( allBounds(:,this.optimIdx) );

% number of hyperparameters
dim = size( bounds, 2 );

%% Optimize
this.options.hpOptimizer = this.options.hpOptimizer.setDimensions( dim, 1 );
this.options.hpOptimizer = this.options.hpOptimizer.setInitialPopulation( initialPopulation  );
this.options.hpOptimizer = this.options.hpOptimizer.setBounds( bounds(1,:), bounds(2,:) );
[this.options.hpOptimizer, pop, opvalue] = optimize( this.options.hpOptimizer, func );

% boundary check (=nice hint to the user when bounds are too small)
% modif_cdu, commented :
%lbCheck = abs(bounds(1,:) - pop(1,:));
%ubCheck = abs(bounds(2,:) - pop(1,:));
%if any( min( lbCheck, ubCheck ) < eps )
%    warning('Found optimum is close to the boundaries. You may try enlarging the hyperparameter bounds.');
%end

% return optimum and the performance (likelihood)
optimHp = pop(1,:); % take best one (if it is a population)
perf = opvalue(1,:);

if this.options.debug
    persistent likPlot
    
    if isempty(likPlot)
        likPlot = figure;
    else
        figure(likPlot);
    end
    
    % likelihood contour plot
	this.plotLikelihood(func, optimHp, perf);
    title( [func2str(this.options.hpLikelihood) ' plot'], 'FontSize', 14 );

    % initial population and minimum
	plot(pop(2:end,1), pop(2:end,2),'ko','Markerfacecolor','r');
	hold off
    
    optimHp
    perf

	%disp('Press a key to continue...');
	%pause;
end

end
