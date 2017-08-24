function grad_shared = Get_grad_shared( obj, grad_matrix, options )
% Compute the shared descent direction of multiple gradient
%
% matrix of gradient of the m_y objectives (m_x-by-m_y)
%
% All variables are extracted named as the INRIA report :
% Révision de l'algorithme MGDA par orthogonalisation hiérarchique
% HAL_id : hal-01139994, version 1
% equations are referred by eq. and page by p.
% Here grad_matrix is the u variable.

% grad is a n-by-m matrix, with n the number of gradient and m the dimension of the input space
[ m, m_y ] = size( grad_matrix );
assert( m == obj.m_x, ...
    'MGDA:get_grad_shared', ...
    'The dimension of the gradient matrix is wrong');

if nargin<3
    options.scaling=0;
else
    if ~isfield(options,'scaling'), options.scaling=0; end
end

% Scaling procedure if specified p.6
if options.scaling == 1;
    
    for i = 1 : m
        s(i,:) = max( abs( min(grad_matrix(i,:))), abs( max(grad_matrix(i,:)) ) ...
                    );
    end
    S = diag(s);
    g = S \ grad_matrix; % care / is not \
    
else
    
    g = grad_matrix;
    
end

r_max = min( m, m_y ); % Maximum rank

i_permute = 1 : m_y;

% Select first vector basis
for j=1:m_y;
    
    g_act = g(:,j);
    g_diff = g;
    g_diff(:,j) = [];
    k_int(j,:) = min( g_act'*g_diff ./ (g_act'*g_act) );
    
end

[ ~, k ] = max( k_int ); %k-index, eq.2 p.7
[ g, i_permute ] = obj.Permute_info( k, 1, i_permute, g );

v = g( :, 1 ); % first vector of the orthogonal basis

% Orthogonalisation
C = zeros( m_y, m_y );
C(1,1) = 1; % triangular matrix for orthogonalization process

% Algorithme 1 p.8
r = 1; % Initial rank of the basis
mu = m_y; % Number of vectors with a shared descent direction
j = 2; % loop index on r_max from 2

flag_orthogonalisation = 0; % Flag for the whole algorithme 1

while flag_orthogonalisation == 0
    
    % Update C-matrix
    % Step 1
    C( j:mu, j-1 ) = ( g(:,j:mu)' * v(:,j-1) ) ./ ( v(:,j-1)' * v(:,j-1) );
    C( j:mu, j:mu ) = C( j:mu, j:mu ) + diag( C(j:mu,j-1) );
    % Step 2
    flag_step2 = 0; % Flag for second while loop
    while flag_step2 == 0
        [ ~, l ] = min( diag( C(j:mu,j:mu) ) ); % Smallest cumulative sum index
        l = l + j - 1; % get real index for the m_y vectors
        
        if C(l,l) >= 1 - obj.TOL % descent direction condition
            
            a = C(l,l); % constant value
            flag_orthogonalisation = 3; % exit
            flag_step2 = 3; % exit
            
        else % Build the next orthogonal vector for the basis
            
            [ g, i_permute, C ] = obj.Permute_info( j, l, i_permute, g, C);
            A = 1 - C(j,j);
            C(j,j) = A;
            
            for i_sum = 1 : j-1
                prod_vect(:,i_sum) = ( C(j,i_sum) * v(:,i_sum) );
            end
            
            v(:,j) = ( g(:,j) - sum(prod_vect,2) ) / C(j,j); % new orthogonal vector
            vj_norm = v(:,j)' * v(:,j); % its norm
            
            % if vj null or inferior to TOL
            if vj_norm <= obj.TOL
                
                flag_step2 = 0; % back to the beginning of the step 2 while
                [ g, i_permute, C ] = obj.Permute_info( j, mu, i_permute, g, C );
                mu = mu-1; % update number of vectors with a shared descent direction
                
                if j>mu
                    flag_orthogonalisation = 3; %exit
                    flag_step2 = 3; %exit
                end
                
            else
                flag_step2 = 1; % back to the beginning of the orthogonalisation while loop
            end
            
        end
        
    end
    
    % no exit then back to the beginning of the first while loop
    if flag_orthogonalisation ~= 3
        
        r = r+1; % update rank
        j = j+1; % update loop index
        
    end
    
    if j > r_max
        flag_orthogonalisation = 2;
    end
    
