%> @file "@MatlabOptimizer/optimize.m"
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
%>	[this, xmin, fmin] = optimize(this, arg )
%
% ======================================================================
%> The hint 'maxTime' is supported.
% ======================================================================
function [this, xmin, fmin] = optimize(this, arg )

    if isa( arg, 'Model' )
        func = @(x) evaluate(arg,x);
    else % assume function handle
        func = arg;
    end

    % Honor hints, only supports maxTime
    this.opts = optimset(this.opts,'MaxTime', this.getHint( 'maxTime' ) );

    [LB, UB] = this.getBounds();
    pop = this.getInitialPopulation();
    
    % Actually run the the optimization routine
    if ~isempty(LB) && ~isempty(UB)
        opts = optimset(@fmincon);
        opts = optimset( opts, this.opts );
        [xmin,fmin,exitflag,output] = fmincon(func, pop, [], [], this.Aineq, this.Bineq, LB, UB, this.nonlcon, opts);
    else
        opts = optimset(@fminunc);
        opts = optimset( opts, this.opts );
        [xmin fmin exitflag output] = fminunc(func, pop, opts);
    end
    
    if this.debug
        exitflag
        output
        disp(output.message);
    end
end
