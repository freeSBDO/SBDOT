function x_sampling = SLHS( obj, num_x, maximin_type, n_iter, n_threshold  )
    
    assert( length(unique(num_x)) == 1,...
            'SBDOT:Q_problem:Sliced_Sampling',...
            'When using sliced latin hypercube design, number of points should be homogeneous through slices.' );
    
    lb = obj.lb;
    ub = obj.ub;
    q  = obj.m_x;
    m  = num_x(1);
    t  = prod(obj.m_t);
    n  = m*t;
    
    if strcmpi(maximin_type, 'Monte_Carlo')
        [~, DOE] = MC_opt (n_iter, q, m, t ,n);
    else
        [~, DOE] = TH_opt (n_threshold, n_iter, q, m, t, n);
    end
    
    x_sampling = cellfun(@(k) repmat(lb,m,1) + k .*repmat(ub-lb,m,1), DOE, 'UniformOutput', false);
    
end

function A = SLHS_gen (q, m, t ,n)

    H = repmat(reshape(1:n,t,m)',q,1);
    H = mat2cell(H,m.*ones(1,q))';
    H = cellfun(@(k) SPM(k,m,t), H, 'UniformOutput', false);

    A = cell2mat(H');
    A = arrayfun(@(i) reshape(A(:,i),m,q), 1:t, 'UniformOutput', false);
    A = cellfun(@(k) (k - rand(m,q))/n , A, 'UniformOutput', false);
    
end

function H = SPM (H,m,t)

    for i = 1:m
        H(i,:) = datasample(H(i,:),t,'Replace',false);
    end
    
    for j = 1:t
        H(:,j) = datasample(H(:,j),m,'Replace',false);
    end
    
end

function [d_opt, LHS_opt] = MC_opt (n_iter, q, m, t ,n)

   LHS_opt = SLHS_gen (q, m, t ,n);
   d_opt = tril(ipdm(cell2mat(LHS_opt')),-1);
   d_opt = min(min(d_opt(d_opt>0)));
   
   for i = 1:n_iter
       
       LHS_temp = SLHS_gen (q, m, t ,n);
       d_temp = tril(ipdm(cell2mat(LHS_temp')),-1);
       d_temp = min(min(d_temp(d_temp>0)));
       
       if d_temp > d_opt
           
           d_opt = d_temp;
           LHS_opt = LHS_temp;
           
       end
       
   end

end

function [d_opt, LHS_opt] = TH_opt (n_th, n_iter, q, m, t, n)

    LHS_opt = SLHS_gen (q, m, t ,n);
    d_opt = tril(ipdm(cell2mat(LHS_opt')),-1);
    d_opt = min(min(d_opt(d_opt>0)));
    T = linspace(0.1*d_opt,0.001*d_opt,n_th);
    
    for th = T
        
        for i = 1:n_iter
            
            slice = randi([2, t],1,1);
            col = randi([1, q],1,2);
            
            LHS_temp = LHS_opt;
            LHS_temp{slice}(:,[col(1), col(2)]) = LHS_temp{slice}(:,[col(2), col(1)]);
            d_temp = tril(ipdm(cell2mat(LHS_temp')),-1);
            d_temp = min(min(d_temp(d_temp>0)));
            
            if (d_opt-d_temp) < th
           
               d_opt = d_temp;
               LHS_opt = LHS_temp;
           
            end
            
        end
        
    end
end