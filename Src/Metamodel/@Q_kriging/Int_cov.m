function Sigma = Int_cov ( obj )
    % INT_COV computes the intrinsic covariance matrix
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %
    %   Output:
    %       Sigma is the (usually) sparse intrisic covariance matrix
    %
    % Syntax :
    % Sigma = obj.Int_cov();
    
  if obj.optim_idx(:,obj.REG)
      
    n = size(cell2mat(obj.samples'), 1);
    o = (1:n)';

    reg = 10.^obj.hyp_reg( ones(n,1), 1 );
    Sigma = sparse( o, o, reg );
    
  else
      
    Sigma = obj.Sigma;
    
  end

end