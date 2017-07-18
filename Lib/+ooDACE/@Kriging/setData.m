%> @file "@Kriging/setData.m"
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
%>	this = setData(this, samples, values)
%
% ======================================================================
%> Scales samples and values, passing the scaled dataset to the underlying base method.
% ======================================================================
function this = setData(this, samples, values)

    this.samples = samples;
    this.values = values;
    
    [n m] = size(samples); % 'number of samples' 'dimension'

    %% Normalize samples and values
    % Kriging is more efficient when data is normally distributed (also reduces
    % outliers)
    if isempty( this.inputScaling ) % && isempty( this.outputScaling) && isempty(this.hyperparameters)
        % first fit
        inputAvg = mean(samples);
        inputStd = std(samples);

        outputAvg = mean(values);
        outputStd = std(values);

        samples = (samples - inputAvg(ones(n,1),:)) ./ inputStd(ones(n,1),:);
        values = (values - outputAvg(ones(n,1),:)) ./ outputStd(ones(n,1),:);

        this.inputScaling = [inputAvg; inputStd];
        this.outputScaling = [outputAvg; outputStd];
    else
        % subesequent fittings: scale data using previous settings (for xval)
        samples = (samples - this.inputScaling(ones(n,1),:)) ./ this.inputScaling(2.*ones(n,1),:);
        values = (values - this.outputScaling(ones(n,1),:)) ./ this.outputScaling(2.*ones(n,1),:);
    end
    
    this = this.setData@ooDACE.BasicGaussianProcess( samples, values );
end
