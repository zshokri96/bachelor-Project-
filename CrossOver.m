function [SolE3,SolE4] = CrossOver(SolE1,SolE2)
    
    [x ,~] = size(SolE1);
    cross = randi([1 x]);
    
    SolE3 = [SolE1(1:cross,:);SolE2(cross+1:end,:)];
    SolE4 = [SolE2(1:cross,:);SolE1(cross+1:end,:)];
    
end

