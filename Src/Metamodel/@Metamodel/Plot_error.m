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

