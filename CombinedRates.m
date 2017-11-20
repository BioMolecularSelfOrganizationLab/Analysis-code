
%load simZMW
kb = [0.001 0.002 0.005 0.01 0.02 0.03 0.07 0.1];
for j = 1:8
    [simZMW] = SIM_Gelsolin(1,kb(j));
    N_t = simZMW.cycles;
    
    for i = 1:N_t
        
        maxup(i) = max(simZMW.bleach{:,i});
        maxupm(i) = max(simZMW.monomers{:,i});
        %trace_d = diff(simZMW.bleach{:,i});
        %up = find(trace_d>0);
        %up_c = [0; up];
        %du = diff(up_c);
        %     if i==1
        %         dup = du;
        %     else
        %         dup = [dup;du];
        %     end
        %
    end
    mum(j) = mean(maxupm);
    mu(j) = mean(maxup);
end

% [n,x]=hist(dup,calcnbins(dup,'fd'));
% yy = find(n~=0);
% x2 = x(yy);
% n2 = n(yy);
% figure;
% loglog(x2,n2)