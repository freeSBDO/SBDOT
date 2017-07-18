function Ind = sub2indVect( siz, Sub )
    % SUB2INDVECT extend sub2ind native matlab function to accept parallel computing
    % 
    %   Inputs:
    %       siz is a vector corresponding to the size of the matrix of interest
    %       sub is a vector which contains row subscripts
    %
    %   Output:
    %       Ind is a vector of scalar index
    %
    % Syntax:
    %   Ind = sub2indVect ( siz, Sub );
    
    Sub = num2cell(Sub);
    Ind = arrayfun(@(i) sub2ind(siz, Sub{i,:}), 1:size(Sub, 1));
    
end