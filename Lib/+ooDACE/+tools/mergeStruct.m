%> @file "mergeStruct.m"
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
%>	o = mergeStruct( s1, s2, destFieldExist )
%
% ======================================================================
%> @brief Copies field of s2 over to s1
%>
%> @param s1 destination structure
%> @param s2 source structure
%> @param destFieldExist 
%> - -1: always copy
%> - false: only copy when destination field does NOT exist
%> - true: only copy when destination field exist
% ======================================================================
function o = mergeStruct( s1, s2, destFieldExist )

% destFieldExist can be:
% -1: always copy
% false: only copy when destination field does NOT exist
% true: only copy when destination field exist
if ~exist( 'destFieldExist', 'var' )
	destFieldExist = true;
end

fn = fieldnames(s2);
o = s1;

for n = 1:length(fn)
	
	% Always copy the field over, if it exists or not in s1
	if destFieldExist == -1
	    o.(fn{n}) = s2.(fn{n});
	else % copy the field depending on the type
		if isfield(o, fn{n} ) == destFieldExist
			o.(fn{n}) = s2.(fn{n});
		end
	end
end
