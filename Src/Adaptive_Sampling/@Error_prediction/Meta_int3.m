function func_val = Meta_int3(obj, x, y, z )
%META_INT2 Summary of this function goes here
%   Detailed explanation goes here

[n1,n2]=size(x);

x = reshape(x,n1*n2,1);
y = reshape(y,n1*n2,1);
z = reshape(z,n1*n2,1);

if obj.m_y >= 1
    [~,func_val] = obj.meta_y.Predict([x,y,z]);
end
if obj.m_g >= 1
    [~,func_val] = obj.meta_g.Predict([x,y,z]);
end
          
func_val = reshape(func_val.^2,n1,n2);

end

