.gk.d1:{[S;K;t;v;rd;rf]
    (log(S%K)+((rd-rf+(v xexp 2))%2)*t)%
    v*sqrt(t); 
  }

.gk.d2:{[S;K;t;v;rd;rf]
    .gk.d1[S;K;t;v;rd;rf]-(v*sqrt(t))
  }

.gk.c.price:{[S;K;t;v;rd;rf]
    ((S*exp(neg rf*t))*.math.ncdf[.gk.d1[S;K;t;v;rd;rf]])-
    ((K*exp(neg rd*t))*.math.ncdf[.gk.d2[S;K;t;v;rd;rf]])
  }

.gk.p.price:{[S;K;t;v;rd;rf]
    ((K*exp(neg rd*t))*.math.ncdf[.gk.d2[S;K;t;v;rd;rf]])-
    ((S*exp(neg rf*t))*.math.ncdf[neg .gk.d1[S;K;t;v;rd;rf]])
  }

.gk.c.delta:{[S;K;t;v;rd;rf]
    .math.ncdf[.gk.d1[S;K;t;v;rd;rf]]*exp(rf-t)
  }

.gk.p.delta:{[S;K;t;v;rd;rf]
    .math.ncdf[neg .gk.d1[S;K;t;v;rd;rf]]*neg exp(rf-t)
  }

.gk.c.gamma:{[S;K;t;v;r]
    (exp(neg rf*t)*.math.ndc[.bs.d1[S;K;t;v;r]])%((S*v)*sqrt(t))
  }

.gk.p.gamma::.gk.c.gamma
