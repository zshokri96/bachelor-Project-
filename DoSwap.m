function [SolE2] = DoSwap(SolE1)
    
    
  	[n,~]=size(SolE1);
    
    i1 = randi([1 n-1]);
    i2 = randi([i1 n]);
    
    SolE2 = SolE1;
    SolE2(i1,:) = SolE1(i2,:);
    SolE2(i2,:) = SolE1(i1,:);
    
end

