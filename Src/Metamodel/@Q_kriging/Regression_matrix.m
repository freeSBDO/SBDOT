function [F, dF] = Regression_matrix( obj, points )
    % REGRESSION_MATRIX Does the regression part of the fit during Fit
    % method for Q_kriging objects
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       points are the sample values in the DoE
    %
    %   Output:
    %       F is the vandermonde matrix of the regression
    %       dF is F derivative
    %
    % Syntax :
    % [F, dF] = obj.Regression-matrix( points );
    
    [n, dim] = size(points);

	% standard implementation
    F = ooDACE.tools.buildVandermondeMatrix( points, obj.regpoly, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
    
    % the (pseudo) derivative of F
    % limited to one point at a time
    % returns dF with the rows being the derivative of each dimension and
    % the columns the actual terms of the derived function multiplied by
    % their coefficient.
    if nargout > 1
        assert( n == 1, 'Derivative of the regression matrix supports only one point at a time.' );
        
        dF = zeros(obj.prob.m_x,size(obj.regpoly,1));
        for i=1:obj.prob.m_x
            % derive i'th variable
            dRegressionFcn = obj.regpoly;
            dRegressionFcn(:,i) = max( dRegressionFcn(:,i) - 1, 0 );
            
            dF(i,:) = ooDACE.tools.buildVandermondeMatrix( points, dRegressionFcn, ooDACE.tools.cfix( @ooDACE.tools.powerBase, dim ) );
            
            % multiply by their powers (if power == 0 then result is zero as expected)
            dF(i,:) = dF(i,:) .* obj.regpoly(:,i).';
        end
    end
end
