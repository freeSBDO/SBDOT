function [x_min,f_min,iter,f_call]=section_dor(x0,functname,varargin1,varargin2,varargin3)

f_call=0;
low=x0(1);
up=x0(2);
%epsilon=min(abs(up-low)/2,1e-6);
epsilon=1e-4;
golden=(2/(1+sqrt(5)));
iter=0;

a=low+(1-golden)*(up-low);
b=low+golden*(up-low);

if isempty(varargin1)
    y_a=feval(functname,a);
    y_b=feval(functname,b);
    f_call=f_call+2;
else
    y_a=feval(functname,a,varargin1,varargin2,varargin3);
    y_b=feval(functname,b,varargin1,varargin2,varargin3);
    f_call=f_call+2;
end

while (abs(up-low)>epsilon || (y_a==Inf  && y_b==Inf))
    iter=iter+1;
    if y_a<y_b
        
        up=b;                
        b=a;
        y_b=y_a;
        a=low+(1-golden)*(up-low);
        if isempty(varargin1)
            y_a=feval(functname,a);
            f_call=f_call+1;
        else
            y_a=feval(functname,a,varargin1,varargin2,varargin3);
            f_call=f_call+1;
        end
    elseif y_a>y_b
        
        low=a;
        a=b;
        y_a=y_b;
        b=low+golden*(up-low);
         if isempty(varargin1)
            y_b=feval(functname,b);
            f_call=f_call+1;
        else
            y_b=feval(functname,b,varargin1,varargin2,varargin3);
            f_call=f_call+1;
        end
    elseif y_a==y_b
        up=b;
        b=a;
        a=low+(1-golden)*(up-low);
        if isempty(varargin1)
            y_a=feval(functname,a);
            f_call=f_call+1;
        else
            y_a=feval(functname,a,varargin1,varargin2,varargin3);
            f_call=f_call+1;
        end
        
        
    end %end if
end %end while

if y_a<y_b
    x_min=a;
    f_min=y_a;
else
    x_min=b;
    f_min=y_b;
end

end %end function