function [this, xmin, fmin] = optimize(this, arg )

if isa( arg, 'Model' )
    func = @(x) evaluate(arg,x);
else % assume function handle
    func = arg;
end

[LB, UB] = this.getBounds();
pop = this.getInitialPopulation();
this.opt.LBounds = LB;
this.opt.UBounds = UB;

% Actually run the the optimization routine
[xmin,fmin] = cmaes( func, pop, [], this.opt );

end
