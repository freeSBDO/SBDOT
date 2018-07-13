function [ f_min, x_min , iter ,f_call,x_hist]=steepest_slope_step_opt(functname,x_k,lb,ub)
% Newton's Method
%   Optimizer using gradient information from finite-difference
%   Hessian matrix is approximated using finite-difference 
%   Step optimization is an option
%
%   functname = string of the function to optimize
%   -> for exemple functname='branin'
%   x_k = initial point of the optimization (row vector)
%   -> for exemple x_k = [1,1]
%   lb = lower bound of optimization
%   -> for exemple lb = [0,0]
%   ub = upper bound of optimization
%   -> for exemple ub = [2,2]
%   step_opt = 1 or 0 for optimized step or not
%
%
%   f_min = minimum output of the optimized function
%   x_min = input value of the optimum
%   iter = number of iterations needed
%   f_call = number of function calls needed
%   x_hist = stored input at each iteration


% Variable initialization
h=1e-3; % Step for finite-difference calculation
epsilon=1e-4; % Convergence criterion limit value
dim=size(x_k,2); % Size of the input space
convergence_criterion=1; % Initial value of the convergence criterion (initial value doesn't matter if it's upper than epsilon)
f_call=0; % Function calls 
iter=0; % Number of iterations

H=diag(repmat(h,1,dim)); %diagonal matrix with step values

input_lb=find(x_k<=lb+h); % check if input is outside or close to lower bound
input_up=find(x_k>=ub-h );% check if input is outside or close to upper bound
x_k(input_lb)=lb(input_lb)+h; % re-assign inside bound values
x_k(input_up)=ub(input_up)-h;% re-assign inside bound values
% the real bound are [lb+h ub-h] in order to be sure that finite difference calculation is inside bound
 
x_H_table=bsxfun(@plus,x_k,[[0,0];H]); % input for finite difference calculation
y_H_table=feval(functname,x_H_table); % output for finite difference calculation
f_call=f_call+length(y_H_table); %update function calls

% k refers to the index of the current iteration, kn means the index of the next iteration

y_k=y_H_table(1); % Intial point evaluation x_k
y_finite_diff_k=y_H_table([2,3]); % for gradient approximation

finite_diff_k=(1/h)*(y_finite_diff_k-y_k); %gradient from finite difference

g_lb=find(x_k-lb==0 & finite_diff_k'>0);
g_ub=find(x_k-ub==0 & finite_diff_k'<0);
finite_diff_k([g_lb,g_ub])=0;
% If gradient direction is going outside bound and we are already at bound, kill it !

while convergence_criterion>epsilon % Main loop

        
    iter=iter+1; %update iteration
        
    search_direction=-finite_diff_k; % Caution!! \ means inv(Hessian)*finite_diff_k

    s_lb=find(x_k<=lb+h & search_direction'<0);
    s_ub=find(x_k>=ub-h & search_direction'>0);    
    search_direction([s_lb,s_ub])=0;
    % If search direction is going outside bound and we are already at bound, kill it !

    if norm(search_direction)<epsilon % avoid too big search interval
        corde_b=[0 10];
    else
        corde_lb_mat=((lb+h-x_k)./search_direction');
        corde_ub_mat=((ub-h-x_k)./search_direction');
        corde_lb_ind=corde_lb_mat>0;
        corde_ub_ind=corde_ub_mat>0;
        corde_b=[0 min([corde_lb_mat(corde_lb_ind) corde_ub_mat(corde_ub_ind)])];
        % step upper bound calculation
    end
    
    [optimized_step,~,~,f_call_step]=feval('section_dor',corde_b,'pas_opt',functname,x_k,search_direction'); % Optimize the step for gradient descent
    f_call=f_call+f_call_step; %update function calls with function calls needed during step optimization
       
    
    x_kn=x_k+optimized_step*search_direction'; % update x_kn value
    
    % check if x_kn is outside bound
    input_lb=find(x_kn<=lb+h);
    input_up=find(x_kn>=ub-h );
    x_kn(input_lb)=lb(input_lb)+h;
    x_kn(input_up)=ub(input_up)-h;
    
       
    x_H_table=bsxfun(@plus,x_kn,[[0,0];H]); % input for finite difference calculation
    y_H_table=feval(functname,x_H_table); % output for finite difference calculation
    f_call=f_call+length(y_H_table); %update function calls

    % f(x_kn) evaluation
    y_kn=y_H_table(1);

    
    y_finite_diff_kn=y_H_table([2,3]); % for gradient approximation
    finite_diff_kn=(1/h)*(y_finite_diff_kn-y_kn); %gradient from finite difference
    

    % Convergence criterion estimation
    convergence_criterion=norm(x_kn-x_k);
    
    finite_diff_k=finite_diff_kn;
    x_k=x_kn;
    x_hist(iter,:)=x_kn;
    
end %end while

f_min=y_kn;
x_min=x_kn;


end % end function

