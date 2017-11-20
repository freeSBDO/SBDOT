function [ y_pred ] = Prediction( obj, x )
% PREDICTION
% use for min_current search

y_pred = obj.meta_y.Predict(x);

constraint_distance_current(:,:) = sum(abs(bsxfun(@minus,permute(x,[3 2 1]),obj.prob.x)).^2,2);

constraint_distance = obj.beta_n * obj.delta_mm - max(min(constraint_distance_current,[],1));

y_pred( any(constraint_distance > 0, 2), : ) = nan( sum(any( constraint_distance > 0, 2 )), 1 );

if obj.m_g >= 1
    for i = 1 : obj.m_g
        g_pred(:,i) = obj.meta_g(i).Predict(x);
    end
    y_pred( any(g_pred > 0, 2), : ) = nan( sum(any( g_pred > 0, 2 )), 1 );
end

end

