function yc = curretal_LF(xc)

x1 = xc(:,1);
x2 = xc(:,2);

maxarg = max([zeros(length(x1),1), x2-1./20],2);

yh1 = curretal88exp([x1+1/20, x2+1/20]);
yh2 = curretal88exp([x1+1/20, maxarg]);
yh3 = curretal88exp([x1-1/20, x2+1/20]);
yh4 = curretal88exp([x1-1/20, maxarg]);


yc = (yh1 + yh2 + yh3 + yh4) / 4;

end
