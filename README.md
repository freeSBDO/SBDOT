# Surrogate Based Design Optimization Toolbox

---

MATLAB Toolbox for metamodeling and solving optimization problem. 
The function to surrogate and optimize can be evaluated from an external numerical simulator.

> Author : **Cédric Durantin**

General informations
--

Metamodeling features :

* Kriging (gaussian process based surrogate model)
* Radial Basis Function
* Co-kriging (multifidelity)
* CoRBF (multifidelity)
* BQQV Kriging (for qualitative variables)

Optimization features :

* CMAES (constrained single objective)
* NSGA-II (constrained multiobjective)
* MGDA (unconstrained multiobjective)

Adaptive Sampling strategy :

* Expected improvement (constrained global optimization)
* Gutmann criterion (constrained global optimization)
* Expected hypervolume improvement (multiobjective)
* Robust efficient global optimization

