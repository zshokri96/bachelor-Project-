function [SolE3,SolG3] = Combine(SolE1,SolE2,PCT,Param)
    
    [x1, y1] = size(SolE1);
    [x2, y2] = size(SolE2);
    m = Param.m;
    
    for i = 1:y1
        SolE3(:,i) = SolE1(:,i) | SolE2(:,i); 
    end
    
    SolG3 =  zeros(1,m);
    
    for i = 1:y1
        a = find(SolE3(:,i)>0);
        SolG3(i) = sum(PCT(a));
    end
    
end

