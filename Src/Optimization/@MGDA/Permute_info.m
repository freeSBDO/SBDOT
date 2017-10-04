function [ g, i_permute, C ] = Permute_info( ~, i_perm1, i_perm2, i_permute, g, C )
% PERMUTE_INFO : Permutation for MGDA multipoint algorithm
%
%   g is the gradient matrix to permute
%
%   i_perm1 is the first index for permutation
%
%   i_perm2 is the second index for permutation
%
%   i_permute is the vector with permutation index of g-matrix
%
%   C is the matrix used in the orthoganilization process
%

save_g = g(:,i_perm2);
g(:,i_perm2) = g(:,i_perm1);
g(:,i_perm1) = save_g;

i_permute_save = i_permute(i_perm1);
i_permute(i_perm1) = i_permute(i_perm2);
i_permute(i_perm2) = i_permute_save;

if nargin>5
    
    save_C = C( i_perm1, 1:i_perm1-1 );
    C( i_perm1, 1:i_perm1-1 ) = C( i_perm2, 1:i_perm1-1 );
    C( i_perm2, 1:i_perm1-1 ) = save_C;
    
    save_c = C( i_perm1, i_perm1 );
    C( i_perm1, i_perm1 ) = C( i_perm2, i_perm2 );
    C( i_perm2, i_perm2 ) = save_c;
    
end

end