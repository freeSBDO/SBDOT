%> @file "@BasicGaussianProcess/correlationFunction.m"
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
%>	[correlationFcn expression] = correlationFunction( this, options )
%
% ======================================================================
%> Example:
%> [correlationFcn expression] = correlationFunction( this,struct( 'latex', true, 'includeCoefficients', false) )
% ======================================================================
function [correlationFcn, expression] = correlationFunction( this, options )

    %% correlation function handle
    correlationFcn = func2str( this.correlationFcn );
    
    %% optional: the expression corresponding to the correlation part
    if nargout > 1
        %% get options
        defaults = struct('outputIndex', 1, 'latex', false, 'includeCoefficients', true, 'precision', '%.2g' );
        options = mergeStruct( defaults, options );
        
        if options.latex
            mult = ' \cdot ';
        else
            if options.includeCoefficients
                mult = '.*';
            else
                mult = '';
            end
        end

        expression = [];
        
        % template for distance part inside correlation functions
        if strcmp( correlationFcn, 'corrgauss' )
            corrTemplate = sprintf( '- %s .* (x%%i - %s).^2', options.precision, options.precision );
        elseif strcmp( correlationFcn, 'correxp' )
            corrTemplate = sprintf( '- %s .* abs(x%%i - %s)', options.precision, options.precision );
        elseif strcmp( correlationFcn, 'corrmatern32' ) || strcmp( correlationFcn, 'corrmatern52' )
            corrTemplate = sprintf( '+ %s .* (x%%i - %s).^2', options.precision, options.precision );
        else
            desc = sprintf( 'Correlation function %s not yet supported.', correlationFcn );
            return;
        end

        hp = 10 .^ this.getHyperparameters();
        gamma = this.gamma;
        samples = this.samples;
        for set=1:size(gamma,1)

            % coefficient
            coeff = gamma(set,options.outputIndex);

            % positive coefficient
            if coeff > 0

                % append +
                if set > 1; expression = [expression '  + ']; end

                % append coefficient
                expression = [expression  sprintf(options.precision,coeff) ' '];

            % negative coefficient
            else

                % append spaces
                if set > 1; expression = [expression ' ']; end

                % append coefficient
                expression = [expression '- ' sprintf(options.precision,-coeff) ' '];
            end

            % print correlation function r(x) = R(hp, x, samples)
            if this.optimIdx(1, this.SIGMA2) % stochastic kriging
                expression = [expression mult sprintf(options.precision,this.sigma2) mult];
            else
                expression = [expression mult];
            end
            
            % build distance part of correlation function
            corrDistance = [];
            for var=1:length(hp)
                corrDistance = [corrDistance sprintf(corrTemplate, hp(var), var, samples(set,var) )];
            end
            
            if strcmp( correlationFcn, 'corrmatern32' )
                expression = [expression '(1+sqrt(3.*(' corrDistance '))) .* exp(-sqrt(3.*(' corrDistance ')))'];
            elseif strcmp( correlationFcn, 'corrmatern52' )
                expression = [expression '(1+sqrt(5.*(' corrDistance '))+5./3 .* ' corrDistance ') .* exp(-sqrt(5.*(' corrDistance ')))'];
            else % if corrgauss or correxp
                expression = [expression 'exp(' corrDistance ')'];
            end
        end

    end
end
