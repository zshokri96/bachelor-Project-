function [ExpPT,ErPT,UPT,WPT] = ProcessTimeGenerator()
    
    Param = InputParameter();
    m = Param.m;
    n = Param.n;
    TJ = Param.TJ;
    ExpP = Param.ExpP;
    ErP = Param.ErP;
    UP = Param.UP;
    WP = Param.WP;
    %% Exponential Distribution
    ExpPT = zeros(1,15);
    for i = 1:numel(ExpPT)
        ExpPT(i) = exprnd(1/ExpP(i));
    end
    %% Erlang Distribution
    ErPT = zeros(1,7);
    for i = 1:numel(ErPT)
        ErPT(i) = gamrnd(1/ErP(1,i),ErP(2,i));
    end
    %% Uniform Distribution
    UPT = zeros(1,8);
    for i = 1:numel(UPT)
        UPT(i) = unifrnd(UP(1,i),UP(2,i));
    end
    %% WeiBull Distribution
    WPT = zeros(1,5);
    for i = 1:numel(WPT)
        WPT(i) = wblrnd(WP(1,i),WP(2,i));
    end
    
end