end

% Smallest element of the convex hull p.9
for i_sum = 1 : r
    norm_v( i_sum ) =  v(:,i_sum)' * v(:,i_sum) ; % norm of basis vectors
end

omega = zeros(m,1); % Smallest element of the convex hull

for j=1:r;
    
    beta(j) = 1 ./ ( norm_v(j) * sum(1./norm_v) );
    omega = omega + beta(j) * v(:,j);
    
end

G = g(:,1:r);
V = v(:,1:r);

%alpha=linsolve(G,omega);

Delta = diag(norm_v); % p.16

warning('off','MATLAB:singularMatrix')
warning('off','MATLAB:nearlySingularMatrix')

W = (G'*G) \ ( G'*V*(Delta\V') );
%W=pinv(G'*G)*(G'*V*(Delta\V')); % new basis matrix defined eq.8 p.17

warning('on','MATLAB:singularMatrix')
warning('on','MATLAB:nearlySingularMatrix')

if any( isnan(W) ) 
    % W singular to working precision
    Pareto_stat = true;
else
    %p.17
    for j = 1:m_y;
        
        % gradients in the new basis
        eta(:,j) = W * g(:,j); 
        % avoid  numerical errors
        eta( abs(eta(:,j)) < 1e-4, j ) = 0; 
        % check pareto stationarity condition
        Pareto_stat(j) = all( eta(:,j) < -1e-8 ); 
        % check if the direction is shared by all gradients
        Family_add(j) = any( eta(:,j) < -1e-8 );         
    end
    
end

if ~all( Pareto_stat ) % if the pareto stationarity condition is not fulfilled
    if any( Family_add ) % if the direction is not shared by every vector p.23 (an example)
        
        add_vect_loc = find(Family_add);
        add_vect = eta(:,add_vect_loc(1));
        G = [ G g(:,add_vect_loc(1)) ];
        % Quadratic programming p.13 and example p.24
        H = [ eta(1:r,1:r) add_vect;add_vect'  add_vect'*add_vect ];
        f = zeros(r+1,1);
        Aeq = ones(1,r+1);
        beq = 1;
        A = [];
        b = [];
        lb_quadprog = zeros(r+1,1);
        ub_quadprog = ones(r+1,1);
        option_quadprog = optimoptions('quadprog','Display','off');
        warning('off','optim:quadprog:HessianNotSym')
        x = quadprog(H,f,A,b,Aeq,beq,lb_quadprog,ub_quadprog,[],option_quadprog); % quadratic programming
        warning('on','optim:quadprog:HessianNotSym')
        
    else
        
        % Quadratic programming p.13 and example p.24 without adding a new vector in the basis
        H = eta(1:r,1:r);
        f = zeros(r,1);
        Aeq = ones(1,r);
        beq = 1;
        A = [];
        b = [];
        lb_quadprog = zeros(r,1);
        ub_quadprog = ones(r,1);
        option_quadprog = optimoptions('quadprog','Display','off');
        warning('off','optim:quadprog:HessianNotSym')
        x = quadprog(H,f,A,b,Aeq,beq,lb_quadprog,ub_quadprog,[],option_quadprog); % quadratic programming
        warning('on','optim:quadprog:HessianNotSym')
        
    end
    
    omega_star = G * x; % canonical basis
    %omega_tilde=[eta(1:r,1:r) add_vect]*x; % new basis
    grad_shared = W' * (W*omega_star); % shared descent direction
    %grad_shared_tilde=W'*omega_tilde; % shared descent direction in new basis
else
    grad_shared = zeros(m,1); % Pareto stationarity
end

end