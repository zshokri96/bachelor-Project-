function NewS = MyInsert(model,s,job,machine,ind)
    n      = s.n;
    m      = s.m;
    
    seq    = s.seq;
	
    num    = zeros(m,1);
    Ttot   = zeros(m,1); 
    Tstart = zeros(1,n);
    f      = 0;
    
	job_k = 0;
	job_i = 0;
    for (k = 1:m)
       for (i = 1:n)
			if seq(k,i) == job
				job_k = k;
				job_i = i;
			end
       end
    end
    % First delete job from its machine seq
    for (i= job_i:1:n-1)
		seq(job_k,i) = seq(job_k, i+1);
    end
    seq(job_k,n) = 0;
    
	% Add job to desired location
	for (i= n:-1:ind+1)
		seq(machine,i) = seq(machine,i-1);
	end
	seq(machine,ind) = job;
	 
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