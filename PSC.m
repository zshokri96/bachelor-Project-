function [Cost,Sol] = PSC(Param)
    
PCT = Param.PCT;
[SolE, SolG, VV, z] = IPS(PCT,Param);
zz=z;

for i = 1:z-1
[SolE3,SolG3] = Combine(SolE(:,:,1),SolE(:,:,2),PCT,Param);
zz = zz+1;
SolE(:,:,zz) = SolE3;
SolG(:,zz) = SolG3;
    for i = 1:zz
        VV(i) = var(SolG(:,i));
    end
    
    [VV,b] = sort(VV, 'descend');    
    SolE = SolE(:,:,b);
    SolG = SolG(:,b);
    
end

[Cost,Sol] = ResultCompute(SolE(:,:,end),Param);

end

