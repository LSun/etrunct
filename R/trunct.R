# These functions for computing moments of truncated t
# are based on results in O'Hagan, Biometrika 1973

ibeta = function(x,a,b){ pbeta(x,a,b)*beta(a,b) } #incomplete beta function

# function G from O'Hagan
G = function(r, v, q){
  p=v/(v+q^2)
  res = ifelse(q>0 | (r %% 2 != 0),
               ibeta(p,0.5*(v-r),0.5*(r+1)),
  2*beta(0.5*(v-r),0.5*(r+1)) - ibeta(p,0.5*(v-r),0.5*(r+1)))
  return(res)
}

# expectation of T^r when T has truncated t distribution on v df truncated at left by q
e_trunct_onesided = function(q,v,r){
  v^(0.5*r) * G(r,v,q)/G(0,v,q)
}

#' Compute moments of univariate truncated t distribution
#' @details This function computes the $r$th moment of the univariate t distribution on v degrees of freedom,
#' truncated to the interval (a,b). If parameters are vectors then the r[i]th moment is computed for each (a[i],b[i],v[i])
#' The methods are based on results in O'Hagan, Biometrika 1973 and work for v>r. Otherwise NaN is returned.
#' @param a the left end(s) of the truncation interval(s)
#' @param b the right end(s) of the truncation interval(s)
#' @param v the degrees of freedom of the t distribution
#' @param r the degree of moment to compute
#'
#' @examples
#'  e_trunct(-3,3,3,2) # second moment of t distribution on 2df truncated to (-3,3)
#'  e_trunct(-3,3,3,1) # first moment of same, should be 0
#'
#'  e_trunct(c(-3,0),c(0,0),4,2) # the function is vectorized
#'
#' @export
e_trunct = function(a,b,v,r){
  mult=ifelse(a>0 & b>0,-1,1) # calculations more stable for negative
  #a and b, but in this case need to multiply result by (-1)^r
  aa = ifelse(a>0 & b>0, -b, a)
  bb = ifelse(a>0 & b>0, -a, b)

  mult^r * ifelse(aa==bb,aa^r,
         (pt(aa,v,lower.tail=FALSE)*e_trunct_onesided(aa,v,r) -
              pt(bb,v,lower.tail=FALSE)*e_trunct_onesided(bb,v,r))/(pt(bb,v)-pt(aa,v)))
}

