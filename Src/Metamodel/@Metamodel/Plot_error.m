function [  ] = Plot_error( obj, x, y, q )
% PLOT_ERROR 
%   Plot error diagram using a test dataset
%   *x is a n_eval by m_x matrix
%   *y is the output evaluated at x, n_eval by 1 matrix
%   *q is the index or the subscript of the level-combination (obj of class Q_kriging)
%
% Syntax :
% []=obj.plot_error(x,y);
% []=obj.plot_error(x,y,q);

% Checks
assert( size(y,2) == 1,...
    'SBDOT:plot_error:OutputSize',...
    'The dimension of the output test dataset must be n_eval-by-1')

if strcmpi(class(obj), 'Q_kriging')
    
    y_pred = obj.Predict( x, repmat(q,size(x,1),1) );
    
else
    
    y_pred = obj.Predict( x );
    
end

min_y = min( min( y_pred ), min( y ) );
max_y = max( max( y_pred ), max( y ) );

figure
hold on
plot(y_pred,y,'ko')
plot([min_y max_y],[min_y max_y],'k-')
xlabel('prediction')
ylabel('real value')
title('Error plot of metamodel prediction')
axis([min_y max_y min_y max_y])
box on
hold off

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


