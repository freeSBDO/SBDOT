%> @file "@BasicGaussianProcess/updateModel.m"
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
%>	this = updateModel( this, F, hp )
%
% ======================================================================
%> Full update of the model (regression + correlation part)
% ======================================================================
function this = updateModel( this, F, hp )

	%% correlation
	[this, err] = this.updateStochasticProcess( hp );
	if ~isempty( err )
		error(['BasicGaussianProcess:updateModel:' err '(updateStochasticProcess)']);
	end
	
	%% regression (get least squares solution)
	[this, err] = this.updateRegression( F, hp );
    if ~isempty( err )
        error(['BasicGaussianProcess:updateModel:' err '(updateRegression)']);
    end
    
    %% reinterpolation (Forrester2006)
    % modif_cdu, cell : 
    if iscell(this.options.reinterpolation)
        if this.options.reinterpolation{1} || this.options.reinterpolation{2}
            this.C_reinterp = chol( this.C*this.C' - this.Sigma )';
            
            this.Ft_reinterp = this.C_reinterp \ F(this.P,:); % T1
            [~, this.R_reinterp] = qr(this.Ft_reinterp,0);
        end
    else
        if this.options.reinterpolation
            this.C_reinterp = chol( this.C*this.C' - this.Sigma )';
            
            this.Ft_reinterp = this.C_reinterp \ F(this.P,:); % T1
            [~, this.R_reinterp] = qr(this.Ft_reinterp,0);
        end
    end

    %% What is needed for prediction
    % polynomial part: alpha
    % correlation part: gamma, hyperparameters, corr func
    % for prediction variance: sigma2, C, R, Ft
end
