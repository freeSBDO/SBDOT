function ye = borehole_HF(xe)

rw = xe(:,1);
r  = xe(:,2);
Tu = xe(:,3);
Hu = xe(:,4);
Tl = xe(:,5);
Hl = xe(:,6);
L  = xe(:,7);
Kw = xe(:,8);

frac1 = 2 * pi .* Tu .* (Hu-Hl);

frac2a = 2.*L.*Tu ./ (log(r./rw).*rw.^2.*Kw);
frac2b = Tu ./ Tl;
frac2 = log(r./rw) .* (1+frac2a+frac2b);

ye = frac1 ./ frac2;

end
