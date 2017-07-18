%> @file "buildVandermondeMatrix.m"
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
%>	[m dm] = buildVandermondeMatrix( samples, degrees, baseFunctions )
%
% ======================================================================
%> @brief Build multidimensional Vandermonde like matrix for interpolation
%> and/or evaluation of multidimensional polynomials.
% ======================================================================
function [m, dm] = buildVandermondeMatrix( samples, degrees, baseFunctions )

if 0
	m = mxVandermondeMatrix( samples, degrees, baseFunctions );
else
	
	[n,dim] = size(samples);
	[ndegrees,dim2] = size( degrees );
	assert( dim==dim2, 'Dimension mismatch' );
	
	m = ones(n,ndegrees);
    if nargout > 1
        % NOTE: only possible for 1 sample
        dm = ones(dim,ndegrees); 
    end
	for i=1:dim
        % evaluate basis functions for i'th variable upto max degree
		baseValues = feval( baseFunctions{i}, samples(:,i), max([0; degrees(:,i)]) );
        
        % copy and repmat the baseValues in the right positions
		m = m .* baseValues(:,degrees(:,i).'+1);
    end
end
