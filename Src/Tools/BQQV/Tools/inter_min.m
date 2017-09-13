function d_min = inter_min ( x, k ,r, d )

    x = reshape(x',k,d-1);
    x = hypersph2cart( [r*ones(1,k); x'] )';
    temp = ipdm(x);
    d_min = -min( temp(logical(tril(ones(k),-1))) );

end