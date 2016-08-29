ODS
============
***
Outcome-dependent sampling (ODS) schemes are cost-effective ways to enhance study efficiency. In ODS designs, one observes the exposure/covariates with a probability that depends on the outcome variable. Popular ODS designs include case-control for binary outcome, case-cohort for time-to-event outcome, and continuous outcome ODS design (Zhou et al. 2002). Because ODS data has biased sampling nature, standard statistical analysis such as linear regression will lead to biases estimates of the population parameters. This package implements two statistical methods related to ODS designs: (1) An empirical likelihood method analyzing the primary continuous outcome with respect to exposure variables in continuous ODS design (Zhou et al., 2002). (2) A partial linear model analyzing the primary outcome in continuous ODS design (Zhou, Qin and Longnecker, 2011).

### Linear model in ODS ###

We assume that in the population, the primary outcome variable Y follows the linear model:
$$
Y = \beta_{0} + \beta_{1}X + \epsilon
$$
where $X$ are the covariates, and $\epsilon\sim N(0, \sigma^2)$. In continuous ODS design, a simple random sample is taken from the full cohort, then two supplemental samples are taken from tails of the $Y$ distribution, i.e. $(-\infty, \mu_{Y} - a*\sigma_{Y})$ and $(\mu_{Y} + a*\sigma_{Y}, +\infty)$. As ODS data is not a simple random sample of the overall population, naive regression analysis will yield to invalid estimates of the population parameters. Zhou et al. (2002) develops a semiparametric empirical likelihood estimator (MSELE) for conducting inference on the parameters in the linear model. 

Function **odsmle** provides the parameter estimates, and function **se.spmle** calculates the standard error for MSELE estimator.   

### Partial linear model in ODS ###
We assume that in the population, the primary outcome variable Y follows the partial linear model:
$$
E(Y|X,Z)=g(X)+Z^{T}\gamma
$$
where X is the expensive exposure, Z are other covariates. $g(\cdot)$ is an unknown smooth function. Zhou, Qin and Longnecker (2011) considers a penalized spline method to estimate the nonparamatric function $g(\cdot)$ and other regression coefficients $\gamma$ under the ODS sampling scheme. 

Function **Estimate_PLMODS** computes the parameter estimates and standard error in the partial linear model. Function **gcv_ODS** calculates the generalized cross-validation (GCV) for selecting the smoothing parameter. The details can be seen in Zhou, Qin and Longnecker (2011). 

### Package installation ###

~~~
install.packages("devtools")
devtools::install_github("Yinghao-Pan/ODS")
~~~
