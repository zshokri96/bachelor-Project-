function GRASP_S = GRASP(model)
	%% Definitions 
	
	u  = model.u;
	tp = model.tp;
	d  = model.d;
	n  = model.n;    % number of jobs
	a  = model.a;
	m  = model.m;	  % number of machines
	
	MaxItc    = model.MaxItc;
	MaxIt     = model.MaxIt;
	EliteSize = model.EliteSize;
	%%
	% c 
	% unscheduled jobs in row 1 
	% temp min cost of adding job to partial solutions in row 2
	% corresponding machine of job j in row 3
	c = zeros(3,n); 
	c(1,:) = (1:n);
	
	s      = CreateSolution(m,n);
	costs =[];
	%%
	% GRSP Construction Phase
	for Itc = 1:MaxItc
        
		while  numel(c(1,:)) ~= 0
			for i = 1 : numel(c(1,:)) 
				j = c(1,i);
				
				for k = 1:m
					gj(k)= g(model,s.Ttot(k),j);
					if k == 1 
						min_gj   	 = gj(k);
						k_min_gj 	 = k;
					else 
						if gj(k) < min_gj
							min_gj 	 = gj(k);
							k_min_gj = k;
						end
					end
				end
				
				c(2,i)	= min_gj;
				c(3,i)	= k_min_gj;
			end
			
			c = sortrows(c.',2).';
			
			RC_size = max (1, floor(a * numel(c(1,:)))); 
			r = (floor(rand(1) * RC_size)) + 1;
			jr = c(1,r);
			kr = c(3,r);
			
			
			s.num(kr)           = s.num(kr) + 1;
			s.seq(kr,s.num(kr)) = jr;
			s.Ttot(kr)          = s.Ttot(kr) + u(jr);
			s.Tstart(jr)        = s.Ttot(kr);
			
			c(:,r) = [];
		end
		s.f = CostFunc(model,s);
        costs = [costs,s.f];
		%%
		% GRASP Improvement Phase
		
		min_f_SwapN 		= CostFunc(model,s);
		min_f_SwapN_s   	= s;
		min_f_InsertN 		= CostFunc(model,s);
		min_f_InsertN_s   	= s;
		
		EliteCnt  = 0;
		EliteWorst.f = 0;
		for It = 1: MaxIt
			for (job1 = 1:n)
				for (job2 = 1:n)
					SwapN(job1,job2)   		= Swap(model,s,job1,job2);
					SwapN(job1,job2).f 		= CostFunc(model,SwapN(job1,job2));
					
					if job1 == 1 && job2 ==1 
						min_f_SwapN     	= SwapN(job1,job2).f;
						min_f_SwapN_s   	= SwapN(job1,job2);
					else
						if SwapN(job1,job2).f < min_f_SwapN
							min_f_SwapN     = SwapN(job1,job2).f;
							min_f_SwapN_s   = SwapN(job1,job2);
						end
					end  
				end
			end  
			
			for (job = 1:n)
				for (k = 1:m)
					for (i = 1: s.num(k))
						InsertN(job,k,i) 		= MyInsert(model,s,job,k,i);
						InsertN(job,k,i).f      = CostFunc(model,InsertN(job,k,i));
					
						if (job == 1) && (k == 1) && (i==1)
							min_f_InsertN           = InsertN(job,k,i).f;
							min_f_InsertN_s         = InsertN(job,k,i);
						else
							if InsertN(job,k,i).f < min_f_InsertN
								min_f_InsertN       = InsertN(job,k,i).f;
								min_f_InsertN_s     = InsertN(job,k,i);
							end
						end
					end  
				end
			end
			
			CheckElint = 0;
			if min_f_SwapN < min_f_InsertN 
                
                costs = [costs,min_f_SwapN];
				if min_f_SwapN < s.f
					s   = min_f_SwapN_s;
					s.f = min_f_SwapN;
					CheckElint = 1;
				end
            else
                
                costs = [costs,min_f_InsertN];
				if min_f_InsertN < s.f
					s   = min_f_InsertN_s;
					s.f = min_f_InsertN;
					CheckElint = 1;
				end
			end
			
			if (CheckElint == 1) 
				Repeated 	 = 0;
				if (EliteCnt < EliteSize)
					if (EliteCnt > 0) 
						for i = 1:EliteCnt
							if (E(i).seq == s.seq) 
								Repeated = 1;
							end
						end
					end
					if (Repeated == 0)
						EliteCnt        = EliteCnt + 1;
						E(EliteCnt)     = s;
						E(EliteCnt).f   = s.f;
						if (s.f > EliteWorst.f)
							EliteWorst.f 	= s.f;
							EliteWorstIndex = EliteCnt;
						end
					end
				else
					if (s.f < EliteWorst.f) 
						for i = 1:EliteSize
							if (E(i).seq == s.seq) 
								Repeated = 1;
							end
						end
						if (Repeated == 0)
							E(EliteWorstIndex)     = s;
							E(EliteWorstIndex).f   = s.f;
							EliteWorst.f 		   = 0;
							for i = 1:EliteSize
								if E(i).f > EliteWorst.f
									EliteWorst.f 	= E(i).f;
									EliteWorstIndex = i;
								end
							end
						end
					end
				end
			end
        end
    end 
    
	figure
    plot(costs,'LineWidth',2)
    title('Improvements on Constructed Solution');
    xlabel('Iteration');
    ylabel('Cost');
	
	%%
	%Path Relinking
	for i = 1:EliteSize
		for j = 1:EliteSize
			if (i ~= j)
				if E(i).f > E(j).f
					ES = E(i);
					ES.f = E(i).f;
					SInd = i;
					ED = E(j);
					ED.f = E(j).f;
					DInd = j;
				else
					ES = E(j);
					ES.f = E(j).f;
					SInd = j;
					ED = E(i);
					ED.f = E(i).f;
					DInd = i;
				end
				
				first = 1;
				for (k = 1:m)
				
					while (ES.num(k) ~= ED.num(k)) 
						if(ES.num(k) > ED.num(k))
							ES = MyInsert(model,ES,ES.seq(k,ES.num(k)),k+1,ES.num(k+1)+1); %put the last job in the machine k sequnece in the end of machine k+1 sequence
							ES.f = CostFunc(model,ES);
							
							if (first == 1) 
								first  = 0;
								minS   = ES;
								minS.f = ES.f;
							else 
								if (ES.f < minS.f)
									minS   = ES;
									minS.f = ES.f;
								end
							end
						else
							ES = MyInsert(model,ES,ES.seq(k,ES.num(k+1)),k,ES.num(k)+1); %put the last job in the machine k+1 sequnece in the end of machine k sequence
							ES.f = CostFunc(model,ES);
							
							if (first == 1) 
								first  = 0;
								minS   = ES;
								minS.f = CostFunc(model,ES);
							else 
								if (ES.f < minS.f)
									minS   = ES;
									minS.f = CostFunc(model,ES);
								end
							end
						end
					end
					for(l=1:n)
						if (ES.seq(k,l) ~= ED.seq(k,l))
							ES = Swap(model,ES,ES.seq(k,l),ED.seq(k,l));
							ES.f = CostFunc(model,ES);
							
							if (first == 1) 
								first  = 0;
								minS   = ES;
								minS.f = CostFunc(model,ES);
							else 
								if (ES.f < minS.f)
									minS   = ES;
									minS.f = CostFunc(model,ES);
								end
							end
						
						end
					end
                end 
				if (minS.f <  E(SInd).f)
					E(SInd) = minS;
					E(SInd).f = CostFunc(model,minS);
				end
			end
		end
	end
	
	BestE   = E(1);
	BestE.f = E(1).f;
	for i = 1:EliteSize
		if (E(i).f < BestE.f)
			BestE   = E(i);
			BestE.f = E(i).f;
		end
	end	
	
	BestE.seq;
	BestE.f;
    
 %%
GRASP_S = BestE;
end