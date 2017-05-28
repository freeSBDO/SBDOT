%> @file "@Kriging/getExpression.m"
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
%>	expression = getExpression( this, outputIndex )
%
% ======================================================================
%> Example:
%> expression = getExpression( this )
% ======================================================================
function expression = getExpression( this, outputIndex )

    %% get scaled expression
    expression = this.getExpression@BasicGaussianProcess( outputIndex );
    
    %% transform
    precision = '%.30g';
    
    % apply input scaling (samples are already in unscaled space)
    for i=1:size(this.inputScaling,2)
        var = ['((x' num2str(i) '-' sprintf(precision,this.inputScaling(1,i)) ') ./ ' sprintf(precision,this.inputScaling(2,i)) ')'];

        pat = sprintf( 'x%i', i ); % replace variable xi
        rep = sprintf( '%s', var ); % with scaled variable xi
        expression = regexprep(expression, pat, rep);
    end

    % apply output scaling
    expression = [sprintf(precision,this.outputScaling(1,outputIndex)) '+' sprintf(precision,this.outputScaling(2,outputIndex)) '.*(' expression ')'];
end
