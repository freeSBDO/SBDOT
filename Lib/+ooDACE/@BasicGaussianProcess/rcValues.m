%> @file "@BasicGaussianProcess/rcValues.m"
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
%>	rc = rcValues(this)
%
% ======================================================================
%> Robustness-criterion (In theory useful only for ordinary kriging).
%> Returns a 2xn matrix:
%>   - the first row contains the absolute robustness
%>   - the second row contains the relative robustness
%> Papers:
%>   - "Kriging models that are robust w.r.t. simulation errors"
%>   A.Y.D. Siem, D. den Hertog (tech report)
% ======================================================================
function rc = rcValues(this)

    rc = zeros( 2, size(this.gamma,1) );
    
    for i=1:size(this.gamma,1)
        % absolute
        rc(1,i) = norm( this.gamma(i,:), 2 ).^2;
    
        % relative
        rc(2,i) = rc(1,i) ./ norm( this.gamma(i,:), inf );
    end

end
