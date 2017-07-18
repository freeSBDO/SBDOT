%> @file "cfix.m"
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
%>	y = cfix( x,d,err )
%
% ======================================================================
%> @brief This function ``fixes'' a cell array.
%>
%> Either a constant, a one element cell array or a length `d' cell array can be
%> passed to this function. The function will return a length
%> `d' cell array, duplicating the input if necessary
% ======================================================================
function y = cfix( x,d,err )

if length(x) ~= 1 && ( ~iscell( x ) || length(x) ~= d )
	if nargin == 3
		error( err );
	else
		error( sprintf( '[E] Either single value or list of length %d expected', d ) );
	end
end

if length(x) == 1
	if iscell(x)
		x = x{1};
	end
	y = cell(1,d);
	for i=1:d
		y{i} = x;
	end
else
	y = x;
end
