function ye = curretal_HF(xe)


x1 = xe(:,1);
x2 = xe(:,2);

fact1 = 1 - exp(-1./(2*x2));
fact2 = 2300*x1.^3 + 1900*x1.^2 + 2092*x1 + 60;
fact3 = 100*x1.^3 + 500*x1.^2 + 4*x1 + 20;

ye = fact1 .* fact2./fact3;


end
