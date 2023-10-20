clear; clc; close all;

model	= CreateModel();
S_GRASP = GRASP(model);
S_SPR   = GA(); 



n		= model.n;     % number of jobs
m		= model.m;	  % number of machines
SimIt	= model.SimIt;

EXP = [15 15 20 25 25 25 25 30 30 30 30 35 35 35 40];
ERL = [5 5 5 10 10 7 10;5 5 5 3 3 5 6 ];
UNI = [10 10 15 15 15 15 25 30;20 20 25 25 25 25 35 40];
WBL = [2.5 12.5 5/3 5/3 5/3;1/3 1/2 1/4 1/4 1/4];
    
for Its = 1:SimIt
    clc
    disp(['Simulation Progress ' num2str(100*(Its/1000)) ' %'])
	for i = 1:15
		time(i) = exprnd(EXP(i));
    end
 	for i=1:7
         time(i+15) = exprnd(ERL(1,i))*ERL(2,i);
    end
    for i=1:8
         time(i+22) = UNI(1,i)+(UNI(2,i)-UNI(1,i))*rand(1,1);
    end
    for i=1:5
         time(i+35) = wblrnd(WBL(1,i),WBL(2,i));
    end
    
    %
	sim_GRASP(Its).seq = S_GRASP.seq;
	for k = 1:m
		t      = 0;
        number = 0;
		for i = 1:n
			if (sim_GRASP(Its).seq(k,i) ~= 0)
				sim_GRASP(Its).Tstart(sim_GRASP(Its).seq(k,i))	= t;
				t                					= t + time(sim_GRASP(Its).seq(k,i));
                number                              = number + 1;
			end
		end
		sim_GRASP(Its).Ttot(k)	= t;
        sim_GRASP(Its).num(k)  = number;
	end
	sim_GRASP(Its).f	= Cost(model,time,sim_GRASP(Its));
    sim_GRASP(Its).n   = n;
    sim_GRASP(Its).m   = m;
    sim_GRASP(Its).t   = time;
    
    %
    sim_SPR(Its).seq = S_SPR.seq;
	for k = 1:m
		t      = 0;
        number = 0;
		for i = 1:n
			if (sim_SPR(Its).seq(k,i) ~= 0)
				sim_SPR(Its).Tstart(sim_SPR(Its).seq(k,i))	= t;
				t                					= t + time(sim_SPR(Its).seq(k,i));
                number                              = number + 1;
			end
		end
		sim_SPR(Its).Ttot(k)	= t;
        sim_SPR(Its).num(k)  = number;
	end
	sim_SPR(Its).f	= Cost(model,time,sim_SPR(Its));
    sim_SPR(Its).n   = n;
    sim_SPR(Its).m   = m;
    sim_SPR(Its).t   = time;
    
end

COST_GRASP      = zeros(1,SimIt);
COST_SPR        = zeros(1,SimIt);
GRASP_Better    = zeros(1,SimIt);
SUM_TIME        = zeros(1,SimIt);
for i = 1:SimIt
    COST_GRASP(i) = sim_GRASP(i).f;
	COST_SPR(i)   = sim_SPR(i).f;
    if (COST_GRASP(i) < COST_SPR(i))
        GRASP_Better(i) = 1;
    end
    
    SUM_TIME(i) = sum(sim_GRASP(i).t);
end

close all;
figure
plot(COST_GRASP);
hold on
plot(COST_SPR,'r');
hold on
plot(SUM_TIME/100,'g');
title('Costs, Grasp Blue,SPR Red')
