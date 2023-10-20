function [Cost,Sol] = ResultCompute(SolE,Param)
    
    PCT = Param.PCT;
    TJ = Param.TJ;
    DJ = Param.DJ;
    [rownum,~] = find(sum(SolE,2)==0);
    for i =rownum'
        if mod(i,6)==1 || mod(i,5)==4
        SolE(i,1) = 1;
        else
        SolE(i,2) = 1;
        end
    end
    Sol = SolE;
    [rownum1,~] = find(SolE(:,1)==1);
    [rownum2,~] = find(SolE(:,2)==1);
    for i = rownum1
        Cost111(i) = max([TJ(i).*(DJ(i)-PCT(i)),0]);
        Cost112(i) = max([DJ(i).*(PCT(i)-DJ(i)),0]);
        Cost12(i) = abs(sum(PCT(rownum1),[1 2])-20);
    end
    for i = rownum2
        Cost211(i) = max([TJ(i).*(DJ(i)-PCT(i)),0]);
        Cost212(i) = max([DJ(i).*(PCT(i)-DJ(i)),0]);
        Cost22(i) = abs(sum(PCT(rownum2),[1 2])-20);
    end
    Cost = sum(Cost111,[1 2]) + sum(Cost112,[1 2]) + sum(Cost12,[1 2])...
        + sum(Cost211,[1 2]) + sum(Cost212,[1 2]) + sum(Cost22,[1 2]);
    
end

