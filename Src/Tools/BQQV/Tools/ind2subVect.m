function out = ind2subVect (siz,ndx)
    % IND2SUBVECT extend ind2sub native matlab function to accept parallel computing
    % 
    %   Inputs:
    %       siz is a vector corresponding to the size of the matrix of interest
    %       ndx is a vector which contains the scalar indices
    %
    %   Output:
    %       out is a matrix of size: ndx by siz, whom rows contain the corresponding subscripts
    %
    % Syntax:
    %   tau = ind2subVect(m_t, ind);

    [out{1:length(siz)}] = ind2sub(siz,ndx);
    out = cell2mat(cellfun(@transpose,out,'UniformOutput',false));
    
end