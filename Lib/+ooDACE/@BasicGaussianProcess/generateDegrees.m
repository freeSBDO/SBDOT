%> @file "@BasicGaussianProcess/generateDegrees.m"
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
%>	[degrees usedIdx] = generateDegrees( this, dj )
%
% ======================================================================
%> Generates a (full) degree matrix based on one or more degree matrices for variable j
%> The option 'regressionMaxLevelInteractions' determines the maximum level of interactions (BasicGaussianProcess::getDefaultOptions)
% ======================================================================
function [degrees, usedIdx] = generateDegrees( this, dj )

    % NOTE: dirthy hack for blind kriging, get dim using dj, otherwise assume this.samples is not empty
    
    % preprocessing
    if ~iscell( dj )
        dim = size(this.samples,2);
        
        % special case: pure GP (zero trend)
        if isempty( dj )
            degrees = zeros(0, dim);
            usedIdx = [];
            return;
        end
        
        dj(1,:) = []; % remove constant (automatically included later on.)
        template = dj;
        
        this.options.regressionMaxOrder = repmat( size( dj, 1 ), dim, 1 );
        dj = cell(dim,1);
        for i=1:dim
            dj{i} = zeros( this.options.regressionMaxOrder(i,:), dim );
            dj{i}( :, i ) = template;
        end
    else
        dim = length(dj);
    end
    
    %% Some sort of Kronecker product, generating every possible row combination
    
    % initialize degree matrix
    O = max( this.options.regressionMaxOrder );
    I = this.options.regressionMaxLevelInteractions;
    nrTerms = factorial(dim) ./ (factorial(I) .* factorial(dim-I));
    if dim == I %>< @note hack for 1D >linear trends.
        nrTerms = 0;
    end
    nrTerms = nrTerms .* O^I + dim.*O + 1;
    
    degrees = zeros(nrTerms, size(dj{1}, 2));
    freeIdx = 2; % next free spot in degrees. Constant is already included.
    
    count = size(dj{1}, 1 );
    degrees(freeIdx:freeIdx+count-1,:) = dj{1};
    freeIdx = freeIdx + count;
    
    usedIdx = cell(dim-1,1);
    
    % 'kronecker' loop
    for i=2:dim

        % degrees 1:
        useIdx = sum(degrees(1:freeIdx-1,:) > 0, 2) < this.options.regressionMaxLevelInteractions;
        degrees1 = degrees(useIdx,:);

        % degrees 2:
        degrees2 = dj{i};

        % generate idx'ces
        idx1 = 1:size(degrees1, 1);
        idx1 = idx1( ones(size(degrees2, 1),1), : );
        idx1 = idx1.';
        idx1 = idx1(:);

        idx2 = 1:size(degrees2, 1);
        idx2 = idx2( ones(size(degrees1, 1), 1), : );
        idx2 = idx2(:);

        count = size(idx1, 1 );
        degrees(freeIdx:freeIdx+count-1,:) = degrees1(idx1,:) + degrees2(idx2,:);
        freeIdx = freeIdx + count;
        
        usedIdx{i-1} = useIdx;
    end
    
end
