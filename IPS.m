function [SolE, SolG, VV, z] = IPS(PCT,Param)
    
    PCT = sort(PCT,'descend');
    m = Param.m;
    n = Param.n;
    
    z = find(cumsum(PCT)<max([PCT(1),PCT(m)+PCT(m+1)...
        ,floor((1/m)*sum(PCT,[1 2]))]),1,'last');
    
    SolE = zeros(n,m,z);
    SolG = zeros(m,z);
    VV = zeros(1,z);
    
    for i = 1:z
        SolE(i,1,i) = 1;
        SolG(1,i) = PCT(i);
    end
    
    for i = 1:z
        VV(i) = var(SolG(:,i));
    end
    
    [VV,b] = sort(VV, 'descend');    
    SolE = SolE(:,:,b);
    SolG = SolG(:,b);
    
    for i = z+1:n
        if SolG(m,1)+SolG(m,1)<=SolG(1,1)
            
           SolE(i,m,1) = 1;
           SolG(m,1) = SolG(m,1) + PCT(i); 
           [SolG(:,1),~] = sort(SolG(:,1), 'descend'); 
           for j = 1:z
            VV(j) = var(SolG(:,j));
           end
           [VV,b] = sort(VV, 'descend');    
            SolE = SolE(:,:,b);
            SolG = SolG(:,b);
            
        else
            
            if (i<n)
            SolE(:,:,i+1) = zeros(n,m,1);
            SolE(i,1,i+1) = 1; 
            SolG(:,i+1) = zeros(m,1);
            SolG(:,i+1) = PCT(i+1);
            for j = 1:z
            VV(j) = var(SolG(:,j));
            end
            [VV,b] = sort(VV, 'descend');    
            SolE = SolE(:,:,b);
            SolG = SolG(:,b);
            end
            
        end
    end
    
end

