%> @file "@BasicGaussianProcess/regressionFunction.m"
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
%>	[regressionFcn expression terms] = regressionFunction( this, options )
%
% ======================================================================
%> Example:
%> [regressionFcn expression terms] = regressionFunction( this, struct('latex', true, 'precision', '%.5g') )
% ======================================================================
function [regressionFcn, expression, terms] = regressionFunction( this, options )

    %% degrees matrix
    regressionFcn = this.regressionFcn;
    
    %% optional: the expression and individual terms corresponding to the
    %% degrees matrix
    if nargout > 1
        
        if size(regressionFcn,1) <= 0
            % GP with mean 0 (no regression function)
            expression = '0';
            terms{1} = '0';
            return;
        end
        
        %% get options
        defaults = struct('outputIndex', 1, 'latex', false, 'includeCoefficients', true, 'precision', '%.2g' );
        options = mergeStruct( defaults, options );
        
        if options.latex
            mult = ' \cdot ';
            intTerm = '%sx_{%i}^{%i}';
        else
            if options.includeCoefficients
                mult = '.*';
                
            else
                mult = '';
            end
            
            intTerm = '%sx%i.^%i';
        end

        if nargout > 2
            terms = cell( 1,size(this.regressionFcn,1) );
            terms{1} = 'OK';
        end

        if options.includeCoefficients
            num = sprintf(options.precision,this.alpha(1, options.outputIndex ));
        else
            num = '1'; % or OK
        end
        
        dim = size(this.samples, 2);
        for set=2:size(this.regressionFcn, 1)

            %% prepend term with coefficients
            if options.includeCoefficients

                % coefficient
                coeff = this.alpha(set, options.outputIndex );

                % complex coefficient
                if ~isreal(coeff)
                    coeff = [' +(' num2str(coeff) ')'];
                % real coefficient
                else
                    % positive coefficient
                    if coeff > 0
                        coeff = ['+' sprintf(options.precision,coeff)];
                    % negative coefficient
                    else
                        coeff = ['-' sprintf(options.precision,-coeff)];
                    end
                end
                coeff = [coeff mult];
            else
                coeff = '+';
            end

            %% construct term
            term = [];
            for var=1:dim
                if this.regressionFcn(set,var) > 0
                    if ~isempty(term); term = [term mult]; end
                    
                    % term = old term + power + variable number
                    term = sprintf( intTerm, term, var, this.regressionFcn(set,var) );
                end
            end

            % add term to expression if it was chosen
            num = [num coeff term];
            
            % add term to cell array
            if nargout > 2
                terms{set} = term;
            end

        end

        expression = num;
    end
end
