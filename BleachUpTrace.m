function BleachUpTrace

Brate = 0.009;
Nc = 200;
cycles = 1;
C = 1;
N = 200;
DiffDown = zeros(1,N);
MonDiffBleachTrace = zeros(4000,N);
h = waitbar(0,'Simulating, please wait...');

for j = 1:N
    waitbar(j / N)
    [simZMW] = SIM_Gelsolin(C,cycles,Brate);
    MonTrace = cell2mat(simZMW.bleach);
    
    trace_d = diff(MonTrace);
    up = find(trace_d>0);
    UpTrac = zeros(1,length(MonTrace));
    UpTrac(up) = 1;
    UpTrace = cumsum(UpTrac);
    %up_c = [0; up];
    %du = diff(up_c);
    %     if i==1
    %         dup = du;
    %     else
    %         dup = [dup;du];
    %     end
    %
    
%     Bleach = zeros(4000,1);
    BleachUP = zeros(4000,Nc);
%     Bleach(:,1) = ZMW_sim_Bleaching(MonTrace,Brate);
    
    
    
    for i=1:Nc
        
        %     Bleach(:,i) = ZMW_sim_Bleaching(MonTrace,Brate);
        BleachUP(:,i) = ZMW_sim_Bleaching(UpTrace,Brate);
        
        Ndo(i) = length(find(diff(BleachUP(:,i))<0));
        
    end
    
    MonDiffBleachTrace(:,j) = MonTrace - mean(BleachUP,2);
    
    NdoMT = length(find(diff(MonTrace)<0));
    DiffDown(j) = NdoMT-mean(Ndo);
    
end

% figure;
% [n,x] = hist(DiffDown,calcnbins(DiffDown,'fd'));
% plot(x,n,'')

MonDBT = mean(MonDiffBleachTrace,2);

figure;
plot(MonDBT,'')

% figure;
% [n,x] = hist(MonDBT,calcnbins(MonDBT,'fd'));
% plot(x,n,'')

close(h)
% figure;
% plot(UpTrace, 'r');
% hold on;
% plot(MonTrace, 'k');
% hold off;
%
% figure;
% plot(BleachUP,'r')
% hold on
% plot(Bleach,'b')
% hold off