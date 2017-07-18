%> @file "makeEvalGrid.m"
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
%>	evalgrid = makeEvalGrid( gridpoints, gridsize )
%
% ======================================================================
%> @brief Low-level procedure, makes a `prod(gridsize)' by `length(gridsize)'
%>	array, where each row is a different vector, where the i'th
%>	element is a number out of `gridpoints{i}'.
%>
%>	The `gridsize' parameter may be omitted, in that case it's generated
%>	from `gridpoints'.
%>	This function produces grids in the expected order, which is now also
%>	used for gridded dataset files. Use this instead of
%>	makeEvalGridInverted if possible.
%>
%>	Example:
%>	makeEvalGrid( { [-1, .5], [-1 0 1], [.2 .3] }, [2 3 2] )
%>	ans =
%>	-1.0000    -1.0000     0.2000
%>	-1.0000    -1.0000     0.3000
%>	-1.0000     0.0000     0.2000
%>	-1.0000     0.0000     0.3000
%>	-1.0000     1.0000     0.2000
%>	-1.0000     1.0000     0.3000
%>	0.5000    -1.0000     0.2000
%>	0.5000    -1.0000     0.3000
%>	0.5000     0.0000     0.2000
%>	0.5000     0.0000     0.3000
%>	0.5000     1.0000     0.2000
%>	0.5000     1.0000     0.3000
% ======================================================================
function evalgrid = makeEvalGrid( gridpoints, gridsize )

dimension = length(gridpoints);

if nargin == 1
	gridsize = zeros(dimension,1);
	for i=1:dimension
		gridsize(i) = length(gridpoints{i});
	end
else
	for i=1:dimension
		assert( length(gridpoints{i}) == gridsize(i), '[E] Parameter conflict' )
	end
end

evalgrid = makeGrid( gridsize(:) );

for i=1:dimension
	tmp = gridpoints{i}( evalgrid(:,i) );
	evalgrid(:,i) = tmp(:);
end
