function objectif=pas_opt(x,functname,x0,pas)


objectif=feval(functname,x0+x.*pas);

end