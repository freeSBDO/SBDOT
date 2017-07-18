function [psi, dpsi] = Ext_corr ( obj, points1,  q1, points2, q2 )
    % EXT_CORR computes the extrinsic correlation
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       points1 extrinsic points (default DoE)
    %       q1 points1 qualitative values
    %       points2 desired points to compute correlation with (default DoE)
    %       q2 points2 qualitative values
    %
    %   Output:
    %       psi is the extrinsic correlation matrix
    %
    % Syntax :
    % psi = obj.Ext_corr();
    % psi = obj.Ext_corr(points1, q1);
    % psi = obj.Ext_corr(points1, q1, points2, q2);
    
    if exist( 'points1', 'var' )
        
        P2 = true;
        
        if ~exist( 'points2', 'var' )
            
            points2 = cell2mat(obj.samples');
            P2 = false;
            
        end

        n1 = size(points1, 1); n2 = size(points2, 1);
        nPoints1 = 1:n1; nPoints2 = 1:n2;
        nPoints1 = nPoints1(ones(n2,1),:)'; nPoints2 = nPoints2(ones(n1,1),:);

        if n2 > n1
            
            nPoints2 = reshape(nPoints2,n1*n2,1);
            nPoints1 = repmat(nPoints1(:,1),n2,1);
            dist_idx_psi = [nPoints1,nPoints2];
            
        else
            
            nPoints1 = reshape(nPoints1',n2*n1,1);
            nPoints2 = repmat(nPoints2(1,:)',n1,1);
            dist_idx_psi = [nPoints1,nPoints2];
            
        end
        
        dist = points1(dist_idx_psi(:,1),:) - points2(dist_idx_psi(:,2),:);
        
        if P2
            
            q1 = q1(dist_idx_psi(:,1),:); q2 = q2(dist_idx_psi(:,2),:);
            p_tau = obj.Preproc_tau( dist_idx_psi, obj.prob.m_t, [], obj.hyp_tau', q1, q2, obj.tau_type, obj.hyp_dchol );
            
        else
            
            q1 = q1(dist_idx_psi(:,1),:);
            p_tau = obj.Preproc_tau( dist_idx_psi, obj.prob.m_t, obj.prob.n_x, obj.hyp_tau', q1, [], obj.tau_type, obj.hyp_dchol );
            
        end
        
        if nargout > 1
            
            [psi, dpsi] = obj.corr( obj.hyp_corr, dist, p_tau );
            
        else
            
            psi = obj.corr( obj.hyp_corr, dist, p_tau );            
            
        end
        
        psi = reshape(psi, n2, n1 )';
        
    else

        if nargout > 1
            
            [psi, dpsi] = obj.corr( obj.hyp_corr, obj.dist, obj.p_tau );            
            
        else
            
            psi = obj.corr( obj.hyp_corr, obj.dist, obj.p_tau );
            
        end

        if ~strcmp(obj.tau_type,'heteroskedastic')

            psi = (vect2tril(sum(obj.prob.n_x),psi,-1)+eye(sum(obj.prob.n_x)))';

        else

            psi = (vect2tril(sum(obj.prob.n_x),psi,0))';

        end
      
    end 
    
end
