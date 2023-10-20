function [SolE2] = Mutate(SolE1)
    
    M=randi([1 2]);
    
    switch M
        case 1
            SolE2=DoSwap(SolE1);
            
        case 2
            SolE2=DoReversion(SolE1);
    end
    
end

