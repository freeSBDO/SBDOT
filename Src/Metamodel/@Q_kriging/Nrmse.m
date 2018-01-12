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



% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


