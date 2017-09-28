function err = Nrmse( obj, x_test, y_test )
    % NRMSE compute the mean normalized (regarding amplitude) RMSE over the
    % level-combinations
    %
    %   Inputs:
    %       x_test a cell containing the continuous values on which the
    %       nrmse is computed (same format as in obj.prob.x). Every cells
    %       must contains at least one point for the nrmse to make sense.
    %       y_test a cell containing the responses on which the
    %       nrmse is computed (same format as in obj.prob.y). Every cells
    %       must contains at least one point for the nrmse to make sense.
    %       obj an object of class Q_kriging
    %
    %   Output:
    %       err the NRMSE
    %
    % Syntax :
    % err = nrmse( obj, x_test, y_test );
    
    num_x = cellfun(@(k) size(k,1), x_test);
    q_test = cell2mat(arrayfun(@(k) k*ones(num_x(k),1), 1:length(num_x), 'UniformOutput', false)');
    p = obj.Predict(cell2mat(x_test'),q_test);
    p = mat2cell(p, num_x)';
    err = mean(arrayfun(@(k) sqrt(sum((p{k}-y_test{k}).^2)/length(y_test{k}))/abs(max(y_test{k})-min(y_test{k})), 1:length(num_x)));
    
end