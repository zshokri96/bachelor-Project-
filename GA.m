
function GA=GA()

Param = InputParameter();

[Cost,Sol] = PSC(Param);

nPop=60;     % number of population

pc=0.7;       % percent of crossover
nc=2*round(nPop*pc/2);  % number of crossover offspring

pm=1-pc;        %  percent of mutation
nm=round(nPop*pm);  % number of mutation offspring

beta=0.67;
MaxIt=50;
TournamentSize=3;

[x, y] = size(Sol);

empty_individual.Sol=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);

%% Initialization

for i = 1:nPop
    pnum = randperm(x);
    pop(i).Sol =Sol(pnum,:);
    [pop(i).Cost,~] = ResultCompute(pop(i).Sol,Param);
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;

UseRouletteWheelSelection=false;
UseTournamentSelection=false;
UseRandomSelection=false;

%% Main Loop

for it=1:MaxIt
    
    % Calculate Selection Probabilities
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    
        choice=randi([1 3]);  
        
        switch choice
            case 1
               UseRouletteWheelSelection=true;
            case 2
                UseTournamentSelection=true;
            case 3
                UseRandomSelection=true;
        end
                
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for kk=1:nc/2
        
        % Select Parents Indices
        if UseRouletteWheelSelection
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        if UseTournamentSelection
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
        end
        if UseRandomSelection
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        popc(kk,1)=p1;
        popc(kk,2)=p2;
        
        % Apply Crossover
        [Sol1,Sol2]=CrossOver(popc(kk,1).Sol,popc(kk,2).Sol);
        popc(kk,1).Sol=Sol1;
        popc(kk,2).Sol=Sol2;
        
        % Evaluate Offsprings
        [popc(kk,1).Cost,~]=ResultCompute(popc(kk,1).Sol,Param);
        [popc(kk,2).Cost,~]=ResultCompute(popc(kk,2).Sol,Param);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    for kk=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        popm(kk)=pop(i);
        
        % Apply Mutation
        [Sol2] = Mutate(popm(kk).Sol);
        
        popm(kk).Sol=Sol2;
        
        % Evaluate Mutant
        [popm(kk).Cost,~]=ResultCompute(popm(kk).Sol,Param);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm
         ];
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
    IT(it)=it;
    
    % Show Iteration Information
%      disp(['Iteration ' num2str(it) ', Best Cost = ' num2str(BestCost(it))]);
    
end
figure;
plot(IT,BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');

r1 = find(BestSol.Sol(:,1)==1);
r2 = find(BestSol.Sol(:,2)==1);
s1 = size(r1);
s2 = size(r2);
seq = zeros(2,35);
seq(1,:)= [r1', zeros(1,35-s1(1))];
seq(2,:)= [r2', zeros(1,35-s2(1))];

[x1,~] = size(r1);
[x2,~] = size(r2);

rr1 = [1:x1;r1'];
rr2 = [1:x2;r2'];

GA.seq = seq;
GA.f   = 0;
end


