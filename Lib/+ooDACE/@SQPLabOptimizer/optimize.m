%> @file "@SQPLabOptimizer/optimize.m"
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
%>	[this, x, fval] = optimize(this, arg )
%
% ======================================================================
%> This function optimizes the given function handle
% ======================================================================
function [this, x, fval] = optimize(this, arg )

    if isa( arg, 'Model' )
        func = @(x) evaluate(arg,x);
    else% assume function handle
        func = @(indic, x, varargin) simulator(indic, x', arg, this, varargin{:});
    end

    [LB UB] = this.getBounds();
    this.opts.TimeLimit = this.getHint( 'maxTime' ); % 30

    % Run it
    [x,lm,info] = sqplab( func, this.getInitialPopulation()', [], LB, UB, this.opts );

    x = x';
    fval = info.f;
end
