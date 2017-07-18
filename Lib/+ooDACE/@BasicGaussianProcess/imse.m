%> @file "@BasicGaussianProcess/imse.m"
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
%>	out = imse( this )
%
% ======================================================================
%> Only supported for 1D and 2D problems.
%> Papers:
%> - See Sacks 1989
%> - See pechiny paper...
% ======================================================================
function out = imse( this )

    samples = this.getSamples(); % need original samples
    [~, inDim] = size(samples);
    
    lb = min( samples );
    ub = max( samples );
    
    if inDim == 1
        func = @(xMatrix) integrand(this, xMatrix);

        if exist('integral', 'file') % Matlab 2012
            out = integral( func, lb, ub );
        else 
            out = quadv( func, lb, ub );
        end
    elseif inDim == 2
        func = @(xMatrix, yMatrix) integrand(this, xMatrix, yMatrix);
        
        if exist('integral2', 'file') % Matlab 2012
            out = integral2( func, lb(1), ub(1), lb(2), ub(2) );
        elseif exist('quad2d', 'file') % Matlab 2009
            out = quad2d( func, lb(1), ub(1), lb(2), ub(2) );
        else % Matlab 2008 or older
            func = @(xMatrix, yMatrix) integrand(this, xMatrix, yMatrix(1,ones(size(xMatrix,2),1)));
            
            out = dblquad( func, lb(1), ub(1), lb(2), ub(2), '1e-3' );
        end
    elseif inDim == 3
        func = @(xMatrix, yMatrix, zMatrix) integrand(this, xMatrix, yMatrix, zMatrix);
        
        if exist('integral3', 'file') % Matlab 2012
            out = integral3( func, lb(1), ub(1), lb(2), ub(2), lb(3), ub(3) );
        else
            func = @(xMatrix, yMatrix, zMatrix) integrand(this, xMatrix, yMatrix(1,ones(size(xMatrix,2),1)), zMatrix(1,ones(size(xMatrix,2),1)));
            
            out = triplequad( func, lb(1), ub(1), lb(2), ub(2), lb(3), ub(3), '1e-3' );
        end
    else
        %> @todo Implement generic monte carlo integration
        error( 'BasicGaussianProcess:imse: Not supported for input dimension > 3.' );
    end
end

% ======================================================================
%> integrand calculation
% ======================================================================
function out = integrand(varargin)
    this = varargin{1};
    
    if nargin == 2 % 1D
        xMatrix = varargin{2};
        
        x = xMatrix(:);
    elseif nargin == 3 % 2D
        xMatrix = varargin{2};
        yMatrix = varargin{3};
        
        x = [xMatrix(:) yMatrix(:)];
    elseif nargin == 4 % 3D
        xMatrix = varargin{2};
        yMatrix = varargin{3};
        zMatrix = varargin{4};
        
        x = [xMatrix(:) yMatrix(:) zMatrix(:)];
    end
    
    [~, out] = this.predict(x);
    
    out = reshape(out, size(xMatrix));
end
