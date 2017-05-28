%> @file "averageEuclideanError.m"
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
%>	e = averageEuclideanError( a,b )
%
% ======================================================================
%> @brief Computes the average euclidean error (AEE) between a (true) and b (predicted).
%>
%> From: Rong Li and Zhanlue Zhao, Evaluation of estimation algorithms part I: incomprehensive measures of
%> performance, IEEE Transactions on Aerospace and Electronic Systems, vol. 42, no. 4, pp. 1340-1358, 2006
% ======================================================================
function e = averageEuclideanError( a,b )

    %e = (1/size(a,1)) .* sum(sqrt((a - b).^2),1);

    % remember this must also work for complex data
    e = (1/size(a,1)) .* sum(sqrt((a-b).* conj(a-b)),1);
end