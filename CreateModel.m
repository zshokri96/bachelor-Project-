function model = CreateModel()
    u  	= [15 15 20 25 25 25 25 30 30 30 30 35 35 35 40 25 25 25 30 30 30 40 15 15 20 20 20 20 30 35 15 25 40 40 40];
	tp 	= [03 03 03 02 02 02 02 02 02 02 02 01 01 01 01 02 02 02 02 02 01 01 03 03 03 03 03 03 02 01 03 02 01 01 01];
	ep  = [03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03];
    d  	= [10 11 15 11 17 14 14 10 14 15 15 14 14 15 17 11 14 17 14 14 15 10 14 11 11 11 11 14 14 14 14 14 14 17 17];
    
    n 	= numel(u);
    
    ot  = [105 105];
    m 	= numel(ot);
    
    a 	= 0.1;
    
    MaxItc 		= 2;
    MaxIt 		= 10; %1000
	EliteSize 	= 3;
    SimIt       = 1000;
    
    model.u 	= u;
	model.tp 	= tp;
    model.ep    = ep;
	model.d 	= d;
    model.n 	= n;
    model.m 	= m;
    model.a 	= a;
    model.ot    = ot;
    model.MaxItc = MaxItc;
    model.MaxIt = MaxIt;
    model.EliteSize = EliteSize;
    model.SimIt = SimIt;
end