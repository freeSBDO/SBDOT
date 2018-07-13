function yc = borehole_LF(xc)

rw = xc(:,1);
r  = xc(:,2);
Tu = xc(:,3);
Hu = xc(:,4);
Tl = xc(:,5);
Hl = xc(:,6);
L  = xc(:,7);
Kw = xc(:,8);


frac1 = 5 * pi .* Tu .* (Hu-Hl);

frac2a = 2.*L.*Tu ./ (log(r./rw).*rw.^2.*Kw);
frac2b = Tu ./ Tl;
frac2 = log(r./rw) .* (1.5+frac2a+frac2b);

yc = frac1 ./ frac2;

end
