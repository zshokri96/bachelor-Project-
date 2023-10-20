function z = Cost(model,t,s)
    
    earliness = 0;
    tardiness = 0;
    makespan  = 0;
    
    for j = 1: model.n
       earliness = earliness + max (0, (model.d(j) - (s.Tstart(j) + t(j)))) * model.ep(j);
       tardiness = tardiness + max (0, (s.Tstart (j) + t(j)) - model.d(j))  * model.tp(j);
    end
    
    for k =1:model.m
        if (s.Ttot(k) > (8*60))
            makespan = makespan + ceil((s.Ttot(k) - (8*60)) / 60) * model.ot(k);       
        end
    end
    
    z = (earliness  + tardiness + makespan) /60;
    
end