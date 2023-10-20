function NewS = Swab(model,s,job1,job2)
    n      = s.n;
    m      = s.m;
    
    seq    = s.seq;
    
    num    = zeros(m,1);
    Ttot   = zeros(m,1); 
    Tstart = zeros(1,n);
    f      = 0;
    
   for (k = 1:m)
       for(i = 1:n)
         if seq(k,i) == job1
             k1 = k;
             i1 = i;
         end
         if seq(k,i) == job2
             k2 = k;
             i2 = i;
         end
       end
   end
   
   seq (k1,i1) = job2;
   seq (k2,i2) = job1;
   
    for (k = 1:m)
       t      = 0;
       number = 0;
       for (i = 1:n)
           if (seq(k,i) ~= 0)
                Tstart(seq(k,i)) = t;
                t                = t + model.u(seq(k,i));
                number           = number + 1;
           end
       end
       Ttot(k)                  = t;
       num(k)                   = number;
   end
   
   
   NewS.seq    = seq;
   NewS.num    = num;
   NewS.Ttot   = Ttot;
   NewS.Tstart = Tstart;
   NewS.f      = f;
   NewS.n      = n;
   NewS.m      = m;
end