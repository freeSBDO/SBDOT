%> @file "@BasicGaussianProcess/cvpe.m"
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
%>	out = cvpe(this)
%
% ======================================================================
%> Error function used is the Mean Squared Error (MSE)
%>
%> Papers:
%> - "Blind Kriging: A New Method for Developing Metamodels",
%>      V.R. Joseph and Y. Hung and A. Sudjianto,
%>      ASME Journal of Mechanical Design, 2008
%> - "Predictive Approaches for Choosing Hyperparameters in Gaussian Process",
%>      S. Sundararajan, S.S. Keerthu, 1999
% ======================================================================
function out = cvpe(this)

	n = size(this.values, 1);
	
	% for CVPE
    %F2 = this.C * this.Ft;
	%FFinv2 = inv(F2'*F2);
	%H2 = F2*FFinv2*F2';

	% C*Ft = F
    F = this.C * this.Ft;
	FF = F.' * F;
	H = (F / FF) * F.'; 

	residual=this.values(this.P,:)-F*this.alpha; % residual
	

    % original iterative procedure
	% iterate over each sample
    %{
    cv2 = zeros(n, size(this.alpha,2) );
    Cn2=inv( this.C*this.C' );
	for i=1:n
		a2 = residual(i,:) ./ (1-H(i,i));
		tn2 = (residual+H(:,i)*a2);
		
		Qn2 = Cn2(i,:)*tn2;
		cv2(i,:) = Qn2 ./ Cn2(i,i);
    end
    %}
    
    % vectorised version + avoid inverse
    % but needs for-loop for multiple outputs
    out = zeros(1,size(residual,2));
    for i=1:size(residual,2)
        a = residual(:,i) ./ (1-diag(H));
        tn = (repmat(residual(:,i),1,n)+H.*repmat(a',n,1));
        Qn = diag( this.C'\(this.C\tn) );
        cv = Qn ./ diag(this.C'\inv(this.C));
        out(:,i) = sum(cv.^2)./n;
    end
    
	%% Derivatives (analytical)
	%{
	% values = calculated as above a=.../H...
	if nargout > 1
		for j=1:length(dpsi)
			dpsiCurr = dpsi{j} + dpsi{j}';
			rj = -Cn * dpsiCurr * Cn * values;
			
			dout(1,j) = 0;
			for i=1:n
				sji = Cn(:,i)' * dpsiCurr * Cn(:,i);
				
				dout(1,j) = 1 + 1;
			end
			
		end
	end
	%}
	
end
