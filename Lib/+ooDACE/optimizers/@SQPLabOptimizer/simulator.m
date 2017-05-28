%> @file "@SQPLabOptimizer/simulator.m"
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
%>	[outdic,f,ci,ce,cs,g,ai,ae] = simulator(indic, x, func, this, varargin )
%
% ======================================================================
%> Wrapper function called by SQPLabOptimizer. Sets the right parameters
%> and calls the actual cost function.
% ======================================================================
function [outdic,f,ci,ce,cs,g,ai,ae] = simulator(indic, x, func, this, varargin )

	f = []; % objective
	ci = []; % inequality constraint
	ce = []; % equality constraint
	cs = []; % state constraint
	g = []; % gradient
	ai = []; % Jacobian
	ae = []; % Jacobian

	% outdic
	%      0: the required computation has been done
	%      1: x is out of an implicit domain
	%      2: the simulator wants to stop
	%      3: incorrect input parameters
	outdic = 0; % always success

	switch indic
		case 1
			% DO NOTHING (is for debugging plots etc)
        case 2
            f = func(x);
        otherwise
			[f g] = func(x);
            g = g.'; % sqplab expects column vector
	end

end
