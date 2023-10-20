function solution = CreateSolution(m,n)
   seq    = zeros(m,n);
   num    = zeros(m,1);
   Ttot   = zeros(m,1); 
   Tstart = zeros(1,n);
   f      = 0;
   
    
   solution.seq    = seq;
   solution.num    = num;
   solution.Ttot   = Ttot;
   solution.Tstart = Tstart;
   solution.f      = f;
   solution.n      = n;
   solution.m      = m;
end